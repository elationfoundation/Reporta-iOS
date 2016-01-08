 //
 //  MediaListViewController.swift
 //  IWMF
 //
 // This class is used for display Pending media of Check-in Or Alert.
 //
 //
 
 import UIKit

 class MediaListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, WSClientDelegate {
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viewheader: UIView!
    @IBOutlet weak var pendingListLable: UILabel!
    var arrMedia : NSMutableArray!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pendingListLable.text=NSLocalizedString(Utility.getKey("txt_pending_media"),comment:"")
        self.pendingListLable.font = Utility.setDetailFont()
        
        arrMedia = [] as NSMutableArray
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var rect = self.viewheader.frame;
            rect.size.height = 50;
            self.viewheader.frame = rect;
            self.tbl.tableHeaderView = self.viewheader;
        });
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            pendingListLable.textAlignment = NSTextAlignment.Right
        }
        else
        {
            pendingListLable.textAlignment = NSTextAlignment.Left
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func viewWillAppear(animated: Bool) {
        
        loadMediaFiles()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func loadMediaFiles(){
        let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
        var getMediaArray : NSArray! = [] as NSArray
        getMediaArray = CommonUnit.getDataFroKey(KEY_PENDING_MEDIA, fromFile: userName)
        if (getMediaArray != nil){
            if  (getMediaArray?.count>0){
                arrMedia.addObjectsFromArray(getMediaArray as [AnyObject])
                tbl.reloadData()
            }
        }
    }
    override func viewDidAppear(animated: Bool){
        let expiredVideo = NSMutableArray()
        let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
        for media in arrMedia{
            let tempMedia = media as! Media
            let sevenDaysLater = NSDate(timeInterval: (7*24*60*60), sinceDate: tempMedia.time)
            if NSDate().compare(sevenDaysLater) == NSComparisonResult.OrderedDescending{
                expiredVideo.addObject(tempMedia)
            }
        }
        if  expiredVideo.count > 0{
            for media in expiredVideo{
                let tempMedia = media as! Media
                CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                CommonUnit.removeFile(tempMedia.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
                sendMailWithMedia(tempMedia)
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                var title = ""
                if  expiredVideo.count > 1{
                    title = NSLocalizedString(Utility.getKey("media_not_uploaded_from_7_day"),comment:"")
                }else{
                    title = NSLocalizedString(Utility.getKey("one_media_not_uploaded_from_7_day"),comment:"")
                }
                let message = ""
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.loadMediaFiles()
                    })
                    })
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView DataSource and Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMedia.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("mediacell") as? MediaCell
        let obj = arrMedia[indexPath.row] as!  Media
        cell?.setValues(obj.name, imageType: obj.mediaType)
        return cell!
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: NSLocalizedString(Utility.getKey("menu_delete"),comment:"") , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            //Action
            let obj = self.arrMedia[indexPath.row] as!  Media
            CommonUnit.deleteSingleFile(obj.name, fromDirectory: "/Media/")
            self.arrMedia.removeObjectAtIndex(indexPath.row)
            CommonUnit.removeFile(obj.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
            self.arrMedia.removeAllObjects()
            self.arrMedia.addObjectsFromArray(CommonUnit.getDataFroKey(KEY_PENDING_MEDIA, fromFile: userName) as [AnyObject])
            SVProgressHUD.showSuccessWithStatus(NSLocalizedString(Utility.getKey("successfully_deleted"),comment:""))
            self.sendMailWithMedia(obj)
            self.tbl.reloadData()
        })
        shareAction.backgroundColor = UIColor.orangeColor()
        let rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: NSLocalizedString(Utility.getKey("menu_resend"),comment:"") , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let obj = self.arrMedia[indexPath.row] as!  Media
            if  Utility.isConnectedToNetwork(){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("uploading_current_media"),comment:""), maskType: 4)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            Media.sendMediaObjectOnOtherThread(obj, completionClosure: { (isSuccess) -> Void in
                                if isSuccess
                                {
                                    CommonUnit.deleteSingleFile(obj.name, fromDirectory: "/Media/")
                                    self.arrMedia.removeObjectAtIndex(indexPath.row)
                                    CommonUnit.removeFile(obj.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
                                    self.arrMedia.removeAllObjects()
                                    self.arrMedia.addObjectsFromArray(CommonUnit.getDataFroKey(KEY_PENDING_MEDIA, fromFile: userName) as [AnyObject])
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.tbl.reloadData()
                                        self.sendMailWithMedia(obj)
                                    })
                                    SVProgressHUD.showSuccessWithStatus(NSLocalizedString(Utility.getKey("successfully_uploaded"),comment:""))
                                }
                                else{
                                    SVProgressHUD.dismiss()
                                    
                                    Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("failed_to_upload_media"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                                    
                                }
                            })
                        })
                    })
                });
            }else{
                SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
            }
            self.tbl.reloadData()
        })
        return [shareAction,rateAction]
    }
    
    //MARK: - Send Mail with Media
    func sendMailWithMedia(tempMedia: Media)
    {
        var isMediaPending : Bool!
        let currentNotificationID = tempMedia.notificationID as NSNumber
        isMediaPending = false
        for (var i : Int = 0; i < self.arrMedia.count ; i++)
        {
            
            let objMedia = self.arrMedia[i] as!  Media
            if objMedia.notificationID == currentNotificationID
            {
                isMediaPending = true
                break
            }
        }
        if isMediaPending == false
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //All Media Sent Successfully
                let dic : NSMutableDictionary = NSMutableDictionary()
                dic [Structures.Media.ForeignID] = tempMedia.notificationID
                dic [Structures.Media.TableID] = tempMedia.noficationType.rawValue
                let wsObj : WSClient = WSClient()
                wsObj.delegate = self
                wsObj.sendMailWithMedia(dic)
            })
        }
    }
    // MARK: - Button Functions
    @IBAction func closeclicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if  (response is NSString)
        {
            SVProgressHUD.dismiss()
        }
        else
        {
            let data : NSData? = NSData(data: response as! NSData)
            if   (data != nil)
            {
                if  type == WSRequestType.SendMailWithMedia
                {
                    if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                                SVProgressHUD.dismiss()
                            })
                        }
                    }
                }
            }
            else
            {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func WSResponseEoor(error:NSError, ReqType type:WSRequestType)
    {
        SVProgressHUD.dismiss()
        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
    }
 }
