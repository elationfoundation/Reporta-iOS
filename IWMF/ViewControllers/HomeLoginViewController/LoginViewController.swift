//
//  LoginViewController.swift
//  IWMF
//
// This class is used for diplay Login Screen.
//
//

import Foundation
import UIKit
import CoreLocation

class LoginViewController: UIViewController, UITextFieldDelegate,UserModalProtocol {
    @IBOutlet weak var lblIWMF: UILabel!
    @IBOutlet weak var lblPoweredby: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var btnStayLoggedIn: UIButton!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var ARbtnCreateAnAccount: UIButton!
    @IBOutlet weak var ARbtnStayLoggedIn: UIButton!
    @IBOutlet weak var btnCreateAnAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var HEbtnStayLoggedIn: UIButton!
    var username : NSString!
    var arrPassword : NSMutableArray!
    var  password : NSString!
    var activeTextField: UITextField!
    var location : CLLocation!
    var Checkin : CheckIn!
    var tapGesture : UITapGestureRecognizer!
    var forgetPasswordTextField : UITextField!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    override func viewDidLoad() {
        
        
        Structures.Constant.appDelegate.commonLocation.getUserCurrentLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate:", name:Structures.Constant.LocationUpdate, object: nil)
        self.tapGesture = UITapGestureRecognizer(target: self, action: "dissmissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        arrPassword = NSMutableArray()
        tfUserName.delegate = self;
        tfPassword.delegate = self;
        self.tfUserName.tag = 0
        self.tfPassword.tag = 1
        self.tfUserName.returnKeyType = UIReturnKeyType.Next
        self.tfPassword.returnKeyType = UIReturnKeyType.Default
        tfPassword.autocorrectionType = UITextAutocorrectionType.No
        
        
        self.tfUserName.font = Utility.setFont()
        self.tfPassword.font = Utility.setFont()
        
        
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func dissmissKeyboard(){
        self.view.endEditing(true)
    }
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.tfPassword.text = nil
        self.registerForKeyboardNotifications()
        tfUserName.placeholder = NSLocalizedString(Utility.getKey("Username"),comment:"")
        tfPassword.placeholder = NSLocalizedString(Utility.getKey("Password"),comment:"")
        btnForgotPassword.setTitle(NSLocalizedString(Utility.getKey("forget_password"),comment:""), forState: .Normal)
        btnLogin.setTitle(NSLocalizedString(Utility.getKey("login_screen"),comment:""), forState: .Normal)
        btnCreateAnAccount.setTitle(NSLocalizedString(Utility.getKey("create_account"),comment:""), forState: .Normal)
        ARbtnCreateAnAccount.setTitle(NSLocalizedString(Utility.getKey("create_account"),comment:""), forState: .Normal)
        btnStayLoggedIn.setTitle(NSLocalizedString(Utility.getKey("stay_logged_in"),comment:""), forState: .Normal)
        ARbtnStayLoggedIn.setTitle(NSLocalizedString(Utility.getKey("stay_logged_in"),comment:""), forState: .Normal)
        HEbtnStayLoggedIn.setTitle(NSLocalizedString(Utility.getKey("stay_logged_in"),comment:""), forState: .Normal)
        
        if(CommonUnit.isIphone4()){
            btnLogin.titleLabel!.font = Structures.Constant.Roboto_Regular19
        }
        if(CommonUnit.isIphone5()){
            btnLogin.titleLabel!.font = Structures.Constant.Roboto_Regular19
        }
        if(CommonUnit.isIphone6()){
            btnLogin.titleLabel!.font = Structures.Constant.Roboto_Regular20
        }
        if(CommonUnit.isIphone6plus()){
            btnLogin.titleLabel!.font = Structures.Constant.Roboto_Regular22
        }
        
        
        Structures.Constant.appDelegate.prefrence.userStayLoggedIn = false
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        if Structures.Constant.appDelegate.isArabic == true
        {
            if Structures.Constant.appDelegate.strLanguage == Structures.Constant.Arabic
            {
                ARbtnStayLoggedIn.hidden = false
                HEbtnStayLoggedIn.hidden = true
            }
            else if Structures.Constant.appDelegate.strLanguage == Structures.Constant.Hebrew
            {
                ARbtnStayLoggedIn.hidden = true
                HEbtnStayLoggedIn.hidden = false
            }
            
            ARbtnCreateAnAccount.hidden = false
            btnCreateAnAccount.hidden = true
            btnStayLoggedIn.hidden = true
        }
        else
        {
            ARbtnCreateAnAccount.hidden = true
            ARbtnStayLoggedIn.hidden = true
            btnCreateAnAccount.hidden = false
            btnStayLoggedIn.hidden = false
            HEbtnStayLoggedIn.hidden = true
        }
        
    }
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Structures.Constant.LocationUpdate, object: nil)
    }
    func locationUpdate(notification: NSNotification){
        location = notification.object as! CLLocation
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBAction func createAccountBtnPressed(sender: AnyObject) {
        
        let profileScreen : Step1_CreateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step1_CreateAccountVC") as! Step1_CreateAccountVC
        profileScreen.selectType = 1
        showViewController(profileScreen, sender: nil)
    }
    @IBAction func btnStayLoggedInClicked(sender: AnyObject)
    {
        if  Structures.Constant.appDelegate.prefrence.userStayLoggedIn == true
        {
            btnStayLoggedIn.selected = false
            ARbtnStayLoggedIn.selected = false
            HEbtnStayLoggedIn.selected = false
            Structures.Constant.appDelegate.prefrence.userStayLoggedIn = false
        }
        else
        {
            btnStayLoggedIn.selected = true
            ARbtnStayLoggedIn.selected = true
            HEbtnStayLoggedIn.selected = true
            Structures.Constant.appDelegate.prefrence.userStayLoggedIn = true
        }
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
    }
    func userLocationUpdate()
    {
        if location != nil
        {
            Structures.Constant.appDelegate.prefrence.UserLocationUpdate[Structures.Constant.Latitude] = NSNumber(double: location.coordinate.latitude)
            Structures.Constant.appDelegate.prefrence.UserLocationUpdate[Structures.Constant.Longitude] = NSNumber(double: location.coordinate.longitude)
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        }
    }
    @IBAction func btnLoginClicked(sender: AnyObject)
    {
        
        let password : NSMutableString = ""
        if arrPassword.count > 0
        {
            for(var i : Int  = 0; i < arrPassword.count; i++)
            {
                password.appendString(arrPassword.objectAtIndex(i) as! String)
                
            }
        }
        username = self.tfUserName.text!
        if username.length == 0 || password.length == 0
        {
            let alertController = UIAlertController(title:NSLocalizedString(Utility.getKey("enter_valid_username_or_pass"),comment:"") , message: "", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title:  NSLocalizedString(Utility.getKey("Ok"),comment:""), style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.userLoginWS(username, password: password, forcelogin: "0")
        }
    }
    func userLoginWS(username : NSString , password : NSString, forcelogin : NSString ){
        
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("Logging In"),comment:""), maskType: 4)
        User.loginUser(NSMutableDictionary(dictionary:  User.dictToLogin(Structures.Constant.appDelegate.prefrence.DeviceToken,username: username, password: password,forcelogin : forcelogin)))
        User.sharedInstance.delegate = self
    }
    
    func commonUserResponse(wsType : WSRequestType ,dict : NSDictionary, isSuccess : Bool)
    {
        
        if wsType == WSRequestType.Login{
            SVProgressHUD.dismiss()
            if isSuccess{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        //User Location
                        self.userLocationUpdate()
                        //User Object
                        var userDetail = User()
                        userDetail = userDetail.getLoggedInUser()!
                        Structures.Constant.appDelegate.isArabic = false
                        Structures.Constant.appDelegate.prefrence.SelectedLanguage = userDetail.selectedLanguage
                        Structures.Constant.appDelegate.prefrence.LanguageCode = userDetail.languageCode
                        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                        
                        if Structures.Constant.appDelegate.prefrence.LanguageCode == Structures.Constant.Spanish
                        {
                            Structures.Constant.appDelegate.strLanguage = Structures.Constant.Spanish
                        }
                        else if Structures.Constant.appDelegate.prefrence.LanguageCode == Structures.Constant.Arabic
                        {
                            Structures.Constant.appDelegate.isArabic = true
                            Structures.Constant.appDelegate.strLanguage = Structures.Constant.Arabic
                        }
                        else if Structures.Constant.appDelegate.prefrence.LanguageCode == Structures.Constant.Turkish
                        {
                            Structures.Constant.appDelegate.strLanguage = Structures.Constant.Turkish
                        }
                        else if Structures.Constant.appDelegate.prefrence.LanguageCode == Structures.Constant.French
                        {
                            Structures.Constant.appDelegate.strLanguage = Structures.Constant.French
                        }
                        else if Structures.Constant.appDelegate.prefrence.LanguageCode == Structures.Constant.Hebrew
                        {
                            Structures.Constant.appDelegate.isArabic = true
                            Structures.Constant.appDelegate.strLanguage = Structures.Constant.Hebrew
                        }
                        else
                        {
                            Structures.Constant.appDelegate.strLanguage = Structures.Constant.English
                        }
                        
                        Structures.Constant.languageBundle = CommonUnit.setLanguage(Structures.Constant.appDelegate.strLanguage as String)
                        
                        let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                        Structures.Constant.appDelegate.window?.rootViewController? = homeNavController
                        
                        if CheckIn.isAnyCheckInActive()
                        {
                            self.Checkin = CheckIn.getCurrentCheckInObject()
                            self.reActiveCheckIn()
                        }
                    })
                })
            }else{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if dict.count > 0{
                        if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                            if dict.valueForKey(Structures.Constant.Message) != nil
                            {
                                let alertController = UIAlertController(title: dict.valueForKey(Structures.Constant.Message) as? String , message: "", preferredStyle: .Alert)
                                alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Default, handler: { action in
                                }))
                                alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                                    self.userLoginWS(self.username, password: self.password, forcelogin: "1")
                                }))
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }else{
                            if dict.valueForKey(Structures.Constant.Message) != nil
                            {
                                let alertController = UIAlertController(title: dict.valueForKey(Structures.Constant.Message) as? String , message: "", preferredStyle: .Alert)
                                alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                })
            }
        }else if wsType == WSRequestType.ForgetPassword{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if dict.valueForKey(Structures.Constant.Message) != nil
                {
                    
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("reporta"),comment:""), message: dict.valueForKey(Structures.Constant.Message) as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                        
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            });
        }
        
        
        
    }
    //ReActive Check In
    func reActiveCheckIn()
    {
        var endDate : NSDate!
        var isEndDateSet : Bool = true
        var lastConfirmCheckinTime : NSDate =  Structures.Constant.appDelegate.prefrence.laststatustime
        let currentDate : NSDate = NSDate()
        if  Structures.Constant.appDelegate.prefrence.endTime .isEqualToString("")
        {
            isEndDateSet = false
            endDate = NSDate(timeInterval: (Checkin.frequency.doubleValue  * 60 * 24), sinceDate: lastConfirmCheckinTime )
            Checkin.endTime = endDate
        }
        else
        {
            endDate = Checkin.endTime
        }
        
        if (Checkin.endTime == 0 ||  Checkin.endTime.compare(currentDate) == NSComparisonResult.OrderedDescending)
        {
            
            let startedDate = Checkin.startTime
            let frequency  =  Checkin.frequency.doubleValue
            var diff : Double = 0
            var startOffsetReminder : Double = 0
            
            let frequencyInMilli : Double = frequency * 60
            if startedDate.compare(lastConfirmCheckinTime) == NSComparisonResult.OrderedDescending
            {
                lastConfirmCheckinTime = startedDate
            }
            let nextConfirmationDate : NSDate = NSDate(timeInterval: frequencyInMilli , sinceDate: lastConfirmCheckinTime)
            if frequency >= 30 && (isEndDateSet == false || endDate.compare(nextConfirmationDate) == NSComparisonResult.OrderedDescending)
            {
                var trigerDuration : Double = 0
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    // Future date
                    startOffsetReminder = startedDate.timeIntervalSinceDate(currentDate)
                    trigerDuration = 0
                    trigerDuration = startOffsetReminder + ((frequency - 10) * 60)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Reminder]
                        let date = NSDate(timeInterval: trigerDuration, sinceDate: currentDate)
                        Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("confirm_checkin_remind"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: date, userInfo: userInfo)
                    })
                }
                else
                {
                    diff = currentDate.timeIntervalSinceDate(lastConfirmCheckinTime)
                    if (diff < frequencyInMilli)
                    {
                        // Checkin still not missed
                        trigerDuration = 0
                        if (frequencyInMilli - diff > 10 * 60)
                        {
                            // Difference is more than 5 minutes
                            trigerDuration = ((frequency - 10) * 60 - diff)
                        }
                        let date = NSDate(timeInterval: trigerDuration, sinceDate: currentDate)
                        if isEndDateSet == false || endDate.compare(date) == NSComparisonResult.OrderedDescending
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Reminder]
                                Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("confirm_checkin_remind"),comment:""),body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: date, userInfo: userInfo)})
                        }
                    }
                    else
                    {
                        // Miss checkin
                        Structures.Constant.appDelegate.showMissedCheckInScreen()
                    }
                }
                
                if isEndDateSet == true
                {
                    //Close Reminder
                    let timeInterval = startedDate.timeIntervalSinceDate(endDate)
                    if  Int(timeInterval) >= (60 * 30)
                    {
                        let  startOffsetReminder = currentDate.timeIntervalSinceDate(endDate)
                        if startOffsetReminder > 10 * 60
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.CloseReminder]
                                Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("checkin_closed_10min"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: endDate), userInfo: userInfo)
                            })
                        }
                    }
                }
            }
            
            //Checkin Freqency
            var startOffsetFreq : Double = 0
            var trigerDuration : Double = 0
            if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
            {
                // Future date
                startOffsetFreq = startedDate.timeIntervalSinceDate(currentDate)
                trigerDuration = startOffsetFreq + ((frequency - 2 ) * 60)
            }
            else
            {
                /**
                 * TimeStamp till last confirm
                 */
                var diffrence : Double = 0
                diffrence = currentDate.timeIntervalSinceDate(lastConfirmCheckinTime)
                if (diffrence < frequencyInMilli)
                {
                    // CheckIn still not missed
                    if (frequencyInMilli - diffrence > 2 * 60 )
                    {
                        // Difference is more than 10 minutes
                        trigerDuration = ((frequency - 2) * 60 - diffrence)
                        //println("trigerDuration==\(trigerDuration)")
                    }
                }
                else
                {
                    // Miss checkin
                    Structures.Constant.appDelegate.showMissedCheckInScreen()
                }
            }
            
            if trigerDuration > 0
            {
                let newDate = NSDate(timeInterval: trigerDuration, sinceDate: currentDate)
                if isEndDateSet == false || endDate.compare(newDate) == NSComparisonResult.OrderedDescending
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Confirmation]
                        Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), fireDate: newDate, userInfo: userInfo)
                    })
                }
            }
            
            //Miss Check-In
            startOffsetFreq = 0
            //startedDate > currentDate
            if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
            {
                // Future date
                startOffsetFreq = startedDate.timeIntervalSinceDate(currentDate)
            }
            trigerDuration = startOffsetFreq + ((frequency + 1) * 60)
            //startedDate < currentDate
            if startedDate.compare(currentDate) == NSComparisonResult.OrderedAscending
            {
                trigerDuration = trigerDuration - (currentDate.timeIntervalSinceDate(lastConfirmCheckinTime))
            }
            let newDate = NSDate(timeInterval: trigerDuration, sinceDate: currentDate)
            
            if isEndDateSet == false || newDate.compare(endDate) == NSComparisonResult.OrderedAscending
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.MissedCheckIn]
                    Structures.Constant.appDelegate.setUpLocalNotificationsReActive( String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), body: String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), fireDate: newDate, userInfo: userInfo)
                })
            }
            
            //CheckIn endTime Close Reminder
            if (isEndDateSet == true && currentDate.compare(endDate) == NSComparisonResult.OrderedAscending)
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID,Structures.CheckIn.Status : Structures.CheckInStatus.CheckInClosed ]
                    Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), fireDate: endDate, userInfo: userInfo)
                })
            }
            
            //Pending
            if self.Checkin.status.rawValue == 0
            {
                startOffsetFreq = startedDate.timeIntervalSinceDate(currentDate)
                if startOffsetFreq  >= (30 * 60)
                {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID,
                            Structures.CheckIn.Status : Structures.CheckInStatus.StartReminder,
                        ]
                        Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("checkin_will_start_in_10"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_will_start_in_10"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.Checkin.startTime), userInfo: userInfo)
                    })
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let userInfo : NSDictionary = ["CheckInID" : self.Checkin.checkInID,
                        Structures.CheckIn.Status : Structures.CheckInStatus.Start,
                    ]
                    Structures.Constant.appDelegate.setUpLocalNotificationsReActive(NSLocalizedString(Utility.getKey("checkin_will_start_now"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_will_start_now"),comment:""), fireDate: self.Checkin.startTime, userInfo: userInfo)
                })
            }
        }
    }
    
    
    @IBAction func btnForgotPasswordClicked(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: NSLocalizedString(Utility.getKey("forget_password"),comment:""), message:  NSLocalizedString(Utility.getKey("Enter_email_reset"),comment:""), preferredStyle: .Alert)
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: UIAlertActionStyle.Default, handler: {
                action in
                
                let forgotPassword = alertController.textFields![0]
                
                if  !Utility.isValidEmail(forgotPassword.text!)
                {
                    let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("please_enter_valid_email"),comment:""), message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    forgotPassword.text = nil
                    self.view.endEditing(true);
                }
                else
                {
                    self.sendUsername()
                }
            }))
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: UIAlertActionStyle.Default, handler: nil))
            
        }
        else
        {
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: UIAlertActionStyle.Default, handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: UIAlertActionStyle.Default, handler: {
                action in
                let forgotPassword = alertController.textFields![0]
                
                if  !Utility.isValidEmail(forgotPassword.text!)
                {
                    let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("please_enter_valid_email"),comment:""), message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    forgotPassword.text = nil
                    self.view.endEditing(true);
                }
                else
                {
                    self.sendUsername()
                }
            }))
        }
        
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("EnterEmail"),comment:"")
            self.forgetPasswordTextField = textField
            self.forgetPasswordTextField.keyboardType = UIKeyboardType.EmailAddress
            
            if Structures.Constant.appDelegate.isArabic == true
            {
                textField.textAlignment = NSTextAlignment.Right
            }
            else
            {
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    // MARK: UITextField Delegate Methods
    func sendUsername(){
        let email : NSString = self.forgetPasswordTextField.text!
        SVProgressHUD.showWithStatus((NSLocalizedString(Utility.getKey("sending_email"),comment:"")) as String
            , maskType: 4)
        User.forgetPassword(NSMutableDictionary(dictionary:User.dictForPassword(email)))
        User.sharedInstance.delegate = self
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        activeTextField = textField
        if textField.tag == 1
        {
            arrPassword = NSMutableArray()
            textField.text = nil
        }
        mainScrollView.scrollEnabled = true
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        
        if textField.tag == 0
        {
            tfUserName.text = Utility.trimWhitespace(textField.text!)
        }
        else if textField.tag == 1
        {
            if  textField.text!.characters.count == range.location
            {
                arrPassword.addObject(string)
            }
            else
            {
                arrPassword.removeLastObject()
            }
            textField.text = hideTextInTextFieldExceptOne(textField.text) as String
        }
        return true
    }
    func hideTextInTextFieldExceptOne(text: NSString!) -> NSString
    {
        var len : Int = 0
        len = text.length
        var test : NSString = ""
        for (var i : Int = 0; i < len ; i++ )
        {
            let range : NSRange = NSMakeRange(i, 1)
            test = text.stringByReplacingCharactersInRange(range, withString: "●")
        }
        return test
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeTextField = textField
        if textField.tag == 0
        {
            tfUserName.text = Utility.trimWhitespace(textField.text!)
            activeTextField = tfPassword
        }
        else
        {
            mainScrollView.scrollEnabled = false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.returnKeyType == UIReturnKeyType.Next
        {
            activeTextField = tfPassword
            tfPassword.becomeFirstResponder()
        }
        else if textField.returnKeyType == UIReturnKeyType.Default
        {
            textField.resignFirstResponder()
        }
        
        return true;
    }
    func keyboardWillBeShown(sender: NSNotification) {
        if  activeTextField == nil{
            return;
        }
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!))
        {
            mainScrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification)
    {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        mainScrollView.contentInset = contentInsets
        mainScrollView.scrollIndicatorInsets = contentInsets
    }
}