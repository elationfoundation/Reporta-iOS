//
//  AlertViewController.swift
//  IWMF
//
// This class is used for create user interface of Alert and implemented functionality of Send Alert.
//
//

import UIKit
import CoreLocation

class AlertViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CheckInDescriptionProtocol, LocationDetailProtocol, SendAlertButtonProtocol,AlertSituationProtocol, MediaDetailProtocol, CheckInContactProtocol, WSClientDelegate, CheckInSocialProtocol,AlertModalProtocol {
    @IBOutlet weak var verticleSpaceAnimationScreen: NSLayoutConstraint!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet var btnInfo : UIButton!
    @IBOutlet var btnHome : UIButton!
    @IBOutlet weak var alertLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    var descriptionScreen : CheckInDescriptionViewController!
    var locationDetailScreen : LocationViewController!
    var situationScreen : SituationViewController!
    var alertArray : NSMutableArray!
    var alert : Alert!
    var devide : CGFloat!
    var userDetail = User()
    var arrPublicContacts : NSMutableArray = NSMutableArray()
    var arrPrivateContacts : NSMutableArray = NSMutableArray()
    var isIbuttonOpen : Bool!
    var arrPrivateCircle : NSMutableArray = NSMutableArray()
    var circlePrivate : Circle!
    var circlePublic : Circle!
    var situationTemp : NSString!
    var strFbToken, strTwToken, strTwTokenSecret : NSString!
    override func viewDidLoad() {
        devide = 1
        self.userDetail = self.userDetail.getLoggedInUser()!
        alert = Alert()
        strFbToken = ""
        strTwToken = ""
        strTwTokenSecret = ""
        textView.selectable = false
        getContactListWithData()
        self.alertLable.font = Utility.setNavigationFont()
        alertLable.text=NSLocalizedString(Utility.getKey("alerts"),comment:"")
        
        self.verticleSpaceAnimationScreen.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
        self.infoView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)
        
        super.viewDidLoad()
        
        var arrAlertTemp : NSMutableArray!
        alertArray = NSMutableArray()
        if let path = NSBundle.mainBundle().pathForResource("Alert", ofType: "plist")
        {
            arrAlertTemp = NSMutableArray(contentsOfFile: path)
            
            let arrTemp : NSMutableArray = NSMutableArray(array: arrAlertTemp)
            
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        
                        let strOptionTitle = innerDict["OptionTitle"] as! String!
                        if strOptionTitle != nil
                        {
                            if strOptionTitle == "Add"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("add"),comment:"")
                            }
                            else if strOptionTitle == "Choose Location"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Choose Location"),comment:"")
                            }
                            else if strOptionTitle == "Edit"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                            }
                            else if strOptionTitle == "Optional"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("optional"),comment:"")
                            }
                        }
                        
                        
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        arrAlertTemp.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        }
        
        
        
        self.alert.contactLists =  arrPublicContacts
        Structures.Constant.appDelegate.commonLocation.getUserCurrentLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate:", name:Structures.Constant.LocationUpdate, object: nil)
        
        for (_, element) in arrAlertTemp.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == "SelectedContactsList"{
                    if arrPublicContacts.count > 0{
                        for (index, element) in arrPublicContacts.enumerate(){
                            let dict = NSMutableDictionary(dictionary: innerDict)
                            if let conList = element as? ContactList{
                                dict["Title"] = conList.contactListName
                                dict["ContactListID"] = conList.contactListID as Int
                                if index == arrPublicContacts.count-1{
                                    dict["Level"] = "Bottom"
                                }else{
                                    dict["Level"] = "Middle"
                                }
                            }
                            self.alertArray.addObject(dict)
                        }
                    }
                    continue
                }
                self.alertArray.addObject(innerDict)
            }
        }
        
        self.tableView.registerNib(UINib(nibName: "CheckInDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.CheckInDetailIdentifier)
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "CheckInFooterTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.CheckInFooterCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "LocationListingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.LocationListingCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "SendAlertTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.SendAlertIdentifier)
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
        self.tableView.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARLocationListingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Structures.Constant.appDelegate.prefrence.isFacebookSelected = false
        Structures.Constant.appDelegate.prefrence.isTwitterSelected = false
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
        setUpUpperInfoView()
        self.infoView.hidden = true
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnHome.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Right
        }
        else
        {
            btnHome.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Left
        }
        
        isIbuttonOpen = false
        Structures.Constant.appDelegate.showSOSButton()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Structures.Constant.LocationUpdate, object: nil)
        
        descriptionScreen = nil
        locationDetailScreen = nil
        situationScreen = nil
        alertArray = nil
        alert = nil
        devide = nil
        circlePrivate  = nil
        circlePublic = nil
        arrPublicContacts.removeAllObjects()
        arrPrivateContacts.removeAllObjects()
        arrPrivateCircle.removeAllObjects()
        tableView = nil
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationUpdate(notification: NSNotification)
    {
        let location = notification.object as! CLLocation!
        self.alert.latitude = NSNumber(double: location.coordinate.latitude)
        self.alert.longitude = NSNumber(double: location.coordinate.longitude)
    }
    
    @IBAction func btnHomePressed(sender: AnyObject) {
        if Structures.Constant.appDelegate.isArabic == true
        {
            setIBtnView()
        }
        else
        {
            backToPreviousScreen()
        }
        
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnInfoPressed(sender: AnyObject) {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            backToPreviousScreen()
        }
        else
        {
            setIBtnView()
        }
    }
    @IBAction func arrowBtnPressed(sender: AnyObject) {
        
        setIBtnView()
        
    }
    
    func setIBtnView(){
        if isIbuttonOpen == false
        {
            self.view.bringSubviewToFront(self.infoView)
            self.infoView.hidden = false
            isIbuttonOpen = true
            UIView.animateWithDuration(0.80, delay: 0.1, options: .CurveEaseOut , animations: {
                self.verticleSpaceAnimationScreen.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                self.infoView.frame.origin.y += (UIScreen.mainScreen().bounds.size.height)
                }, completion: nil)
            
        }
        else
        {
            isIbuttonOpen = false
            
            UIView.animateWithDuration(0.80, delay: 0.1, options:  .CurveEaseInOut , animations: {
                self.verticleSpaceAnimationScreen.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                self.infoView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)
                
                }, completion: {
                    finished in
                    self.infoView.hidden = true
                    self.view.bringSubviewToFront(self.tableView)
            })
        }
        
    }
    
    func setUpUpperInfoView(){
        self.textView.text = NSLocalizedString(Utility.getKey("Alerts - i button"),comment:"")
    }
    func changeValueInMainCheckInArray(newValue : NSString, identity : NSString){
        for (index, element) in self.alertArray.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == identity{
                    innerDict["Value"] = newValue
                    if iden == "Location"{
                        innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Update"),comment:"")
                    }
                    if iden == "Situation"{
                        innerDict["Title"] = newValue
                    }
                    if iden == "Media"{
                        if self.alert.mediaArray.count > 0{
                            innerDict["OptionTitle"] =  NSLocalizedString(Utility.getKey("Edit"),comment:"")
                        }
                    }
                    self.alertArray.replaceObjectAtIndex(index, withObject: innerDict)
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }
    
    // MARK: - CheckIn Description
    func checkInDescription(description : NSString){
        self.alert.alertDescription = description
        changeValueInMainCheckInArray(description, identity: "Description")
    }
    //MARK: - Location Changed Delegate Method
    func locationTextChanged(changedText : NSString, location : CLLocation){
        self.alert.latitude = NSNumber(double: location.coordinate.latitude)
        self.alert.longitude = NSNumber(double: location.coordinate.longitude)
        self.alert.address = changedText
        changeValueInMainCheckInArray(changedText, identity: "Location")
    }
    //MARK: - CheckIn ContactList View Controller Delegate Methods
    func checkInSocial(strTwitterToken: NSString, strTwitterSecret: NSString, strFacebookToken: NSString)
    {
        strFbToken = strFacebookToken
        strTwToken = strTwitterToken
        strTwTokenSecret = strTwitterSecret
        self.tableView.reloadData()
    }
    func checkInContact(arr : NSMutableArray?, type: viewType!){
        
        if type == viewType.Public
        {
            arrPublicContacts = arr!
        }
        else if type == viewType.Private
        {
            arrPrivateCircle = arr!
        }
        self.tableView.reloadData()
    }
    
    
    func validateCheckIn() -> Bool{
        
        
        var isValidInfo : Bool = true
        var strTitle : String = ""
        
        if self.alert.situation.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("choose_valid_situation"),comment:"")
        }else if self.alert.situation == "Other" && self.alert.alertDescription.length == 0 {
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("enter_valid_description"),comment:"")
        }else if self.alert.address.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("choose_valid_location"),comment:"")
        }else if self.alert.latitude.doubleValue == 0 || self.alert.longitude.doubleValue == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("choose_valid_location"),comment:"")
        }else if self.alert.contactLists.count == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("enter_valid_contact"),comment:"")
        }
        if isValidInfo == false{
            Utility.showAlertWithTitle(strTitle, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
        return isValidInfo
    }
    //MARK : - SendAlert Delegate Protocol
    func SendAlertBtnPressed(){
        self.alert.contactLists.removeAllObjects()
        self.alert.contactLists.addObjectsFromArray(arrPrivateCircle as [AnyObject])
        self.alert.contactLists.addObjectsFromArray(self.arrPublicContacts as [AnyObject])
        self.alert.fbToken = strFbToken
        self.alert.twitterToken = strTwToken
        self.alert.twitterTokenSecret = strTwTokenSecret
        if !validateCheckIn(){
            return
        }
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("sending_alert"),comment:""), maskType: 4)
        Alert.sendAlert(self.alert)
        Alert.sharedInstance.delegate = self
    }
    func commonAlertResponse(alertID : NSNumber ,dict : NSDictionary, isSuccess : Bool)
    {
        if isSuccess{
            
            if self.alert.mediaArray.count == 0
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title:NSLocalizedString(Utility.getKey("alert_sent_successfully"),comment:"") , message:"", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                        self.backToPreviousScreen()
                    }))
                    self.presentViewController(alert, animated: true, completion:nil)
                })
            }
            self.alert.alertID = alertID
            let totalCnt : Int  = self.alert.mediaArray.count
            var uploadingSuccessFully : Bool = true
            for  _ in self.alert.mediaArray{
                if !uploadingSuccessFully{
                    break
                }
                
                let strIndi : String = String(format: NSLocalizedString(Utility.getKey("uploading_of"),comment:""), totalCnt+1 - self.alert.mediaArray.count, totalCnt)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.showWithStatus(strIndi, maskType: 4)
                })
                
                let tempMedia : Media = self.alert.mediaArray[0]
                tempMedia.notificationID = self.alert.alertID
                
                Media.sendMediaObject(tempMedia, completionClosure: { (isSuccess) -> Void in
                    if  isSuccess == true
                    {
                        
                        if tempMedia.mediaType == MediaType.Video
                        {
                            CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                        }
                        else  if tempMedia.mediaType == MediaType.Image
                        {
                            CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                        }
                        else  if tempMedia.mediaType == MediaType.Audio
                        {
                            CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                        }
                        self.alert.mediaArray.removeAtIndex(0)
                    }
                    else{
                        
                        // add in pending array
                        uploadingSuccessFully = false
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.appendPendingMedia()
                            let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("failed_to_upload_all_media"),comment:""), message: "", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                                self.backToPreviousScreen()
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                    if self.alert.mediaArray.count == 0
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //All Media Sent Successfully
                            let dic : NSMutableDictionary = NSMutableDictionary()
                            dic [Structures.Media.ForeignID] = self.alert.alertID
                            dic [Structures.Media.TableID] = NotificationType.Alert.rawValue
                            let wsObj : WSClient = WSClient()
                            wsObj.delegate = self
                            wsObj.sendMailWithMedia(dic)
                            
                            SVProgressHUD.showSuccessWithStatus(NSLocalizedString(Utility.getKey("all_media_uploaded"),comment:""))
                            SVProgressHUD.show()
                            
                        })
                    }
                })
            }
        }
        else
        {
            for tempMedia in self.alert.mediaArray
            {
                if tempMedia.mediaType == MediaType.Video
                {
                    CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                }
                else  if tempMedia.mediaType == MediaType.Image
                {
                    CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                }
                else  if tempMedia.mediaType == MediaType.Audio
                {
                    CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
                if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        Utility.showLogOutAlert((dict.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                    }
                }else{
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        Utility.showAlertWithTitle((dict.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                    }
                }
            })
        }
    }
    func appendPendingMedia()
    {
        if self.alert.mediaArray.count > 0 {
            let arrStore : NSMutableArray = NSMutableArray()
            for (var i : Int = 0; i < self.alert.mediaArray.count ; i++)
            {
                let tempMedia : Media = self.alert.mediaArray[i]
                tempMedia.notificationID = self.alert.alertID
                arrStore.addObject(tempMedia)
            }
            let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
            CommonUnit.appendDataWithKey(KEY_PENDING_MEDIA, inFile: userName, list: arrStore)
            SVProgressHUD.dismiss()
        }
    }
    func alertSituation(situation: NSString)
    {
        situationTemp = situation
        var arrTemp : NSArray!
        var strTemp : NSMutableString!
        strTemp = ""
        if situation.length > 0
        {
            arrTemp = NSMutableArray(array: situation.componentsSeparatedByString(",, "))
            for(var i : Int = 0 ; i < arrTemp.count ; i++)
            {
                if arrTemp.count == 1{
                    strTemp.appendString((arrTemp.objectAtIndex(i) as! String))
                }
                else if arrTemp.count - 1 == i{
                    strTemp.appendString((arrTemp.objectAtIndex(i) as! String))
                }
                else{
                    strTemp.appendString((arrTemp.objectAtIndex(i) as! String))
                    strTemp.appendString(", ")
                }
            }
        }
        self.alert.situation = strTemp
        changeValueInMainCheckInArray(strTemp, identity: "Situation")
    }
    //MARK : - AddMedia Delegate Method
    func addMedia(mediaObject: Media) {
        if self.alert.mediaArray.isEmpty {
            self.alert.mediaArray = [mediaObject]
        }
        else{
            self.alert.mediaArray.append(mediaObject)
        }
        changeValueInMainCheckInArray("", identity: "Media")
        
    }
    //MARK : - TableViewMethods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.alertArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kRowHeight = self.alertArray[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kRowHeight = self.alertArray[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let kCellIdentifier = self.alertArray[indexPath.row]["CellIdentifier"] as! String
        
        if let cell: TitleTableViewCell2 = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell2 {
            cell.levelString = self.alertArray[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.alertArray[indexPath.row]["Title"] as! String!
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Left
            }
            cell.intialize()
            return cell
        }
        
        if let cell: CheckInDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? CheckInDetailTableViewCell {
            cell.value = self.alertArray[indexPath.row]["Value"] as! NSString!
            cell.identity = self.alertArray[indexPath.row]["Identity"] as! String!
            cell.title = self.alertArray[indexPath.row]["Title"] as! String!
            cell.intialize()
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.textView.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.textView.textAlignment = NSTextAlignment.Left
            }
            return cell
        }
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.LocationListingCellIdentifier
        {
            if let cell: ARLocationListingCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier) as? ARLocationListingCell {
                cell.value = self.alertArray[indexPath.row]["Value"] as! NSString!
                cell.detail = self.alertArray[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.alertArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: LocationListingCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? LocationListingCell {
                cell.value = self.alertArray[indexPath.row]["Value"] as! NSString!
                cell.detail = self.alertArray[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.alertArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier
        {
            if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier) as? ARTitleTableViewCell {
                
                cell.lblDetail.text = self.alertArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.alertArray[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.alertArray[indexPath.row]["Title"] as! String!
                cell.type = self.alertArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                
                if ( self.alertArray[indexPath.row]["Identity"] as! NSString == "PublicContactsList"  )
                {
                    if arrPublicContacts.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                    else
                    {
                        cell.lblTitle.textColor = UIColor.grayColor()
                    }
                }
                else if ( self.alertArray[indexPath.row]["Identity"] as! NSString == "SocialMediaList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    
                    if !strTwToken.isEqualToString("") || !strFbToken.isEqualToString("")
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.alertArray[indexPath.row]["Identity"] as! NSString == "PrivateContactsList"  )
                {
                    if arrPrivateCircle.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                return cell
                
            }
        }
        else
        {
            if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell {
                
                cell.lblDetail.text = self.alertArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.alertArray[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.alertArray[indexPath.row]["Title"] as! String!
                cell.type = self.alertArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                
                if ( self.alertArray[indexPath.row]["Identity"] as! NSString == "PublicContactsList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if arrPublicContacts.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text =  NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.alertArray[indexPath.row]["Identity"] as! NSString == "SocialMediaList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    
                    if !strTwToken.isEqualToString("") || !strFbToken.isEqualToString("")
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.alertArray[indexPath.row]["Identity"] as! NSString == "PrivateContactsList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if arrPrivateCircle.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier) as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = self.alertArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.alertArray[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.alertArray[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.alertArray[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.alertArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell
            {
                cell.lblSubDetail.text = self.alertArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.alertArray[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.alertArray[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.alertArray[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.alertArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        if let cell: SendAlertTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? SendAlertTableViewCell {
            cell.delegate = self
            cell.intialize()
            return cell
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if  self.alertArray[indexPath.row]["Method"] as! NSString! == "showDescriptionScreen"{
            showDescriptionScreen(self.alertArray[indexPath.row]["Value"] as! NSString)
        }
        if  self.alertArray[indexPath.row]["Method"] as! NSString! == "showLocationDetailScreen"{
            showLocationDetailScreen(self.alertArray[indexPath.row]["Value"] as! NSString)
        }
        if  self.alertArray[indexPath.row]["Method"] as! NSString! == "showSituationScreen"{
            if self.alertArray[indexPath.row]["Title"] as! NSString != NSLocalizedString(Utility.getKey("I am facing"),comment:"")
            {
                showSituationScreen(situationTemp)
            }
            else
            {
                showSituationScreen(self.alertArray[indexPath.row]["Title"] as! NSString)
            }
        }
        if  self.alertArray[indexPath.row]["Method"] as! NSString! == "showAllContactsList"{
            showAllContactsList(indexPath.row)
        }
        if  self.alertArray[indexPath.row]["Method"] as! NSString! == "showMideaPickerView"{
            showMideaPickerView()
        }
    }
    func showSituationScreen(text : NSString){
        situationScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SituationViewController") as! SituationViewController
        if let viewController = situationScreen{
            viewController.delegat = self
            if text == NSLocalizedString(Utility.getKey("I am facing"),comment:"")
            {
                viewController.situationTitle = ""
            }
            else
            {
                viewController.situationTitle = text
            }
            showViewController(viewController, sender: self.view)
        }
    }
    func showDescriptionScreen(text : NSString){
        descriptionScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckInDescriptionViewController") as! CheckInDescriptionViewController
        if let viewController = descriptionScreen{
            viewController.delegate = self
            viewController.textViewText = text
            viewController.changeTitle = 1
            showViewController(viewController, sender: self.view)
        }
    }
    func showLocationDetailScreen(text : NSString){
        autoreleasepool { () -> () in
            locationDetailScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationViewController") as! LocationViewController
            if let viewController = locationDetailScreen{
                viewController.delegate = self
                viewController.userLocation = CLLocation(latitude: self.alert.latitude.doubleValue, longitude: self.alert.longitude.doubleValue)
                viewController.userLocationString = text
                viewController.changeTitle = 1
                showViewController(viewController, sender: self.view)
            }
        }
    }
    func showMideaPickerView(){
        let mediaPickerScreen : MediaPickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MediaPickerViewController") as! MediaPickerViewController
        mediaPickerScreen.delegate = self
        mediaPickerScreen.mediaFor = .Alert
        showViewController(mediaPickerScreen, sender: self.view)
        
    }
    
    func showAllContactsList(SelectedRow: NSInteger)
    {
        let circleScreen : CreateOrSaveCircleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateOrSaveCircleVC") as! CreateOrSaveCircleVC
        circleScreen.delegate = self
        circleScreen.changeTitle = 1
        
        if self.alertArray.objectAtIndex(SelectedRow).valueForKey("Identity") as? NSString == viewType.Private.rawValue{
            circleScreen.myViewType = viewType.Private
            circleScreen.arrSelected = arrPrivateCircle
            circlePrivate = Circle(name:"Private", type:.Private,contactList:[])
            if  (circlePrivate == nil)
            {
                circlePrivate = Circle(name:"Private", type:.Private,contactList:[])
            }
            circleScreen.circle = circlePrivate
            showViewController(circleScreen, sender: self.view)
            
        }
        else if self.alertArray.objectAtIndex(SelectedRow).valueForKey("Identity") as? NSString == viewType.Public.rawValue
        {
            circleScreen.myViewType = viewType.Public
            circleScreen.arrSelected = arrPublicContacts
            circlePublic = Circle(name:"Public", type:.Public,contactList:[])
            if  (circlePublic == nil)
            {
                circlePublic = Circle(name:"Public", type:.Private,contactList:[])
            }
            circleScreen.circle = circlePublic
            showViewController(circleScreen, sender: self.view)
        }
        else if self.alertArray.objectAtIndex(SelectedRow).valueForKey("Identity") as? NSString == viewType.Social.rawValue
        {
            let circleScreen : SocialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SocialViewController") as! SocialViewController
            circleScreen.mySocialViewFrom = socialViewFrom.Alert
            circleScreen.delegate = self
            showViewController(circleScreen, sender: self.view)
        }
    }
    //MARK:- WSDelegate
    func getContactListWithData()
    {
        SVProgressHUD.show()
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.getContactListWithData(dic)
        
    }
    
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if  (response is NSString)
        {
            SVProgressHUD.dismiss()
        }
        else
        {
            if let data : NSData? = NSData(data: response as! NSData)
            {
                if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if  type == WSRequestType.GetContactList
                    {
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            let arrCircle : NSArray  = dic.valueForKey("data") as! NSArray
                            for (var i = 0 ; i < arrCircle.count ; i++)
                            {
                                if arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1" &&  arrCircle.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "1"
                                {
                                    arrPrivateCircle.removeAllObjects()
                                    arrPrivateCircle.addObject(arrCircle.objectAtIndex(i))
                                }
                                else if arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1" &&  arrCircle.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "2"
                                {
                                    arrPublicContacts.removeAllObjects()
                                    arrPublicContacts.addObject(arrCircle.objectAtIndex(i))
                                }
                            }
                            dispatch_async(dispatch_get_main_queue())
                                {
                                    self.tableView.reloadData()
                            }
                            SVProgressHUD.dismiss()
                        }
                        else if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3")
                        {
                            SVProgressHUD.dismiss()
                            if dic.valueForKey(Structures.Constant.Message) != nil
                            {
                                Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                            }
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                    else if  type == WSRequestType.SendMailWithMedia
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                SVProgressHUD.dismiss()
                                let alert = UIAlertController(title:NSLocalizedString(Utility.getKey("alert_sent_successfully"),comment:"") , message:"", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                                    self.backToPreviousScreen()
                                }))
                                self.presentViewController(alert, animated: true, completion:nil)
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
