//
//  User.swift
//  IWMF
//
//
//  This class is used for store detail of User
//

import Foundation
import CoreLocation
import CoreData

protocol UserModalProtocol{
    func commonUserResponse(wsType : WSRequestType ,dict : NSDictionary, isSuccess : Bool)
}
class User: NSObject, WSClientDelegate {
    var userName: NSString!
    var selectedLanguage : NSString!
    var languageCode : NSString!
    var email: NSString!
    var firstName: NSString!
    var lastName: NSString!
    var phone: NSString!
    var jobTitle: NSString!
    var affiliation: NSString!
    var isFreeLancer: NSNumber!
    var origin: NSString!
    var working: NSString!
    var password: NSString!
    var sendMail: NSNumber!
    var sendConfirmationMail: NSNumber!
    var statusValue: NSNumber!
    var gender: NSString!
    var gender_type : NSString!
    var lockstatus : NSNumber!
    var checkin_id : NSNumber!
    var headertoken : NSString!
    var delegate : UserModalProtocol?
    
    override init() {
        userName = ""
        selectedLanguage = "English"
        languageCode = Structures.Constant.English
        email = ""
        firstName = ""
        lastName = ""
        phone = ""
        jobTitle = ""
        affiliation = ""
        origin = ""
        working = ""
        password = ""
        gender = ""
        gender_type = ""
        headertoken = "0"
        isFreeLancer = false
        sendMail = true
        sendConfirmationMail = true
        statusValue = NSNumber(integer: 0)
        lockstatus = NSNumber(integer: 0)
        checkin_id = NSNumber(integer: 0)
        super.init()
    }
    class var sharedInstance : User {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : User? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = User()
        }
        return Static.instance!
    }
    required init(coder aDecoder: NSCoder)
    {
        self.userName = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.UserName) as! NSString)
        self.selectedLanguage =  Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.SelectedLanguage) as! NSString)
        self.languageCode = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.LanguageCode) as! NSString)
        self.email = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.Email) as! NSString)
        self.firstName = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.FirstName) as! NSString)
        self.lastName = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.LastName) as! NSString)
        self.phone = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.Phone) as! NSString)
        self.jobTitle = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.JobTitle) as! NSString)
        self.affiliation = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.Affiliation) as! NSString)
        self.origin = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.Origin) as! NSString)
        self.working = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.Working) as! NSString)
        self.gender = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.Gender) as! NSString)
        self.gender_type = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.GenderType) as! NSString)
        
        self.isFreeLancer = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.IsFreeLancer) as! NSString))!
        self.sendMail = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.SendMail) as! NSString))!
        self.sendConfirmationMail = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.SendConfirmationMail) as! NSString))!
        self.statusValue = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.StatusValue) as! NSString))!
        self.lockstatus = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.LockStatus) as! NSString))!
        self.checkin_id = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.CheckInID) as! NSString))!
        
        //When Header token find nil in stay logIn App than we check it is nil or not. if nil than Force loout from App else continue.
        if aDecoder.decodeObjectForKey(Structures.User.HeaderToken) == nil {
            let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("reporta"),comment:""), message:NSLocalizedString(Utility.getKey("sessionExpired"),comment:""), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                Structures.Constant.appDelegate.setLoginScreen()
            }))
            
            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            
            Structures.Constant.appDelegate.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            return
        }else{
            self.headertoken = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.User.HeaderToken) as! NSString)
        }
    }
    func encodeWithCoder(aCoder: NSCoder){
        if let userName = self.userName{
            aCoder.encodeObject(Utility.InternalEncryption(userName), forKey: Structures.User.UserName)
        }
        if let selectedLanguage = self.selectedLanguage{
            aCoder.encodeObject(Utility.InternalEncryption(selectedLanguage), forKey: Structures.User.SelectedLanguage)
        }
        if let languageCode = self.languageCode{
            aCoder.encodeObject(Utility.InternalEncryption(languageCode), forKey: Structures.User.LanguageCode)
        }
        if let email = self.email{
            aCoder.encodeObject(Utility.InternalEncryption(email), forKey: Structures.User.Email)
        }
        if let firstName = self.firstName{
            aCoder.encodeObject(Utility.InternalEncryption(firstName), forKey: Structures.User.FirstName)
        }
        if let lastName = self.lastName{
            aCoder.encodeObject(Utility.InternalEncryption(lastName), forKey: Structures.User.LastName)
        }
        if let phone = self.phone{
            aCoder.encodeObject(Utility.InternalEncryption(phone), forKey: Structures.User.Phone)
        }
        if let jobTitle = self.jobTitle{
            aCoder.encodeObject(Utility.InternalEncryption(jobTitle), forKey: Structures.User.JobTitle)
        }
        if let affiliation = self.affiliation{
            aCoder.encodeObject(Utility.InternalEncryption(affiliation), forKey: Structures.User.Affiliation)
        }
        if let isFreeLancer = self.isFreeLancer{
            aCoder.encodeObject(Utility.InternalEncryption(isFreeLancer.stringValue), forKey: Structures.User.IsFreeLancer)
        }
        if let origin = self.origin{
            aCoder.encodeObject(Utility.InternalEncryption(origin), forKey: Structures.User.Origin)
        }
        if let working = self.working{
            aCoder.encodeObject(Utility.InternalEncryption(working), forKey: Structures.User.Working)
        }
        if let sendMail = self.sendMail{
            aCoder.encodeObject(Utility.InternalEncryption(sendMail.stringValue), forKey: Structures.User.SendMail)
        }
        if let sendConfirmationMail = self.sendConfirmationMail{
            aCoder.encodeObject(Utility.InternalEncryption(sendConfirmationMail.stringValue), forKey: Structures.User.SendConfirmationMail)
        }
        if let statusValue = self.statusValue{
            aCoder.encodeObject(Utility.InternalEncryption(statusValue.stringValue), forKey: Structures.User.StatusValue)
        }
        if let gender = self.gender{
            aCoder.encodeObject(Utility.InternalEncryption(gender), forKey: Structures.User.Gender)
        }
        if let gender_type = self.gender_type{
            aCoder.encodeObject(Utility.InternalEncryption(gender_type), forKey: Structures.User.GenderType)
        }
        
        if let lockstatus = self.lockstatus{
            aCoder.encodeObject(Utility.InternalEncryption(lockstatus.stringValue), forKey: Structures.User.LockStatus)
        }
        if let checkin_id = self.checkin_id{
            aCoder.encodeObject(Utility.InternalEncryption(checkin_id.stringValue), forKey: Structures.User.CheckInID)
        }
        if let headertoken = self.headertoken{
            aCoder.encodeObject(Utility.InternalEncryption(headertoken), forKey: Structures.User.HeaderToken)
        }
    }
    
    class func saveUserObject(user : User){
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "UserDetail")
        fReq.predicate = NSPredicate(format:"userName = %@",user.userName as String)
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                let data = NSKeyedArchiver.archivedDataWithRootObject(user)
                let newItem: UserDetail = temp.objectAtIndex(0) as! UserDetail
                newItem.userData = data
                newItem.userName = user.userName as String
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }else{
                let data = NSKeyedArchiver.archivedDataWithRootObject(user)
                let newItem: UserDetail = NSEntityDescription.insertNewObjectForEntityForName("UserDetail", inManagedObjectContext: Structures.Constant.appDelegate.cdh.backgroundContext!) as! UserDetail
                newItem.userData = data
                newItem.userName = user.userName as String
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }
        } catch _ as NSError{
            result = nil
        }
        
    }
    class func getUserObject(userNameValue : NSString) -> User? {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "UserDetail")
        fReq.predicate = NSPredicate(format:"userName = %@",userNameValue)
        
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                return NSKeyedUnarchiver.unarchiveObjectWithData((temp.objectAtIndex(0) as! UserDetail).userData!) as? User
            }else{
                Utility.forceSignOut()
                return User.sharedInstance
            }
        } catch _ as NSError{
            result = nil
        }
        return nil
    }
    
    func getLoggedInUser()-> User? {
        if let logInUserName = Structures.Constant.appDelegate.prefrence.LoggedInUser {
            return User.getUserObject(logInUserName)
        }
        return nil
    }
    class func getLoggedInUser()-> User? {
        if let logInUserName = Structures.Constant.appDelegate.prefrence.LoggedInUser{
            return User.getUserObject(logInUserName)
        }
        return nil
    }
    class func removeActiveUser(){
        if let logInUserName = Structures.Constant.appDelegate.prefrence.LoggedInUser {
            
            var result: [AnyObject]?
            let fReq: NSFetchRequest = NSFetchRequest(entityName: "UserDetail")
            fReq.predicate = NSPredicate(format:"userName = %@",logInUserName)
            do {
                result = try Structures.Constant.appDelegate.cdh.backgroundContext!.executeFetchRequest(fReq)
                let temp : NSArray = result!
                if temp.count > 0{
                    Structures.Constant.appDelegate.cdh.backgroundContext!.deleteObject((temp.objectAtIndex(0) as! UserDetail))
                    Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
                }
            } catch  _ as NSError{
                result = nil
            }
        }
    }
    class func dictForPassword(email : NSString) -> NSDictionary{
        let dictionary = [Structures.User.UserEmail : email,
            Structures.User.User_LanguageCode : Structures.Constant.appDelegate.prefrence.LanguageCode
        ]
        return dictionary
    }
    class func dictForSignOut() -> NSDictionary{
        let dictionary = ["" : ""
        ]
        return dictionary
    }
    class func dictToCheckUsernameEmail(username : NSString,email : NSString) -> NSDictionary{
        let dictionary = [
            Structures.User.User_Name : username,
            Structures.User.UserEmail : email,
            Structures.User.User_LanguageCode : Structures.Constant.appDelegate.prefrence.LanguageCode
        ]
        return dictionary
    }
    class func dictToLogin(deviceToken : NSString, username : NSString, password : NSString , forcelogin : NSString) -> NSDictionary{
        let dictionary = [Structures.User.User_Name : username,
            Structures.User.User_Password : password,
            Structures.User.User_DeviceToken : deviceToken,
            Structures.User.User_DeviceType : "1",
            Structures.User.ForceLogin : forcelogin,
            Structures.User.User_LanguageCode : Structures.Constant.appDelegate.prefrence.LanguageCode
        ]
        return dictionary
    }
    
    class func dictToRegister(deviceToken : NSString, user : User, contact : NSArray) -> NSDictionary{
        let dictionary = [
            Structures.User.User_Language : Structures.Constant.appDelegate.prefrence.SelectedLanguage,
            Structures.User.User_LanguageCode : Structures.Constant.appDelegate.prefrence.LanguageCode,
            Structures.User.User_Name :user.userName,
            Structures.User.UserEmail : user.email,
            Structures.User.User_FirstName : user.firstName,
            Structures.User.User_LastName : user.lastName,
            Structures.User.User_Phone : user.phone,
            Structures.User.User_Password : user.password,
            Structures.User.CountryOrigin : user.origin,
            Structures.User.CountryWorking : user.working,
            Structures.User.AffiliationID : user.affiliation,
            Structures.User.Freelancer : user.isFreeLancer,
            Structures.User.User_JobTitle : user.jobTitle,
            Structures.User.User_SendMail : user.sendMail,
            Structures.User.SendUpdateFromReporta : user.sendConfirmationMail,
            Structures.User.User_DeviceType : "1",
            Structures.Constant.Status : "1",
            Structures.User.User_DeviceToken : deviceToken,
            Structures.User.CircleType : "1",
            Structures.Constant.ListID : "",
            Structures.Constant.DefaultStatus : Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.DefaultStatus] as! NSString,
            Structures.Constant.ListName: Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.ListName] as! NSString,
            Structures.User.User_Gender : user.gender,
            Structures.User.User_GenderType : user.gender_type,
            Structures.Constant.Contacts : contact,
            Structures.User.IsCreateUser : "1"
        ]
        return dictionary
    }
    class func dictToUpdate(deviceToken : NSString, user : User) -> NSDictionary{
        
        let dictionary = [
            Structures.User.User_Language :  Structures.Constant.appDelegate.prefrence.SelectedLanguage,
            Structures.User.User_LanguageCode : Structures.Constant.appDelegate.prefrence.LanguageCode,
            Structures.User.User_Name :user.userName,
            Structures.User.UserEmail : user.email,
            Structures.User.User_FirstName : user.firstName,
            Structures.User.User_LastName : user.lastName,
            Structures.User.User_Phone : user.phone,
            Structures.User.CountryOrigin : user.origin,
            Structures.User.CountryWorking : user.working,
            Structures.User.AffiliationID : user.affiliation,
            Structures.User.Freelancer : user.isFreeLancer,
            Structures.User.User_JobTitle : user.jobTitle,
            Structures.User.User_SendMail : user.sendMail,
            Structures.User.SendUpdateFromReporta : user.sendConfirmationMail,
            Structures.User.User_DeviceType : "1",
            Structures.Constant.Status : "1",
            Structures.User.User_DeviceToken : deviceToken,
            Structures.User.User_Gender : user.gender,
            Structures.User.User_GenderType : user.gender_type,
            Structures.User.IsCreateUser : "0"
        ]
        return dictionary
    }
    
    class func objectFromDict(dict : NSDictionary) -> User{
        let user = User()
        user.userName = NSString(string: dict[Structures.User.User_Name] as! NSString)
        user.email = NSString(string: dict[Structures.User.UserEmail] as! NSString)
        user.selectedLanguage = NSString(string: dict[Structures.User.User_Language] as! NSString)
        user.languageCode = NSString(string: dict[Structures.User.User_LanguageCode] as! NSString)
        user.firstName = NSString(string: dict[Structures.User.User_FirstName] as! NSString)
        user.lastName = NSString(string: dict[Structures.User.User_LastName] as! NSString)
        user.phone = NSString(string: dict[Structures.User.User_Phone] as! NSString)
        user.origin = NSString(string: dict[Structures.User.CountryOrigin] as! NSString)
        user.working = NSString(string: dict[Structures.User.CountryWorking] as! NSString)
        user.affiliation = NSString(string: dict[Structures.User.AffiliationID] as! NSString)
        user.isFreeLancer = NSNumber(bool: (dict[Structures.User.Freelancer] as! NSString).boolValue)
        user.jobTitle = NSString(string: dict[Structures.User.User_JobTitle] as! NSString)
        user.sendMail = NSNumber(bool: (dict[Structures.User.User_SendMail] as! NSString).boolValue)
        user.sendConfirmationMail = NSNumber(bool: (dict[Structures.User.SendUpdateFromReporta] as! NSString).boolValue)
        user.gender = NSString(string: dict[Structures.User.User_Gender] as! NSString)
        user.gender_type = NSString(string: dict[Structures.User.User_GenderType] as! NSString)
        user.lockstatus = NSNumber(integer: (dict[Structures.User.User_LockStatus] as! Int))
        user.checkin_id = NSNumber(integer: (dict[Structures.CheckIn.CheckIn_ID] as! NSString).integerValue)
        user.headertoken = NSString(string: dict[Structures.Constant.Headertoken] as! NSString)
        return user
    }
    class func updatedObjectFromDict(dict : NSDictionary) -> User{
        let user = User()
        user.userName = NSString(string: dict[Structures.User.User_Name] as! NSString)
        user.email = NSString(string: dict[Structures.User.UserEmail] as! NSString)
        user.selectedLanguage = NSString(string: dict[Structures.User.User_Language] as! NSString)
        user.languageCode = NSString(string: dict[Structures.User.User_LanguageCode] as! NSString)
        user.firstName = NSString(string: dict[Structures.User.User_FirstName] as! NSString)
        user.lastName = NSString(string: dict[Structures.User.User_LastName] as! NSString)
        user.phone = NSString(string: dict[Structures.User.User_Phone] as! NSString)
        user.origin = NSString(string: dict[Structures.User.CountryOrigin] as! NSString)
        user.working = NSString(string: dict[Structures.User.CountryWorking] as! NSString)
        user.affiliation = NSString(string: dict[Structures.User.AffiliationID] as! NSString)
        user.isFreeLancer = NSNumber(bool: (dict[Structures.User.Freelancer] as! NSString).boolValue)
        user.jobTitle = NSString(string: dict[Structures.User.User_JobTitle] as! NSString)
        user.sendMail = NSNumber(bool: (dict[Structures.User.User_SendMail] as! NSString).boolValue)
        user.sendConfirmationMail = NSNumber(bool: (dict[Structures.User.SendUpdateFromReporta] as! NSString).boolValue)
        user.gender = NSString(string: dict[Structures.User.User_Gender] as! NSString)
        user.gender_type = NSString(string: dict[Structures.User.User_GenderType] as! NSString)
        user.lockstatus = NSNumber(integer: (dict[Structures.User.User_LockStatus] as! Int))
        user.checkin_id = NSNumber(integer: (dict[Structures.CheckIn.CheckIn_ID] as! NSString).integerValue)
        user.headertoken = NSString(string: dict[Structures.Constant.Headertoken] as! NSString)
        return user
    }
    class func loginUser(dict : NSMutableDictionary) -> Void{
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = User.sharedInstance
            wsObj.userLogin(dict)
        }else{
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
        }
    }
    
    class func registerUser(dict : NSMutableDictionary,isNewUser : Bool) -> Void{
        if  Utility.isConnectedToNetwork(){
            if  Utility.isConnectedToNetwork(){
                let wsObj : WSClient = WSClient()
                wsObj.delegate = User.sharedInstance
                if isNewUser == true{
                    wsObj.registerUser(dict)
                }else
                {
                    wsObj.updateUser(dict)
                }
            }
        }else{
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
        }
    }
    class func forgetPassword(dict : NSMutableDictionary) -> Void{
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = User.sharedInstance
            wsObj.forgetPassword(dict)
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
            })
        }
    }
    class func signOutUser(dict : NSMutableDictionary) -> Void{
        
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = User.sharedInstance
            wsObj.signOut(dict)
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
            })
        }
    }
    class func  checkUsernameEmail(dict : NSMutableDictionary) -> Void {
        
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = User.sharedInstance
            wsObj.CheckUserNameEmail(dict)
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
            })
        }
    }
    //MARK:- WebService
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if  (response is NSString)
        {
            SVProgressHUD.dismiss()
        }
        else{
            if let data : NSData? = NSData(data: response as! NSData)
            {
                if let jsonResult: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if type == WSRequestType.Login
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            print(jsonResult)
                            let dictionary : NSDictionary = jsonResult["data"] as! NSDictionary
                            Structures.Constant.appDelegate.prefrence.appEncryptionKey = NSString(string: dictionary["app_encryption_key"] as! NSString)
                            let user : User = User.objectFromDict(dictionary)
                            
                            //activecheckin tag will Get Array of Checkin Detail Object
                            if (dictionary[Structures.AppKeys.Active_CheckIn] as! NSArray).count > 0
                            {
                                //Re-Create active CheckIn
                                if CheckIn.isAnyCheckInActive()
                                {
                                    CheckIn.removeActiveCheckInObject()
                                }
                                
                                let dictTemp : NSDictionary = (dictionary[Structures.AppKeys.Active_CheckIn] as! NSArray) .objectAtIndex(0) as! NSDictionary
                                
                                user.checkin_id = NSNumberFormatter().numberFromString(dictTemp[Structures.AppKeys.ID] as! String)
                                
                                Structures.Constant.appDelegate.prefrence.laststatustime = Utility.getSystemTimeZoneFromDate((dictTemp[Structures.AppKeys.LastStatusTime] as! String))
                                
                                var Checkin : CheckIn!
                                Checkin = CheckIn()
                                Checkin.checkInID = NSNumberFormatter().numberFromString(dictTemp[Structures.AppKeys.ID] as! String)
                                Checkin.checkInDescription = dictTemp[Structures.Alert.Description] as! NSString
                                Checkin.address = dictTemp[Structures.Alert.Location] as! NSString
                                Checkin.latitude = NSNumberFormatter().numberFromString(dictTemp[Structures.Constant.Latitude] as! String)
                                Checkin.longitude = NSNumberFormatter().numberFromString(dictTemp[Structures.Constant.Longitude] as! String)
                                Checkin.startTime = Utility.getSystemTimeZoneFromDate((dictTemp[Structures.CheckIn.CheckInStartTime] as! String))
                                Checkin.sms = dictTemp[Structures.CheckIn.MessageSMS] as! NSString
                                Checkin.social = dictTemp[Structures.CheckIn.MessageSocial] as! NSString
                                Checkin.email = dictTemp[Structures.CheckIn.MessageEmail] as! NSString
                                Checkin.recievePromt = dictTemp[Structures.CheckIn.Receive_Prompt] as! NSString
                                Checkin.frequency = NSNumberFormatter().numberFromString(dictTemp[Structures.CheckIn.CheckIn_Frequency] as! String)
                                Checkin.fbToken = (dictTemp[Structures.Alert.FB_Token] as! String)
                                Checkin.twitterToken = (dictTemp[Structures.Alert.Twitter_Token] as! String)
                                Checkin.twitterTokenSecret = (dictTemp[Structures.Alert.Twitter_Token_Secret] as! String)
                                
                                if dictTemp[Structures.CheckIn.CheckInConfirmedCount] != nil
                                {
                                    Checkin.noOfConfirmation = NSNumberFormatter().numberFromString(dictTemp[Structures.CheckIn.CheckInConfirmedCount] as! String)
                                }
                                
                                let noOfConfirmation : Int = Checkin.noOfConfirmation.integerValue + 1
                                Checkin.noOfConfirmation = NSNumber(integer: noOfConfirmation)
                                
                                if (dictTemp[Structures.CheckIn.CheckInEndTime] as! String) == "0000-00-00 00:00:00"
                                {
                                    Structures.Constant.appDelegate.prefrence.endTime = ""
                                    
                                    let date = NSDate(timeInterval: (Checkin.frequency.doubleValue  * 60 * 24 ), sinceDate: Utility.getSystemTimeZoneFromDate((dictTemp[Structures.AppKeys.LastStatusTime] as! String)))
                                    Checkin.endTime = date
                                }
                                else
                                {
                                    Checkin.endTime  = Utility.getSystemTimeZoneFromDate((dictTemp[Structures.CheckIn.CheckInEndTime] as! String))
                                    Structures.Constant.appDelegate.prefrence.endTime = Checkin.endTime.description
                                }
                                
                                if dictTemp[Structures.Constant.Status] as! String == "0"
                                {
                                    Checkin.status = CheckInStatus.Pending
                                }
                                else if dictTemp[Structures.Constant.Status] as! String == "1"
                                {
                                    Checkin.status = CheckInStatus.Started
                                }
                                else if dictTemp[Structures.Constant.Status] as! String == "2"
                                {
                                    Checkin.status = CheckInStatus.Confirmed
                                }
                                else if dictTemp[Structures.Constant.Status] as! String == "3"
                                {
                                    Checkin.status = CheckInStatus.Deleted
                                }
                                else if dictTemp[Structures.Constant.Status] as! String == "4"
                                {
                                    Checkin.status = CheckInStatus.Closed
                                }
                                else if dictTemp[Structures.Constant.Status] as! String == "5"
                                {
                                    Checkin.status = CheckInStatus.Missed
                                }
                                CheckIn.saveCurrentCheckInObject(Checkin)
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                            }
                            
                            User.saveUserObject(user)
                            Structures.Constant.appDelegate.prefrence.LoggedInUser = user.userName
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = true
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            
                            delegate?.commonUserResponse(type, dict: dictionary, isSuccess: true)
                        }
                        else
                        {
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: false)
                        }
                    }else if type == WSRequestType.UpdateUser{
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            let dictionary : NSDictionary = jsonResult["data"] as! NSDictionary
                            Structures.Constant.appDelegate.prefrence.appEncryptionKey = NSString(string: dictionary["app_encryption_key"] as! NSString)
                            let user : User = User.updatedObjectFromDict(dictionary)
                            User.saveUserObject(user)
                            delegate?.commonUserResponse(type, dict:dictionary, isSuccess: true)
                        }else{
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: false)
                        }
                    }
                    else if type == WSRequestType.Register
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            let dictionary : NSDictionary = jsonResult["data"] as! NSDictionary
                            Structures.Constant.appDelegate.prefrence.appEncryptionKey = NSString(string: dictionary["app_encryption_key"] as! NSString)
                            let user : User = User.objectFromDict(dictionary)
                            User.saveUserObject(user)
                            Structures.Constant.appDelegate.prefrence.LoggedInUser = user.userName
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = true
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:dictionary, isSuccess: true)
                        }else
                        {
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: false)
                        }
                    }
                    else if type == WSRequestType.ForgetPassword
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            print(jsonResult)
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:jsonResult, isSuccess: true)
                        }else
                        {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                SVProgressHUD.dismiss()
                            })
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: false)
                        }
                    }
                    else if type == WSRequestType.SignOut
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            User.removeActiveUser()
                            Structures.Constant.appDelegate.prefrence.LoggedInUser = ""
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: true)
                        }else{
                            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = true
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: false)
                        }
                    }
                    else if type == WSRequestType.CheckUserNameEmail
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: true)
                        }else{
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                SVProgressHUD.showErrorWithStatus(jsonResult[Structures.Constant.Message] as! String)
                            })
                            delegate?.commonUserResponse(type, dict:jsonResult as NSDictionary, isSuccess: false)
                        }
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                    }
                }
            }
            else{
                SVProgressHUD.dismiss()
            }
        }
    }
    func WSResponseEoor(error:NSError, ReqType type:WSRequestType)
    {
        SVProgressHUD.dismiss()
    }
}

