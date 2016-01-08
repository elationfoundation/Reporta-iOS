//
//  HomeViewController.swift
//  IWMF
//
//  This class is used for display Home Screen.
//
//

import Foundation
import UIKit
import CoreLocation

class HomeViewController: UIViewController,WSClientDelegate {
    @IBOutlet weak var lblContacts: UILabel!
    @IBOutlet weak var lblAlerts: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblProfile: UILabel!
    var user = User()
        @IBOutlet weak var lblPendingFiles: UILabel!
    @IBOutlet weak var learnAbtReorta: UIButton!
    @IBOutlet weak var pendingMediaCounts: UILabel!
    @IBOutlet weak var btnPendingMedia: UIButton!
    @IBOutlet weak var btnFour: UIButton!//Profile
    @IBOutlet weak var btnThree: UIButton!//Contact
    @IBOutlet weak var btnOne: UIButton!//CheckIn
    @IBOutlet weak var btnTwo: UIButton!//Alerts
    @IBOutlet weak var lblIWMF: UILabel!
    @IBOutlet weak var lblPoweredBy: UILabel!
    var isLock : Bool = false
    var uploadingContinue : Bool = false
    var arrMediaFiles = NSMutableArray()
    @IBOutlet weak var ENlblPendingFiles: UILabel!
    @IBOutlet weak var ENlearnAbtReorta: UIButton!
    @IBOutlet weak var ENpendingMediaCounts: UILabel!
    @IBOutlet weak var ENbtnPendingMedia: UIButton!
    @IBOutlet weak var viewBottomArabic: UIView!
    @IBOutlet weak var viewBottomEng: UIView!
    var locationNew : CLLocation!
    var locationOld : CLLocation!
    var isLocationUpdated : Bool!
    
    @IBOutlet weak var viewReportaHeight: NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popToRootView:", name:"popToRootView", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate:", name:Structures.Constant.LocationUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showCheckInNotification:", name:"showCheckInNotification", object: nil)
        user = user.getLoggedInUser()!
        Structures.Constant.appDelegate.initializeSOSButton()
        //Load County List
        Structures.Constant.appDelegate.countryListUpdate()
        Structures.Constant.appDelegate.contactScreensFrom =  ContactsFrom.CheckIn
        isLocationUpdated = false
        
        //Set Font
        self.lblAlerts.font = Utility.setFont()
        self.lblProfile.font = Utility.setFont()
        self.lblContacts.font = Utility.setFont()
        self.lblCheckIn.font = Utility.setFont()
        
        //setup View Layout
        
        self.pendingMediaCounts.textColor = UIColor.orangeColor()
        self.ENpendingMediaCounts.textColor = UIColor.orangeColor()
        
        //Set Home Icon and Bottom Button
        lblAlerts.text = NSLocalizedString(Utility.getKey("alerts"),comment:"")//alerts
        lblProfile.text = NSLocalizedString(Utility.getKey("profile"),comment:"")//profile
        lblContacts.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")//contacts
        lblCheckIn.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")//check_in
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            viewBottomArabic.hidden = false
            viewBottomEng.hidden = true
            
            
            lblAlerts.text = NSLocalizedString(Utility.getKey("alerts"),comment:"")
            lblProfile.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
            lblContacts.text = NSLocalizedString(Utility.getKey("profile"),comment:"")
            lblCheckIn.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
            
            btnOne.setImage(UIImage(named: "3.png") as UIImage!, forState: .Normal)//Checkin
            btnTwo.setImage(UIImage(named: "2.png") as UIImage!, forState: .Normal)//Alerts
            btnThree.setImage(UIImage(named: "4.png") as UIImage!, forState: .Normal)//Contact
            btnFour.setImage(UIImage(named: "1.png") as UIImage!, forState: .Normal)//Profile
        }
        else
        {
            viewBottomArabic.hidden = true
            viewBottomEng.hidden = false
        }
        
        //Set Text and button color of bottom button
        self.lblPendingFiles.text = NSLocalizedString(Utility.getKey("pending_media_files"),comment:"")
        ENlblPendingFiles.text = lblPendingFiles.text
        
        learnAbtReorta.setTitle(NSLocalizedString(Utility.getKey("about_reporta"),comment:""), forState: .Normal)
        ENlearnAbtReorta.setTitle(NSLocalizedString(Utility.getKey("about_reporta"),comment:""), forState: .Normal)
        
        learnAbtReorta.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        ENlearnAbtReorta.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        if(CommonUnit.isIphone4()){
            viewReportaHeight.constant = 80
            
            self.learnAbtReorta.titleLabel?.font = Structures.Constant.Roboto_Regular12
            self.lblPendingFiles.font = Structures.Constant.Roboto_Regular12
        }
        if(CommonUnit.isIphone5()){
            self.learnAbtReorta.titleLabel?.font = Structures.Constant.Roboto_Regular12
            self.lblPendingFiles.font = Structures.Constant.Roboto_Regular12
        }
        if(CommonUnit.isIphone6()){
            self.learnAbtReorta.titleLabel?.font = Structures.Constant.Roboto_Regular14
            self.lblPendingFiles.font = Structures.Constant.Roboto_Regular14
        }
        if(CommonUnit.isIphone6plus()){
            self.learnAbtReorta.titleLabel?.font = Structures.Constant.Roboto_Regular16
            self.lblPendingFiles.font = Structures.Constant.Roboto_Regular16
        }
        
        ENlearnAbtReorta.titleLabel?.font =  self.lblPendingFiles.font
        ENlblPendingFiles.font = self.lblPendingFiles.font
        
        //If any how local notification of old / Missed Check in are not cleared
        if !CheckIn.isAnyCheckInActive()
        {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
        //Check User Lock Status. if lockStatus = 1 tahn user locked otherwise not
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.lockApp()
        })
    }
    func showCheckInNotification(notification: NSNotification){
        
        let  dictUserInfo = notification.object as! NSDictionary
        let ciNotificationViewController : CheckinNotificationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckinNotificationViewController") as! CheckinNotificationViewController
        
        ciNotificationViewController.checkInID = NSNumber(integer: dictUserInfo["CheckInID"] as! Int)
        if dictUserInfo[Structures.CheckIn.Status] as? NSString == Structures.CheckInStatus.Reminder
        {
            ciNotificationViewController.notiType = .ConfirmationReminder
        }
        else if dictUserInfo[Structures.CheckIn.Status] as? NSString == Structures.CheckInStatus.Confirmation
        {
            ciNotificationViewController.notiType = .ConfirmNow
        }
        else if dictUserInfo[Structures.CheckIn.Status] as? NSString == Structures.CheckInStatus.StartReminder
        {
            ciNotificationViewController.notiType = .StartReminder
        }
        else if dictUserInfo[Structures.CheckIn.Status] as? NSString == Structures.CheckInStatus.Start
        {
            ciNotificationViewController.notiType = .StartNow
        }
        else if dictUserInfo[Structures.CheckIn.Status] as? NSString == Structures.CheckInStatus.CloseReminder
        {
            ciNotificationViewController.notiType = .CloseReminder
        }
        else if dictUserInfo[Structures.CheckIn.Status] as? NSString == Structures.CheckInStatus.CheckInClosed
        {
            Utility.removeAllPendingMedia()
            ciNotificationViewController.notiType = .CloseNow
        }
        showViewController(ciNotificationViewController, sender : nil)

    }
    override func viewWillAppear(animated: Bool) {
 
        self.view.endEditing(true)
        super.viewWillAppear(animated)
        
        self.pendingMediaCounts.text = String(0)
        self.ENpendingMediaCounts.text = String(0)
        
        btnPendingMedia.userInteractionEnabled = false
        ENbtnPendingMedia.userInteractionEnabled = false
        Structures.Constant.appDelegate.showSOSButton()
        Structures.Constant.appDelegate.contactScreensFrom =  ContactsFrom.Home
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if self.user.lockstatus != 1 && Structures.Constant.appDelegate.prefrence.ApplicationState != 1
            {
                self.showUploadMediaAlert()
            }
        })
        
    }
    func lockApp()
    {
        if self.user.lockstatus == 1 || Structures.Constant.appDelegate.prefrence.ApplicationState == 1
        {
            Utility.removeAllPendingMedia()
            Structures.Constant.appDelegate.prefrence.ApplicationState = 1
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            
            Structures.Constant.appDelegate.isUnlockAppAlertOpen = false
            Structures.Constant.appDelegate.showLockedAppAlert(true)
        }
    }
    func uploadMedia(tempMedia : Media){
        if Utility.isConnectedToNetwork(){
            
            self.uploadingContinue = true
            Media.sendMediaObjectOnOtherThread(tempMedia, completionClosure: { (isSuccess) -> Void in
                if isSuccess{
                    CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
                    
                    CommonUnit.removeFile(tempMedia.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
                    
                    self.arrMediaFiles.removeAllObjects()
                    self.arrMediaFiles.addObjectsFromArray(CommonUnit.getDataFroKey(KEY_PENDING_MEDIA, fromFile: userName) as [AnyObject])
                    self.sendMailWithMedia(tempMedia)
                    if self.arrMediaFiles.count > 0
                    {
                        if(self.arrMediaFiles.count > 99){
                            self.pendingMediaCounts.text = NSLocalizedString(Utility.getKey("99"),comment:"")
                            self.ENpendingMediaCounts.text = NSLocalizedString(Utility.getKey("99"),comment:"")
                        }else{
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.pendingMediaCounts.text = String(self.arrMediaFiles.count)
                                self.ENpendingMediaCounts.text = String(self.arrMediaFiles.count)
                            })
                        }
                        
                        let tempMedia : Media = self.arrMediaFiles[0] as! Media
                        self.uploadMedia(tempMedia)
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.pendingMediaCounts.text = String(0)
                            self.ENpendingMediaCounts.text = String(0)
                            self.btnPendingMedia.userInteractionEnabled = false
                            self.ENbtnPendingMedia.userInteractionEnabled = false
                        })
                    }
                }
                else
                {
                    self.uploadingContinue = false
                    for media in self.arrMediaFiles
                    {
                        let tempMedia : Media = media as! Media
                        if tempMedia.uploadCount.integerValue < 3
                        {
                            tempMedia.uploadCount = NSNumber(integer: tempMedia.uploadCount.integerValue+1)
                        }
                    }
                    Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("failed_to_upload_all_media"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                }
            })
        }else{
            uploadingContinue = false
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
            })
        }
    }
    //Check Media Upload For send mail
    func sendMailWithMedia(tempMedia: Media)
    {
        var isMediaPending : Bool!
        let currentNotificationID = tempMedia.notificationID as NSNumber
        isMediaPending = false
        for (var i : Int = 0; i < self.arrMediaFiles.count ; i++)
        {
            
            let objMedia = self.arrMediaFiles[i] as!  Media
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ContactCirclePush")
        {
            Structures.Constant.appDelegate.contactScreensFrom =  ContactsFrom.Home
        }
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Structures.Constant.LocationUpdate, object: nil)
    }
    func locationUpdate(notification: NSNotification)
    {
        locationNew = notification.object as! CLLocation
        if isLocationUpdated == false
        {
            isLocationUpdated = true
            userLocationUpdatePopup()
        }
    }
    func userLocationUpdatePopup()
    {
        //Show Alert when diffrence between current location and circle update location is more than 100 mile
        if Structures.Constant.appDelegate.prefrence.UserLocationUpdate.count > 0
        {
            locationOld = CLLocation(latitude: (Structures.Constant.appDelegate.prefrence.UserLocationUpdate[Structures.Constant.Latitude] as! NSNumber).doubleValue, longitude: (Structures.Constant.appDelegate.prefrence.UserLocationUpdate[Structures.Constant.Longitude]as! NSNumber).doubleValue)
            
            let distance : CLLocationDistance = locationNew.distanceFromLocation(locationOld)
            if (distance * 0.000621371) >= 100.00
            {
                let alert: UIAlertController = UIAlertController(title: NSLocalizedString(Utility.getKey("Confirm Your Circles"),comment:""), message: nil, preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("confirm"),comment:""), style: .Cancel)
                    { action -> Void in
                        
                }
                let Ok: UIAlertAction = UIAlertAction(title:NSLocalizedString(Utility.getKey("Edit"),comment:"") , style: .Default) { action -> Void in
                    self.ContactScreen()
                }
                
                if Structures.Constant.appDelegate.isArabic == true
                {
                    alert.addAction(cancelAction)
                    alert.addAction(Ok)
                }
                else
                {
                    alert.addAction(Ok)
                    alert.addAction(cancelAction)
                }
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showUploadMediaAlert()
    {
        arrMediaFiles = NSMutableArray()
        uploadingContinue = false
        var getMediaArray = [] as NSArray!
        
        let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
        getMediaArray = CommonUnit.getDataFroKey(KEY_PENDING_MEDIA, fromFile: userName)
        
        if (getMediaArray != nil){
            for media in getMediaArray{
                let tempMedia : Media = media as! Media
                if let _ : NSData = CommonUnit.readFileDataFromDirectory("/Media/", fileName: tempMedia.name)
                {
                }else{
                    CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    CommonUnit.removeFile(tempMedia.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
                }
            }
            if(getMediaArray.count > 99){
                self.pendingMediaCounts.text = NSLocalizedString(Utility.getKey("99"),comment:"")
                self.ENpendingMediaCounts.text = NSLocalizedString(Utility.getKey("99"),comment:"")
            }else{
                self.pendingMediaCounts.text = String(getMediaArray.count)
                self.ENpendingMediaCounts.text = String(getMediaArray.count)
                btnPendingMedia.userInteractionEnabled = true
                ENbtnPendingMedia.userInteractionEnabled = true
            }
            btnPendingMedia.userInteractionEnabled = true
            ENbtnPendingMedia.userInteractionEnabled = true
            
            if (getMediaArray.count == 0)
            {
                self.pendingMediaCounts.text = String(0)
                self.ENpendingMediaCounts.text = String(0)
                btnPendingMedia.userInteractionEnabled = false
                ENbtnPendingMedia.userInteractionEnabled = false
            }
            
            arrMediaFiles.addObjectsFromArray(getMediaArray as [AnyObject])
            var isFound : Bool = false
            for media in arrMediaFiles{
                let tempMedia : Media = media as! Media
                if tempMedia.uploadCount.integerValue < 3{
                    isFound = true
                    break
                }
            }
            if isFound && !uploadingContinue && Utility.isConnectedToNetwork()
            {
                let alertController = UIAlertController(title: NSLocalizedString(Utility.getKey("reporta"),comment:""), message:NSLocalizedString(Utility.getKey("media_uploads_details"),comment:"") , preferredStyle: .Alert)
                let later = UIAlertAction(title: NSLocalizedString(Utility.getKey("upload_later"),comment:""), style: .Default) { (_) in
                    
                }
                let now = UIAlertAction(title: NSLocalizedString(Utility.getKey("upload_now"),comment:""), style: .Default) { (_) in
                    let tempMedia : Media = self.arrMediaFiles[0] as! Media
                    self.uploadMedia(tempMedia)
                }
                alertController.addAction(later)
                alertController.addAction(now)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            self.pendingMediaCounts.text = String(0)
            self.ENpendingMediaCounts.text = String(0)
            btnPendingMedia.userInteractionEnabled = false
            ENbtnPendingMedia.userInteractionEnabled = false
        }
    }
    func ContactScreen()
    {
        Structures.Constant.appDelegate.contactScreensFrom =  ContactsFrom.Home
        self.performSegueWithIdentifier("ContactPush", sender: nil);
    }
    func AlretScreen()
    {
        self.performSegueWithIdentifier("AlertPush", sender: nil);
    }
    func CheckInScreen()
    {
        self.performSegueWithIdentifier("CheckInPush", sender: nil);
    }
    func ProfileScreen()
    {
        let profileScreen : Step1_CreateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step1_CreateAccountVC") as! Step1_CreateAccountVC
        profileScreen.selectType = 2
        showViewController(profileScreen, sender : nil)
    }
    @IBAction func btnAlertClicked(sender: AnyObject)
    {
        self.AlretScreen()
    }
    @IBAction func btnContactsClicked(sender: AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            ProfileScreen()
        }
        else
        {
            ContactScreen()
        }
    }
    @IBAction func btnCheckInClicked(sender: AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            ContactScreen()
        }
        else
        {
            CheckInScreen()
        }
        
    }
    @IBAction func btnProfilesClicked(sender: AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            CheckInScreen()
        }
        else
        {
            ProfileScreen()
        }
    }
    
    @IBAction func pendingMediaFilesBtnTabbed(sender: AnyObject) {
        let mediaListScreen : MediaListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MediaListViewController") as! MediaListViewController
        presentViewController(mediaListScreen, animated: true, completion: nil)
    }
    @IBAction func btnLearnAboutReportaClicked(sender: AnyObject) {
        if  Utility.isConnectedToNetwork()
        {
            let mediaListScreen : LearnReportaViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LearnReportaViewController") as! LearnReportaViewController
            self.presentViewController(mediaListScreen, animated: true, completion: nil)
        }
    }
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType){
        if  (response is NSString){
        }
        else{
            let data : NSData? = NSData(data: response as! NSData)
            if   (data != nil){
                if let jsonResult: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if  type == WSRequestType.GetContactList{
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                        }
                    }
                }
            }
        }
    }
    func WSResponseEoor(error:NSError, ReqType type:WSRequestType){
        SVProgressHUD.dismiss()
    }
}