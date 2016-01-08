//
//  checkinNotificationViewController.swift
//  IMWF
//
// This class is used for display reminders about Check-in like Confirmation, Check-in started, Check-in closed etc.
//
//

import UIKit
import CoreLocation

enum CheckInNotificationType : Int{
    case ConfirmationReminder = 4
    case ConfirmNow = 3
    case StartReminder = 2
    case StartNow = 1
    case CloseReminder = 5
    case CloseNow = 6
}


class CheckinNotificationViewController: UIViewController, MediaDetailProtocol, WSClientDelegate ,CheckInModalProtocol{
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var verticalSpaceCloseCheckin_editCheckin: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceFullLines: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceFullLine_Button: NSLayoutConstraint!
    @IBOutlet weak var verticalSpacereporta_notif: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var lblReporta: UILabel!
    @IBOutlet weak var btnAddMedia      : UIButton!
    @IBOutlet weak var btnEditCheckIn   : UIButton!
    @IBOutlet weak var verticleSpaceBtn_TextView: NSLayoutConstraint!
    var notiType : CheckInNotificationType!
    var checkInpassword : NSString!
    var checkInID : NSNumber!
    var checkIn : CheckIn!
    var userLocation : CLLocation! = nil
    var arrMedia : NSMutableArray!
    
    //  MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        Structures.Constant.appDelegate.hideSOSButton()
        btnAddMedia.setTitle(NSLocalizedString(Utility.getKey("addmedia"),comment:""), forState: .Normal)
        btnEditCheckIn.setTitle(NSLocalizedString(Utility.getKey("edit_checkin"),comment:""), forState: .Normal)
        
        btnAddMedia.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        btnEditCheckIn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        lblReporta.text=NSLocalizedString(Utility.getKey("reporta"),comment:"")
        
        if CheckIn.isAnyCheckInActive()
        {
            checkIn = CheckIn()
            checkIn = CheckIn.getCurrentCheckInObject()
        }
        notifications()
        arrMedia = NSMutableArray()
        Structures.Constant.appDelegate.commonLocation.getUserCurrentLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate:", name:Structures.Constant.LocationUpdate, object: nil)
        Structures.Constant.appDelegate.initializeSOSButton()
    }
    override func viewWillAppear(animated: Bool)
    {
        Structures.Constant.appDelegate.showSOSButton()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        Structures.Constant.appDelegate.showSOSButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func locationUpdate(notification: NSNotification)
    {
        userLocation = notification.object as! CLLocation!
    }
    
    //  MARK:-Notification Screen Methods
    func notifications()
    {
        if self.notiType == .ConfirmationReminder{
            self.textView.text = NSLocalizedString(Utility.getKey("confirm_checkin_in_10min"),comment:"")
            self.confirmButton.setTitle(NSLocalizedString(Utility.getKey("confirm_now"),comment:""), forState: .Normal)
            self.closeButton.setTitle(NSLocalizedString(Utility.getKey("close_checkin"),comment:""), forState: .Normal)
            self.confirmButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            
            //fonts
            self.confirmButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            self.confirmButton.titleLabel?.font = Utility.setFont()
            self.closeButton.titleLabel?.font = Utility.setFont()
            self.textView.font = Utility.setFont()
            
            
        }else if self.notiType == .ConfirmNow{
            self.textView.text = NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:"")
            self.confirmButton.setTitle(NSLocalizedString(Utility.getKey("confirm_now"),comment:""), forState: .Normal)
            self.closeButton.setTitle(NSLocalizedString(Utility.getKey("close_checkin"),comment:""), forState: .Normal)
            self.confirmButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            
            self.confirmButton.titleLabel?.font = Utility.setFont()
            self.closeButton.titleLabel?.font = Utility.setFont()
            self.textView.font = Utility.setFont()
        }else if self.notiType == .StartReminder
        {
            self.textView.text = NSLocalizedString(Utility.getKey("scheduled_checkin_begins_10min"),comment:"")
            self.confirmButton.setTitle(NSLocalizedString(Utility.getKey("start_now"),comment:""), forState: .Normal)
            self.closeButton.setTitle(NSLocalizedString(Utility.getKey("cancel_checkin"),comment:""), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            
            self.confirmButton.titleLabel?.font = Utility.setFont()
            self.closeButton.titleLabel?.font = Utility.setFont()
            self.textView.font = Utility.setFont()
            
        }else if self.notiType == .StartNow{
            self.textView.text = NSLocalizedString(Utility.getKey("checkin_started"),comment:"")
            self.confirmButton.setTitle(NSLocalizedString(Utility.getKey("started"),comment:""), forState: .Normal)
            self.confirmButton.hidden = true
            self.closeButton.setTitle(NSLocalizedString(Utility.getKey("Ok"),comment:""), forState: .Normal)
            self.confirmButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            
            self.confirmButton.titleLabel?.font = Utility.setFont()
            self.closeButton.titleLabel?.font = Utility.setFont()
            self.textView.font = Utility.setFont()
            
        }
        else if self.notiType == .CloseReminder
        {
            self.textView.text = NSLocalizedString(Utility.getKey("checkin_closed_10min"),comment:"")
            self.confirmButton.setTitle(NSLocalizedString(Utility.getKey("closenow"),comment:""), forState: .Normal)
            self.closeButton.setTitle(NSLocalizedString(Utility.getKey("update_end_time"),comment:""), forState: .Normal)
            self.confirmButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            
            self.confirmButton.titleLabel?.font = Utility.setFont()
            self.closeButton.titleLabel?.font = Utility.setFont()
            self.textView.font = Utility.setFont()
            
        }
        else if self.notiType == .CloseNow
        {
            btnAddMedia.enabled = false
            btnEditCheckIn.enabled = false
            self.textView.text = NSLocalizedString(Utility.getKey("checkin_closed"),comment:"")
            self.confirmButton.setTitle("", forState: .Normal)
            self.confirmButton.hidden = true
            self.closeButton.setTitle(NSLocalizedString(Utility.getKey("Ok"),comment:""), forState: .Normal)
            self.confirmButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            self.closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.textView.textColor = UIColor.whiteColor()
            self.textView.textAlignment = NSTextAlignment.Center
            
            self.confirmButton.titleLabel?.font = Utility.setFont()
            self.closeButton.titleLabel?.font = Utility.setFont()
            self.textView.font = Utility.setFont()
            
            CheckIn.removeActiveCheckInObject()
            
            
        }
    }
    @IBAction func editAction(sender: AnyObject)
    {
        let CheckInScreen : CheckInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckInViewController") as! CheckInViewController
        showViewController(CheckInScreen, sender: self.view)
    }
    @IBAction func addAction(sender: AnyObject) {
        let mediaPickerScreen : MediaPickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MediaPickerViewController") as! MediaPickerViewController
        mediaPickerScreen.delegate = self
        mediaPickerScreen.mediaFor = .CheckIn
        showViewController(mediaPickerScreen, sender: self.view)
    }
    func dictStatusCheckIn(checkIN : CheckIn, status : NSNumber) -> NSDictionary{
        
        var latitude : NSNumber = 0
        var longitude : NSNumber = 0
        if  userLocation !=  nil
        {
            latitude = NSNumber(double: userLocation.coordinate.latitude)
            longitude = NSNumber(double: userLocation.coordinate.longitude)
        }
        let dictionary = [
            Structures.CheckIn.CheckIn_ID : checkIN.checkInID,
            Structures.Constant.Latitude : latitude,
            Structures.Constant.Longitude : longitude,
            Structures.Constant.Status : status,
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Constant.Time : Utility.getUTCFromDate()
        ]
        return dictionary
    }
    //MARK: - Media Picker Delegate Method
    func addMedia(mediaObject : Media){
        self.arrMedia.addObject(mediaObject)
    }
    func uploadMediaIfAny(){
        let totalCnt : Int  = self.arrMedia.count
        var uploadingSuccessFully : Bool = true
        for  _ in self.arrMedia{
            if !uploadingSuccessFully{
                break
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let strIndi : String = String(format: NSLocalizedString(Utility.getKey("uploading_of"),comment:""), totalCnt+1 - self.arrMedia.count, totalCnt)
                SVProgressHUD.showWithStatus(strIndi, maskType: 4)
            })
            
            
            
            let tempMedia : Media = self.arrMedia[0] as! Media
            tempMedia.notificationID = self.checkIn.checkInID
            
            Media.sendMediaObject(tempMedia, completionClosure: { (isSuccess) -> Void in
                if  isSuccess == true
                {
                    // Delete from directory
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
                    self.arrMedia.removeObjectAtIndex(0)
                }
                else{
                    // add in pending array
                    uploadingSuccessFully = false
                    self.appendPendingMedia()
                    let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("failed_to_upload_all_media"),comment:""), message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                        self.backToHomeScreen()
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                if self.arrMedia.count == 0
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SVProgressHUD.show()
                        
                        //All Media Sent Successfully
                        let dic : NSMutableDictionary = NSMutableDictionary()
                        dic [Structures.Media.ForeignID] = self.checkIn.checkInID
                        dic [Structures.Media.TableID] = NotificationType.CheckIn.rawValue
                        let wsObj : WSClient = WSClient()
                        wsObj.delegate = self
                        wsObj.sendMailWithMedia(dic)
                        
                    })
                }
            })
        }
    }
    func appendPendingMedia()
    {
        if self.checkIn.mediaArray.count > 0 {
            let arrStore : NSMutableArray = NSMutableArray()
            for (var i : Int = 0; i < self.arrMedia.count ; i++)
            {
                let tempMedia : Media = self.arrMedia[i] as! Media
                tempMedia.notificationID = self.checkIn.checkInID
                arrStore.addObject(tempMedia)
            }
            let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
            CommonUnit.appendDataWithKey(KEY_PENDING_MEDIA, inFile: userName , list: arrStore)
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Confirm Button Actions
    @IBAction func confirmButton(sender: AnyObject)
    {
        if self.notiType == .ConfirmationReminder
        {
            confirmCheckIn()
        }
        else if self.notiType == .ConfirmNow
        {
            confirmCheckIn()
        }
        else if self.notiType == .StartReminder
        {
            startCheckIn()
        }
        else if self.notiType == .CloseReminder
        {
            closeCheckIn()
        }
    }
    func confirmCheckIn()
    {
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("confirming_checkin"),comment:""), maskType: 4)
        
        CheckIn.updateCheckInStatus(NSMutableDictionary(dictionary:self.dictStatusCheckIn(checkIn, status : NSNumber(integer : 2))))
        CheckIn.sharedInstance.delegate = self
    }
    func startCheckIn(){
        
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("starting_checkin"),comment:""), maskType: 4)
        
        CheckIn.updateCheckInStatus(NSMutableDictionary(dictionary:self.dictStatusCheckIn(checkIn, status : NSNumber(integer : 1))))
        CheckIn.sharedInstance.delegate = self
    }
    func cancelCheckIn(){
        let alertController = UIAlertController(title: NSLocalizedString(Utility.getKey("Enter Password"),comment:""), message: NSLocalizedString(Utility.getKey("enter_pass_to_deactive_acheckin"),comment:""), preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("Password"),comment:"")
            textField.secureTextEntry = true
            
            if Structures.Constant.appDelegate.isArabic == true
            {
                textField.textAlignment = NSTextAlignment.Right
            }
            else
            {
                textField.textAlignment = NSTextAlignment.Left
            }
            
        }
        let okAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default) { (_) in
            let tfPassword = alertController.textFields![0]
            let password : NSString = tfPassword.text!
            
            self.checkInpassword = tfPassword.text
            
            
            if password.length>0{
                SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("canceling_checkin"),comment:""), maskType: 4)
                
                CheckIn.updateCheckInStatus(NSMutableDictionary(dictionary:self.dictCloseStatusCheckIn(self.checkIn, status : NSNumber(integer : 3))))
                CheckIn.sharedInstance.delegate = self
                
            }else{
                let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
                let message = NSLocalizedString(Utility.getKey("failed_to_cancel_checkin"),comment:"")
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backToHomeScreen()
                    })
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel) { (action) in
            
        }
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
        }
        else
        {
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        }
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func closeCheckIn()
    {
        let alertController = UIAlertController(title: NSLocalizedString(Utility.getKey("Enter Password"),comment:""), message: NSLocalizedString(Utility.getKey("enter_pass_to_deactive_acheckin"),comment:""), preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("Password"),comment:"")
            textField.secureTextEntry = true
            
            if Structures.Constant.appDelegate.isArabic == true
            {
                textField.textAlignment = NSTextAlignment.Right
            }
            else
            {
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        let okAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default) { (_) in
            let tfPassword = alertController.textFields![0]
            let password : NSString = tfPassword.text!
            
            self.checkInpassword = tfPassword.text
            
            if password.length>0 && password.length>0 {
                
                SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("closing_checkin"),comment:""), maskType: 4)
                
                CheckIn.updateCheckInStatus(NSMutableDictionary(dictionary:self.dictCloseStatusCheckIn(self.checkIn, status : NSNumber(integer : 4))))
                CheckIn.sharedInstance.delegate = self
            }else{
                let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
                let message = NSLocalizedString(Utility.getKey("failed_to_cancel_checkin"),comment:"")
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backToHomeScreen()
                    })
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel) { (action) in
            
        }
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
        }
        else
        {
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        }
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Close CheckIn
    @IBAction func closeCheckin(sender: AnyObject) {
        if self.notiType == .ConfirmationReminder
        {
            closeCheckIn()
        }
        else if self.notiType == .ConfirmNow
        {
            closeCheckIn()
        }
        else if self.notiType == .StartReminder
        {
            cancelCheckIn()
        }
        else if self.notiType == .StartNow
        {
            if self.arrMedia.count > 0{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.uploadMediaIfAny()
                })
            }
            else{
                backToHomeScreen()
            }
        }
        else if self.notiType == .CloseReminder
        {
            updateDateAndTimeOfCheckIn()
        }
        else if self.notiType == .CloseNow
        {
            
            backToHomeScreen()
        }
    }
    func dictCloseStatusCheckIn(checkIN : CheckIn, status : NSNumber) -> NSDictionary{
        let dictionary = [
            Structures.CheckIn.CheckIn_ID : checkIN.checkInID,
            Structures.Constant.Latitude : self.checkIn.latitude,
            Structures.Constant.Longitude : self.checkIn.longitude,
            Structures.Constant.Status : status,
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Constant.Time : Utility.getUTCFromDate(),
            Structures.User.User_Password : checkInpassword
        ]
        return dictionary
    }
    func updateDateAndTimeOfCheckIn(){
        let checkInViewController : CheckInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MediaPickerViewController") as! CheckInViewController
        showViewController(checkInViewController, sender: self.view)
    }
    func setUpLocalNotifications(action : NSString, body : NSString, fireDate : NSDate, userInfo : NSDictionary){
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = action as String
        localNotification.alertBody = body as String
        localNotification.fireDate = fireDate
        localNotification.userInfo = userInfo as [NSObject : AnyObject]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func backToHomeScreen()
    {
        if var _ : UINavigationController = Structures.Constant.appDelegate.window?.rootViewController as? UINavigationController
        {
            let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
            Structures.Constant.appDelegate.window?.rootViewController? = homeNavController
        }
        else if let _ = Structures.Constant.appDelegate.window?.rootViewController as? MyContainerVC
        {
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func commonCheckInResponse(wsType : WSRequestType, checkIn_ID : NSNumber ,dict : NSDictionary, isSuccess : Bool)
    {
        
        if wsType == WSRequestType.ConfirmCheckIn{
            if isSuccess
            {
                Utility.cancelNotification(Structures.CheckInStatus.Confirmation)
                Utility.cancelNotification(Structures.CheckInStatus.Reminder)
                Utility.cancelNotification(Structures.CheckInStatus.CloseReminder)
                Utility.cancelNotification(Structures.CheckInStatus.CheckInClosed)
                Utility.cancelNotification(Structures.CheckInStatus.MissedCheckIn)
                var isEndDateSet : Bool = true
                
                Structures.Constant.appDelegate.prefrence.laststatustime = NSDate()
                AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                if Structures.Constant.appDelegate.prefrence.endTime .isEqualToString("")
                {
                    isEndDateSet = false
                    let date = NSDate(timeInterval: (self.checkIn.frequency.doubleValue  * 60 * 24 ), sinceDate: NSDate())
                    self.checkIn.endTime = date
                }
                
                self.checkIn.status = .Confirmed
                let startedDate = self.checkIn.startTime
                let frequency : NSTimeInterval = (self.checkIn.frequency.doubleValue)
                let endTime : NSDate = self.checkIn.endTime
                let lastConfirmCheckinTime = NSDate()
                let currentTime = NSDate()
                
                //Remonder Before 5 min
                var startOffsetReminder : Double = 0
                if frequency >= 30
                {
                    if startedDate.compare(currentTime) == NSComparisonResult.OrderedDescending
                    {
                        startOffsetReminder = startedDate.timeIntervalSinceDate(currentTime)
                    }
                    let triggerDurationReminder : Double = startOffsetReminder  + (frequency - 10) * 60
                    let nextConfirmationReminder = NSDate(timeInterval: triggerDurationReminder, sinceDate: currentTime)
                    
                    if (isEndDateSet == false || nextConfirmationReminder.compare(endTime) == NSComparisonResult.OrderedAscending)
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Reminder ]
                            self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_remind"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: nextConfirmationReminder, userInfo: userInfo)
                        })
                        if isEndDateSet == true
                        {
                            //Close Reminder
                            let timeInterval = startedDate.timeIntervalSinceDate(endTime)
                            if  Int(timeInterval) >= (60 * 30)
                            {
                                let  startOffsetReminder = currentTime.timeIntervalSinceDate(endTime)
                                if startOffsetReminder > 10 * 60
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.CloseReminder]
                                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed_10min"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.checkIn.endTime), userInfo: userInfo)
                                    })
                                }
                            }
                        }
                    }
                }
                
                //Confirmation Before 1 min
                var startOffsetFrequency : Double = 0
                if startedDate.compare(currentTime) == NSComparisonResult.OrderedDescending
                {
                    startOffsetFrequency = startedDate.timeIntervalSinceDate(currentTime)
                }
                
                let triggerDurationFrequency : Double = startOffsetFrequency + (frequency - 2) * 60
                let nextConfirmationFrequency = NSDate(timeInterval: triggerDurationFrequency, sinceDate: currentTime)
                if (isEndDateSet == false || endTime.compare(nextConfirmationFrequency) == NSComparisonResult.OrderedDescending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Confirmation]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), fireDate: nextConfirmationFrequency, userInfo: userInfo)
                    })
                    
                }
                //Miss Check-In
                var startOffsetFreq : Double = 0
                var trigerDuration : Double = 0
                //startedDate > currentDate
                if startedDate.compare(currentTime) == NSComparisonResult.OrderedDescending
                {
                    // Future date
                    startOffsetFreq = startedDate.timeIntervalSinceDate(currentTime)
                }
                trigerDuration = startOffsetFreq + ((frequency + 1) * 60)
                //startedDate < currentDate
                if startedDate.compare(currentTime) == NSComparisonResult.OrderedAscending
                {
                    trigerDuration = trigerDuration - (currentTime.timeIntervalSinceDate(lastConfirmCheckinTime))
                }
                let newDate = NSDate(timeInterval: trigerDuration, sinceDate: currentTime)
                
                if isEndDateSet == false || newDate.compare(endTime) == NSComparisonResult.OrderedAscending
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.MissedCheckIn]
                        Structures.Constant.appDelegate.setUpLocalNotificationsReActive( String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), body: String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), fireDate: newDate, userInfo: userInfo)
                    })
                }
                
                
                
                //CheckIn endTime Close Reminder
                if (isEndDateSet == true && currentTime.compare(endTime) == NSComparisonResult.OrderedAscending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID,Structures.CheckIn.Status : Structures.CheckInStatus.CheckInClosed ]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), fireDate: self.checkIn.endTime, userInfo: userInfo)
                    })
                }
                
                CheckIn.saveCurrentCheckInObject(self.checkIn)
                NSUserDefaults.standardUserDefaults().synchronize()
                if self.arrMedia.count > 0
                {
                    self.uploadMediaIfAny()
                }
                else
                {
                    let nextConfirmation = NSDate(timeInterval: (startOffsetFrequency+(frequency) * 60), sinceDate: currentTime)
                    var title = ""
                    if nextConfirmation.compare(self.checkIn.endTime) == NSComparisonResult.OrderedAscending{
                        title = String(format: NSLocalizedString(Utility.getKey("your_next_conf"),comment:"") , (Utility.timeFromDate(nextConfirmation)))
                    }else{
                        title = String(format: NSLocalizedString(Utility.getKey("checkin_closed_at"),comment:"") , (Utility.timeFromDate(self.checkIn.endTime)))
                    }
                    let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backToHomeScreen()
                        })
                    }))
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
            else
            {
                CheckIn.removeActiveCheckInObject()
                self.backToHomeScreen()
                
            }
        }else if wsType == WSRequestType.CheckInStarted{
            
            let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
            var message = ""
            if isSuccess{
                message = NSLocalizedString(Utility.getKey("checkin_started_successfully"),comment:"")
                self.checkIn.status = .Started
                CheckIn.saveCurrentCheckInObject(self.checkIn)
            }else{
                message = NSLocalizedString(Utility.getKey("failed_to_start_checkin"),comment:"")
            }
            
            if self.arrMedia.count > 0{
                self.uploadMediaIfAny()
            }else{
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backToHomeScreen()
                    })
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }else if wsType == WSRequestType.CancelCheckIn{
            let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
            var message = ""
            if isSuccess{
                CheckIn.removeActiveCheckInObject()
                message = NSLocalizedString(Utility.getKey("checkin_canceled"),comment:"")
                if self.arrMedia.count > 0{
                    self.uploadMediaIfAny()
                }else{
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backToHomeScreen()
                        })
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                message = NSLocalizedString(Utility.getKey("failed_to_cancel_checkin"),comment:"")
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backToHomeScreen()
                    })
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }else if wsType == WSRequestType.CloseCheckIn{
            let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
            var message = ""
            if isSuccess{
                CheckIn.removeActiveCheckInObject()
                message = NSLocalizedString(Utility.getKey("checkin_closed"),comment:"")
                if self.arrMedia.count > 0{
                    self.uploadMediaIfAny()
                }else{
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backToHomeScreen()
                        })
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                message = NSLocalizedString(Utility.getKey("failed_to_cancel_checkin"),comment:"")
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.backToHomeScreen()
                    })
                }
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK:- WSDelegate
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
                if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if  type == WSRequestType.SendMailWithMedia
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                SVProgressHUD.dismiss()
                                let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("media_upload_success"),comment:""), message: "", preferredStyle: UIAlertControllerStyle.Alert)
                                //"Media files uploaded successfully"
                                alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                                    self.backToHomeScreen()
                                }))
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    }
                }
                SVProgressHUD.dismiss()
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
