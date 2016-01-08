
//
//  AppDelegate.swift
//  IWMF
//
//  Appdelgate used for initialize SOS, Hangle Lock Screen, Set RootView, check device is Rooted or not, Fetch country list, check check-in status when app decome active.
//
//

import UIKit

enum ContactsFrom : Int
{
    case Home = 1
    case CheckIn = 2
    case Alert = 3
    case CreateAccount = 4
}


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UITextFieldDelegate,SOSModalProtocol
{
    var window: UIWindow?
    var SOSButton : UIButton! //SOS
    var SOSBGVIew : UIView! // SOS BAckground
    var strLanguage : NSString! // Language Code For App
    var tableBackground : UIColor! //Background Graycolor in app
    //Flag for Update contact list
    var isContactUpdated: Bool!
    //Flag for display UI right to left
    var isArabic: Bool!
    //Flag for AppLock alert is open or not
    var isUnlockAppAlertOpen : Bool!
    //Dict for display false status of all ws.
    var dictCommonResult : NSDictionary!
    var dictSelectToUpdate : NSDictionary!
    var dictSignUpCircle : NSMutableDictionary!
    var arrCountryList : NSMutableArray!
    var alertAppLock : UIAlertController!
    var commonLocation : CommonLocation!
    var contactScreensFrom : ContactsFrom!
    var userSignUpDetail = User() // Use for Store Signup Detail and for Store User Profile
    let isDeviceJailbroken : Bool = CommonUnit.isDeviceJailbroken()
    var prefrence = AppPrefrences()
    var headerCell : MapTableviewCell!
    var isFromSOS : Bool!
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        

        userSignUpDetail = User.sharedInstance
        //Load App prefrences
        if let pref = prefrence.getAppPrefrences()
        {
            prefrence = pref
        }
        //Check here device is Rooted or not? if true than we dont allow to use app
        if isDeviceJailbroken == false {
            
            //Store NYC location. If cant get current location than we use this. if get current location than update it from "CommonLocation.swift"
            if prefrence.UsersLastKnownLocation.count == 0{
                prefrence.UsersLastKnownLocation[Structures.Constant.Latitude] = NSNumber(double: Structures.AppKeys.DefaultLatitude)
                prefrence.UsersLastKnownLocation[Structures.Constant.Longitude] = NSNumber(double: Structures.AppKeys.DefaultLongitude)
                AppPrefrences.saveAppPrefrences(prefrence)
                
            }
            
            commonLocation = CommonLocation()
            commonLocation.intializeLocationManager()
            
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
            isContactUpdated = false
            isArabic = false
            isUnlockAppAlertOpen = false
            dictSelectToUpdate = NSMutableDictionary()
            dictCommonResult = NSDictionary()
            dictSignUpCircle = NSMutableDictionary()
            arrCountryList = NSMutableArray()
            tableBackground = Utility.UIColorFromHex(0xEBEBEB, alpha: 1)
            SVProgressHUD().hudBackgroundColor = UIColor.blackColor()
            
            self.initializeSOSButton()
            self.hideSOSButton()
            
            //SetRootView
            strLanguage = Structures.Constant.English
            
            if prefrence.LanguageCode  != nil
            {
                if prefrence.LanguageCode == Structures.Constant.Spanish
                {
                    strLanguage = Structures.Constant.Spanish
                }
                else if prefrence.LanguageCode == Structures.Constant.Arabic
                {
                    isArabic = true
                    strLanguage = Structures.Constant.Arabic
                }
                else if prefrence.LanguageCode == Structures.Constant.Turkish
                {
                    strLanguage = Structures.Constant.Turkish
                }
                else if prefrence.LanguageCode == Structures.Constant.French
                {
                    strLanguage = Structures.Constant.French
                }
                else if prefrence.LanguageCode == Structures.Constant.Hebrew
                {
                    isArabic = true
                    strLanguage = Structures.Constant.Hebrew
                }
                else
                {
                    strLanguage = Structures.Constant.English
                }
            }
            else
            {
                strLanguage = Structures.Constant.English
            }
            
            Structures.Constant.languageBundle = CommonUnit.setLanguage(strLanguage as String)
            
            setRootViewController()
            

            //Common map declaration for reduce memory usage in app.
            let arr : NSArray = NSBundle.mainBundle().loadNibNamed("MapTableviewCell", owner: self, options: nil)
            headerCell = arr[0] as?  MapTableviewCell
            
            
            //Notification
            if application.respondsToSelector("isRegisteredForRemoteNotifications")
            {
                // iOS 8 Notifications
                let types: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
                let settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
                application.registerUserNotificationSettings( settings )
                application.registerForRemoteNotifications()
            }
            /* else
            {
            // iOS < 8 Notifications
            application.registerForRemoteNotificationTypes([.Badge, .Sound, .Alert])
            }*/
            
            if let options = launchOptions
            {
                let lauchOpt = options as! Dictionary<String, AnyObject>
                if let noti = lauchOpt["UIApplicationLaunchOptionsLocalNotificationKey"] as? UILocalNotification{
                    showCheckInNotificationScreen(noti.userInfo!)
                }
                if let noti = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
                    self.application(application, didReceiveRemoteNotification: noti as [NSObject : AnyObject])
                }
                
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.deviceRootedAlert()
            })
        }
        return true
    }
    //Device is rooted than display this alert
    func deviceRootedAlert(){
        let alertController = UIAlertController(title: "Jailbreak Detected" , message: "Reporta cannot run on a jailbroken device", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.deviceRootedAlert()
        }))
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    //Set Root view if User selected language at first time
    func setRootViewController(){
        
        let isLoggedIn = prefrence.UserAlredyLoggedIn
        let userStayLoggedIn = prefrence.userStayLoggedIn
        if CheckIn.isAnyCheckInActive(){
            if isLoggedIn.boolValue == true
            {
                if var _ : UINavigationController = self.window?.rootViewController as? UINavigationController
                {
                    let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                    self.window?.rootViewController? = homeNavController
                }
            }
            else
            {
                setLoginScreen()
            }
        }
        else{
            if (userStayLoggedIn != nil && userStayLoggedIn == true)
            {
                if (isLoggedIn != nil)
                {
                    if isLoggedIn.boolValue == true
                    {
                        if var _ : UINavigationController = self.window?.rootViewController as? UINavigationController
                        {
                            let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                            self.window?.rootViewController? = homeNavController
                        }
                    }
                    else
                    {
                        setLoginScreen()
                    }
                }
                else
                {
                    setLoginScreen()
                }
            }
            else
            {
                setLoginScreen()
            }
        }
    }
    //Set Login Screen
    func setLoginScreen(){
        
        if prefrence.LanguageCode != nil
        {
            if prefrence.LanguageSelected == true
            {
                prefrence.UserAlredyLoggedIn = false
                AppPrefrences.saveAppPrefrences(prefrence)
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
            }
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        if isDeviceJailbroken == false {
            let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
            var tokenString = ""
            
            for var i = 0; i < deviceToken.length; i++ {
                tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            }
            prefrence.DeviceToken = tokenString
            AppPrefrences.saveAppPrefrences(prefrence)
        }
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        prefrence.DeviceToken = ""
        AppPrefrences.saveAppPrefrences(prefrence)
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if isDeviceJailbroken == false {
            
            let isLoggedIn = prefrence.UserAlredyLoggedIn
            if  userInfo[Structures.Constant.Status] as! NSString == "unlockapp"
            {
                if (isLoggedIn != nil && isLoggedIn.boolValue == true){
                    
                    Utility.removeAllPendingMedia()
                    
                    var userDetail = User()
                    userDetail = userDetail.getLoggedInUser()!
                    userDetail.lockstatus = 0
                    User.saveUserObject(userDetail)
                    
                    prefrence.ApplicationState = 0
                    AppPrefrences.saveAppPrefrences(prefrence)
                    
                    self.isUnlockAppAlertOpen = false
                    self.SOSButton.userInteractionEnabled = true
                    if CheckIn.isAnyCheckInActive()
                    {
                        CheckIn.removeActiveCheckInObject()
                    }
                    if alertAppLock != nil {
                        alertAppLock.dismissViewControllerAnimated(true, completion: nil)
                    }
                    let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                    self.window?.rootViewController? = homeNavController
                }
            }
            else if  userInfo[Structures.Constant.Status] as! NSString == "lockapp"
            {
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                if (isLoggedIn != nil && isLoggedIn.boolValue == true){
                    Utility.removeAllPendingMedia()
                    if isUnlockAppAlertOpen == false{
                        prefrence.ApplicationState = 1
                        AppPrefrences.saveAppPrefrences(prefrence)
                        var userDetail = User()
                        userDetail = userDetail.getLoggedInUser()!
                        userDetail.lockstatus = 1
                        User.saveUserObject(userDetail)
                        isFromSOS = false
                        showLockedAppAlert(isFromSOS)
                    }
                }
            }
            
        }
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
    }
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
    {
        if isDeviceJailbroken == false {
            showCheckInNotificationScreen(notification.userInfo!)
        }
    }
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if isDeviceJailbroken == false {
            showCheckInNotificationScreen(notification.userInfo!)
        }
        completionHandler()
    }
    func setUpLocalNotificationsReActive(action : NSString, body : NSString, fireDate : NSDate, userInfo : NSDictionary){
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = action as String
        localNotification.alertBody = body as String
        localNotification.fireDate = fireDate
        localNotification.userInfo = userInfo as [NSObject : AnyObject]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    func setUpLocalNotifications(action : NSString, body : NSString, fireDate : NSDate){
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = action as String
        localNotification.alertBody = body as String
        localNotification.fireDate = fireDate
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    //MARK:- CountryList Update
    func countryListUpdate()
    {
        self.arrCountryList = NSMutableArray()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.arrCountryList = CommonUnit.GetCountryList(self.prefrence.LanguageCode as NSString as String).mutableCopy() as! NSMutableArray
            let arrTemp : NSMutableArray = NSMutableArray(array: self.arrCountryList)
            for (index, element) in arrTemp.enumerate()
            {
                if var innerDict = element.mutableCopy() as? Dictionary<String, AnyObject>
                {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        innerDict["RowHeight"] = CGFloat(46)
                        innerDict["CellIdentifier"] = "DetailTableViewCellIdentifier"
                        innerDict["IsSelected"] = Bool(0)
                        innerDict["Level"] = "Middle"
                        innerDict["Method"] = ""
                        innerDict["Type"] = Int(1)
                        innerDict["ConnectedID"] = Int(1)
                        self.arrCountryList.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        })
    }
    //MARK:- SOS Button Methods
    func initializeSOSButton()
    {
        
        let SOSButtonImage =  UIImage(named: "sos")
        SOSButton = UIButton(type: UIButtonType.Custom)
        SOSButton.setBackgroundImage(SOSButtonImage, forState: UIControlState.Normal)
        let longPress = UILongPressGestureRecognizer(target: self, action: "SOSbtnTouched:")
        SOSButton.addGestureRecognizer(longPress)
        SOSButton.translatesAutoresizingMaskIntoConstraints = false
        self.window?.addSubview(SOSButton)
        self.window?.bringSubviewToFront(SOSButton)
        
        if isUnlockAppAlertOpen == true{
            self.SOSButton.userInteractionEnabled = false
        }else{
            self.SOSButton.userInteractionEnabled = true
        }
        
        let verticalSpaceFromBotton = NSLayoutConstraint(item: SOSButton, attribute: NSLayoutAttribute.BottomMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.window, attribute: .BottomMargin, multiplier: 1, constant: -5)
        self.window?.addConstraint(verticalSpaceFromBotton)
        
        let trailingSpace = NSLayoutConstraint(item: SOSButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.window, attribute: .Trailing, multiplier: 1, constant: -5)
        self.window?.addConstraint(trailingSpace)
        
        let width = NSLayoutConstraint(item: SOSButton, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.size.width - 10)
        self.window?.addConstraint(width)
        
        let height = NSLayoutConstraint(item: SOSButton, attribute: .Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 44)
        self.window?.addConstraint(height)
    }
    func hideSOSButton()
    {
        SOSButton.hidden = true
    }
    func showSOSButton()
    {
        SOSButton.hidden = false
    }
    func SOSbtnTouched(gesture : UILongPressGestureRecognizer)
    {
        if isUnlockAppAlertOpen == true
        {
            return
        }
        
        if gesture.state == UIGestureRecognizerState.Ended
        {
            isUnlockAppAlertOpen = false
            startLockingTheApp()
        }
    }
    func startLockingTheApp()
    {
        
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("locking_reporta"),comment:"") , maskType: 4)
        
        if  !Utility.isConnectedToNetwork(){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
                Utility.removeAllPendingMedia()
                self.isFromSOS = true
                self.showLockedAppAlert(self.isFromSOS)
                CheckIn.removeActiveCheckInObject()
                self.prefrence.ApplicationState = 1
                AppPrefrences.saveAppPrefrences(self.prefrence)
                return
            })
        }
        
        
        let objSOS = SOS()

        objSOS.sos()
        SOS.sharedInstance.delegate = self
    }
    
    func showLockedAppAlert(isFromSOS : Bool)
    {
        let isLoggedIn =  prefrence.UserAlredyLoggedIn
        if (isLoggedIn != nil && isLoggedIn.boolValue == true){
            
            if isUnlockAppAlertOpen == false{
                isUnlockAppAlertOpen = true
                self.SOSButton.userInteractionEnabled = false
                alertAppLock = UIAlertController(title: NSLocalizedString(Utility.getKey("reporta"),comment:""), message:NSLocalizedString(Utility.getKey("app_locked"),comment:"") , preferredStyle: .Alert)
                let okAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("login"),comment:""), style: .Default) { (_) in
                    self.showUnlockAppAlert(isFromSOS)
                }
                alertAppLock.addAction(okAction)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.window?.rootViewController?.presentViewController(self.alertAppLock, animated: true, completion: nil)
                })
            }
        }
    }
    func showUnlockAppAlert(isFromSOS : Bool){
        
        let objSOS = SOS.getCurrentSOSObject()
        alertAppLock = UIAlertController(title: NSLocalizedString(Utility.getKey("unlock_reporta"),comment:"") , message: NSLocalizedString(Utility.getKey("app_unlocked"),comment:""), preferredStyle: .Alert)
        alertAppLock.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("Enter Password"),comment:"")
            textField.secureTextEntry = true
            if self.isArabic == true{
                textField.textAlignment = NSTextAlignment.Right
            }else{
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        alertAppLock.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder =  NSLocalizedString(Utility.getKey("enter_passcode"),comment:"")
            textField.secureTextEntry = true
            textField.keyboardType = UIKeyboardType.PhonePad
            textField.delegate = self
            if self.isArabic == true{
                textField.textAlignment = NSTextAlignment.Right
            }else{
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        
        let okAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default) { (_) in
            let tfPassword = self.alertAppLock.textFields![0]
            let tfPasscode = self.alertAppLock.textFields![1]
            if (tfPassword.text != nil && tfPasscode.text != nil) {
                let password : String = tfPassword.text!
                let passCode : String = tfPasscode.text!
                if password.characters.count>0 && passCode.characters.count>0{
                    if  !Utility.isConnectedToNetwork(){
                        self.isUnlockAppAlertOpen = false
                        self.showLockedAppAlert(isFromSOS)
                        return
                    }
                    self.isFromSOS = isFromSOS
                    SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("unlocking_reporta"),comment:""), maskType: 4)
                    objSOS.unlockSOS(password, passcode: passCode)
                    SOS.sharedInstance.delegate = self
                }else{
                    self.showUnlockAppAlert(isFromSOS)
                }
            }
            else{
                self.showUnlockAppAlert(isFromSOS)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Default) { (_) in
            self.isUnlockAppAlertOpen = false
            self.showLockedAppAlert(isFromSOS)
        }
        alertAppLock.addAction(cancelAction)
        alertAppLock.addAction(okAction)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.window?.rootViewController?.presentViewController(self.alertAppLock, animated: true, completion: nil)
        })
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as! an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(application: UIApplication) {
        //CheckIn.removeActiveCheckInObject()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as! part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(application: UIApplication)
    {
        if isDeviceJailbroken == false {
            let isLoggedIn = prefrence.UserAlredyLoggedIn
            if (isLoggedIn != nil && isLoggedIn.boolValue == true)
            {
                application.applicationIconBadgeNumber = 0
                if let activeState = prefrence.ApplicationState {
                    if  activeState.integerValue == 1
                    {
                        if self.isUnlockAppAlertOpen == false
                        {
                            self.showLockedAppAlert(false)
                        }
                    }
                }
                self.changeCheckInStatus()
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.deviceRootedAlert()
            })
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(application: UIApplication)
    {
        removeLoginUser()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        let strTemp : NSString = textField.text!
        let strReplacing : NSString!
        strReplacing = strTemp.stringByReplacingCharactersInRange(range, withString: string)
        return strReplacing.length <= 6
    }
    //MARK:- Remove User Prefrence if Stay Login False
    func removeLoginUser()
    {
        if !CheckIn.isAnyCheckInActive(){
            let userStayLoggedIn = prefrence.userStayLoggedIn
            if (userStayLoggedIn != nil && userStayLoggedIn == false){
                prefrence.UserAlredyLoggedIn = false
                SOS.removeActiveSOSObject()
                SOS.setActiveSosID(NSNumber(integer: 0))
                CheckIn.removeActiveCheckInObject()
                User.removeActiveUser()
                prefrence.ApplicationState = 0
                AppPrefrences.saveAppPrefrences(prefrence)
            }
        }
    }
    
    //MARK:- changeCheckInStatus
    func changeCheckInStatus()
    {
        let isLoggedIn = prefrence.UserAlredyLoggedIn
        if CheckIn.isAnyCheckInActive()
        {
            let checkIn : CheckIn = CheckIn.getCurrentCheckInObject()
            
            if (isLoggedIn != nil && isLoggedIn.boolValue == true)
            {
                if checkIn.status.rawValue == 5
                {
                    Utility.removeAllPendingMedia()
                    UIApplication.sharedApplication().cancelAllLocalNotifications()
                    prefrence.ApplicationState = 1
                    AppPrefrences.saveAppPrefrences(prefrence)
                    if self.isUnlockAppAlertOpen == false
                    {
                        showMissedCheckInScreen()
                    }
                    return
                }
                let currentDate = NSDate()
                let missedTim = NSDate(timeInterval: (checkIn.frequency.doubleValue + 1) * 60 , sinceDate: prefrence.laststatustime)                 //currentDate > missedTim
                if currentDate.compare(missedTim) == NSComparisonResult.OrderedDescending
                {
                    checkIn.status = .Missed
                    CheckIn.saveCurrentCheckInObject(checkIn)
                    Utility.removeAllPendingMedia()
                    UIApplication.sharedApplication().cancelAllLocalNotifications()
                    prefrence.ApplicationState = 1
                    AppPrefrences.saveAppPrefrences(prefrence)
                    if self.isUnlockAppAlertOpen == false
                    {
                        showMissedCheckInScreen()
                    }
                    return
                }
                //currentDate < checkIn.startTime
                if currentDate.compare(checkIn.startTime) == NSComparisonResult.OrderedAscending
                {
                    checkIn.status = .Pending
                    CheckIn.saveCurrentCheckInObject(checkIn)
                }
                else
                {
                    if checkIn.status.rawValue > 1
                    {
                        if currentDate.compare(checkIn.endTime) == NSComparisonResult.OrderedDescending
                        {
                            Utility.removeAllPendingMedia()
                            checkIn.status = .Closed
                            CheckIn.removeActiveCheckInObject()
                        }
                    }
                    else
                    {
                        checkIn.status = .Started
                        CheckIn.saveCurrentCheckInObject(checkIn)
                    }
                }
            }
        }
    }
    //MARK:- MissCheckinView
    func showCheckInNotificationScreen(dictUserInfo : NSDictionary)
    {
        self.changeCheckInStatus()
        let checkIn : CheckIn = CheckIn.getCurrentCheckInObject()
        if checkIn.status.rawValue != 5
        {
            NSNotificationCenter.defaultCenter().postNotificationName("showCheckInNotification", object: dictUserInfo)
        }
    }
    func showMissedCheckInScreen()
    {
        if isUnlockAppAlertOpen == false{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                self.window?.rootViewController? = homeNavController
                self.showLockedAppAlert(false)
            })
        }
    }
    
    //MARK: - Core Data Helper
    
    lazy var cdstore: CoreDataStore = {
        let cdstore = CoreDataStore()
        return cdstore
    }()
    
    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
    }()
    
    
    func commonSOSResponse(wsType : WSRequestType, dict : NSDictionary, isSuccess : Bool)
    {
        if wsType == WSRequestType.LockSOS{
            if  isSuccess
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    Utility.removeAllPendingMedia()
                })
                self.showLockedAppAlert(true)
                CheckIn.removeActiveCheckInObject()
                self.prefrence.ApplicationState = 1
                AppPrefrences.saveAppPrefrences(self.prefrence)
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        let alertController = UIAlertController(title: dict.valueForKey(Structures.Constant.Message) as? String , message: "", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                            Utility.forceSignOut()
                        }))
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                }else{
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("reporta"),comment:""), message: dict.valueForKey(Structures.Constant.Message) as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                        }))
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                }
            }
        }
        if wsType == WSRequestType.UnlockSOS{
            if  isSuccess{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        self.isUnlockAppAlertOpen = false
                        self.initializeSOSButton()
                        CheckIn.removeActiveCheckInObject()
                        self.SOSButton.userInteractionEnabled = true
                        self.prefrence.ApplicationState = 0
                        AppPrefrences.saveAppPrefrences(self.prefrence)
                        let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                        self.window?.rootViewController? = homeNavController
                    })
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                
                if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        let alertController = UIAlertController(title: dict.valueForKey(Structures.Constant.Message) as? String , message: "", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                            Utility.forceSignOut()
                        }))
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                }else{
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        self.alertAppLock = UIAlertController(title: NSLocalizedString(Utility.getKey("reporta"),comment:""), message: dict.valueForKey(Structures.Constant.Message) as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        self.alertAppLock.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                            self.showUnlockAppAlert(self.isFromSOS)
                        }))
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.window?.rootViewController?.presentViewController(self.alertAppLock, animated: true, completion: nil)
                        })
                    }else{
                        self.isUnlockAppAlertOpen = false
                        self.showLockedAppAlert(isFromSOS)
                    }
                }
            }
        }

    }
}

