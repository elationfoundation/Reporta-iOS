//
//  AppPrefrences.swift
//  IWMF
//
//  This class is used for Store App Prefrence.
//
//
import CoreData
import UIKit

class AppPrefrences: NSObject {
    var isFacebookSelected : Bool!
    var isTwitterSelected : Bool!
    var userStayLoggedIn : Bool!
    var LanguageSelected : Bool!
    var UserAlredyLoggedIn : Bool!
    var isFacebookAvailable : Bool!
    var isTwitterAvailable : Bool!
    var ApplicationState : NSNumber!
    var laststatustime : NSDate!
    var UserLocationUpdate : NSMutableDictionary!
    var UsersLastKnownLocation : NSMutableDictionary!
    var twitteroAuthTokenSecret : NSString!
    var twitteroAuthToken : NSString!
    var facebookoAuthToken : NSString!
    var SelectedLanguage : NSString!
    var LoggedInUser : NSString!
    var LanguageCode : NSString!
    var endTime : NSString!
    var DeviceToken : String!
    var appEncryptionKey : NSString!
    override init() {
        
        isFacebookSelected = false
        isTwitterSelected = false
        userStayLoggedIn = false
        LanguageSelected = false
        UserAlredyLoggedIn = false
        isTwitterAvailable = false
        isFacebookAvailable = false
        DeviceToken = ""
        ApplicationState = NSNumber(integer: 0)
        UsersLastKnownLocation = NSMutableDictionary()
        UserLocationUpdate = NSMutableDictionary()
        LoggedInUser = ""
        endTime = ""
        LanguageCode = "EN"
        laststatustime = NSDate()
        SelectedLanguage = "English"
        twitteroAuthTokenSecret = ""
        twitteroAuthToken = ""
        facebookoAuthToken = ""
        appEncryptionKey = ""
        
    }
    required init(coder aDecoder: NSCoder)
    {
        self.isFacebookSelected = aDecoder.decodeObjectForKey("isFacebookSelected") as! Bool
        self.isTwitterSelected = aDecoder.decodeObjectForKey("isTwitterSelected") as! Bool
        if aDecoder.decodeObjectForKey("UserAlredyLoggedIn") != nil{
            self.UserAlredyLoggedIn = aDecoder.decodeObjectForKey("UserAlredyLoggedIn") as! Bool
        }
        self.DeviceToken = aDecoder.decodeObjectForKey("DeviceToken") as! String
        self.ApplicationState = aDecoder.decodeObjectForKey(Structures.AppKeys.ApplicationState) as! NSNumber
        self.endTime = aDecoder.decodeObjectForKey("endTime") as! String
        self.UsersLastKnownLocation = aDecoder.decodeObjectForKey("UsersLastKnownLocation") as! NSMutableDictionary
        self.LoggedInUser = aDecoder.decodeObjectForKey(Structures.AppKeys.LoggedInUser) as! NSString
        self.LanguageCode = aDecoder.decodeObjectForKey("LanguageCode") as! NSString
        if let UserAlredyLoggedIn = aDecoder.decodeObjectForKey("userStayLoggedIn") as? Bool{
            self.userStayLoggedIn = UserAlredyLoggedIn
        }
        self.LanguageSelected = aDecoder.decodeObjectForKey("LanguageSelected") as! Bool
        self.isTwitterAvailable = aDecoder.decodeObjectForKey("isTwitterAvailable") as! Bool
        self.isFacebookAvailable = aDecoder.decodeObjectForKey("isFacebookAvailable") as! Bool
        self.laststatustime = aDecoder.decodeObjectForKey(Structures.AppKeys.LastStatusTime) as! NSDate
        self.UserLocationUpdate = aDecoder.decodeObjectForKey("UserLocationUpdate") as! NSMutableDictionary
        self.SelectedLanguage = aDecoder.decodeObjectForKey("SelectedLanguage") as! NSString
        self.twitteroAuthTokenSecret = Utility.getDecryptedString(aDecoder.decodeObjectForKey("twitteroAuthTokenSecret") as! NSString)
        self.twitteroAuthToken = Utility.getDecryptedString(aDecoder.decodeObjectForKey("twitteroAuthToken") as! NSString)
        self.facebookoAuthToken = Utility.getDecryptedString(aDecoder.decodeObjectForKey("facebookoAuthToken") as! NSString)
        if aDecoder.decodeObjectForKey(Structures.User.AppEncryptionKey) != nil {
            self.appEncryptionKey = Utility.getDecryptedString(aDecoder.decodeObjectForKey(Structures.User.AppEncryptionKey) as! NSString)
        }
    }
    func encodeWithCoder(aCoder: NSCoder) {
        if let isFacebookSelected = self.isFacebookSelected{
            aCoder.encodeObject(isFacebookSelected, forKey: "isFacebookSelected")
        }
        if let isTwitterSelected = self.isTwitterSelected{
            aCoder.encodeObject(isTwitterSelected, forKey: "isTwitterSelected")
        }
        if let UserAlredyLoggedIn = self.UserAlredyLoggedIn{
            aCoder.encodeObject(UserAlredyLoggedIn, forKey: "UserAlredyLoggedIn")
        }
        if let DeviceToken = self.DeviceToken{
            aCoder.encodeObject(DeviceToken, forKey: "DeviceToken")
        }
        if let ApplicationState = self.ApplicationState{
            aCoder.encodeObject(ApplicationState, forKey: Structures.AppKeys.ApplicationState)
        }
        if let endTime = self.endTime{
            aCoder.encodeObject(endTime, forKey: "endTime")
        }
        if let UsersLastKnownLocation = self.UsersLastKnownLocation{
            aCoder.encodeObject(UsersLastKnownLocation, forKey: "UsersLastKnownLocation")
        }
        if let LoggedInUser = self.LoggedInUser{
            aCoder.encodeObject(LoggedInUser, forKey: "LoggedInUser")
        }
        if let LanguageCode = self.LanguageCode{
            aCoder.encodeObject(LanguageCode, forKey: "LanguageCode")
        }
        if let userStayLoggedIn = self.userStayLoggedIn{
            aCoder.encodeObject(userStayLoggedIn, forKey: "userStayLoggedIn")
        }
        if let LanguageSelected = self.LanguageSelected{
            aCoder.encodeObject(LanguageSelected, forKey: "LanguageSelected")
        }
        if let laststatustime = self.laststatustime{
            aCoder.encodeObject(laststatustime, forKey: Structures.AppKeys.LastStatusTime)
        }
        if let UserLocationUpdate = self.UserLocationUpdate{
            aCoder.encodeObject(UserLocationUpdate, forKey: "UserLocationUpdate")
        }
        if let SelectedLanguage = self.SelectedLanguage{
            aCoder.encodeObject(SelectedLanguage, forKey: "SelectedLanguage")
        }
        if let twitteroAuthTokenSecret = self.twitteroAuthTokenSecret{
            aCoder.encodeObject(Utility.generateEncryptedString(twitteroAuthTokenSecret as String ), forKey: "twitteroAuthTokenSecret")
        }
        if let twitteroAuthToken = self.twitteroAuthToken{
            aCoder.encodeObject(Utility.generateEncryptedString(twitteroAuthToken as String ), forKey: "twitteroAuthToken")
        }
        if let facebookoAuthToken = self.facebookoAuthToken{
            aCoder.encodeObject(Utility.generateEncryptedString(facebookoAuthToken as String ), forKey: "facebookoAuthToken")
        }
        if let isTwitterAvailable = self.isTwitterAvailable{
            aCoder.encodeObject(isTwitterAvailable, forKey: "isTwitterAvailable")
        }
        if let isFacebookAvailable = self.isFacebookAvailable{
            aCoder.encodeObject(isFacebookAvailable, forKey: "isFacebookAvailable")
        }
        if let appEncryptionKey = self.appEncryptionKey{
            aCoder.encodeObject(Utility.generateEncryptedString(appEncryptionKey as String), forKey: Structures.User.AppEncryptionKey)
        }
    }
    class var sharedInstance : AppPrefrences {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : AppPrefrences? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AppPrefrences()
        }
        return Static.instance!
    }
    
    class func saveAppPrefrences(appPref : AppPrefrences){
        let data = NSKeyedArchiver.archivedDataWithRootObject(appPref)
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "ApplicationData")
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.backgroundContext!.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                let newItem: ApplicationData = temp.objectAtIndex(0) as! ApplicationData
                newItem.appData = data
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }else{
                let newItem: ApplicationData = NSEntityDescription.insertNewObjectForEntityForName("ApplicationData", inManagedObjectContext: Structures.Constant.appDelegate.cdh.backgroundContext!) as! ApplicationData
                newItem.appData = data
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }
        } catch _ as NSError{
            result = nil
        }
    }
    func getAppPrefrences() -> AppPrefrences? {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "ApplicationData")
        
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.backgroundContext!.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                return (NSKeyedUnarchiver.unarchiveObjectWithData((temp.objectAtIndex(0) as! ApplicationData).appData!) as? AppPrefrences)!
            }else{
                return AppPrefrences()
            }
        } catch _ as NSError{
            result = nil
        }
        return AppPrefrences()
    }
}
