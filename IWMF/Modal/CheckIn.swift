//
//  CheckIn.swift
//  IWMF
//
//  This class is Check-in Model Class. This is used for send Check-in.
//

import Foundation
import CoreData
protocol CheckInModalProtocol{
    func commonCheckInResponse(wsType : WSRequestType, checkIn_ID : NSNumber ,dict : NSDictionary, isSuccess : Bool)
}

enum CheckInStatus: Int32 {
    case Pending = 0
    case Started = 1
    case Confirmed = 2
    case Deleted = 3
    case Closed = 4
    case Missed = 5
}

class CheckIn: NSObject,WSClientDelegate {
    var checkInID: NSNumber!
    var checkInDescription: NSString!
    var notificationID: NSNumber!
    var address: NSString!
    var latitude: NSNumber!
    var longitude: NSNumber!
    var startTime: NSDate!
    var endTime: NSDate!
    var sms: NSString!
    var email: NSString!
    var social: NSString!
    var recievePromt: NSString!
    var frequency: NSNumber!
    var isCustom: NSNumber!
    var noOfConfirmation: NSNumber!
    var status : CheckInStatus!
    var contactLists : NSMutableArray!
    var mediaArray : [Media]!
    var dictCheckInResult : NSDictionary!
    var fbToken : NSString!
    var twitterToken : NSString!
    var twitterTokenSecret : NSString!
    var delegate : CheckInModalProtocol?
    
    
    override init() {
        checkInID           = NSNumber(integer: 0)
        checkInDescription  = ""
        address             = ""
        latitude            = NSNumber(float: 0.0)
        longitude           = NSNumber(float: 0.0)
        startTime           = NSDate()
        endTime             = NSDate(timeIntervalSinceNow: 1800)
        sms                 = ""
        social              = ""
        email               = ""
        recievePromt        = "3"
        frequency           = NSNumber(integer: 30)
        noOfConfirmation    = NSNumber(integer: 1)
        isCustom            = NSNumber(bool: false)
        status              = .Pending
        contactLists        = NSMutableArray()
        mediaArray          = [Media]()
        dictCheckInResult   = NSDictionary()
        fbToken             = ""
        twitterToken        = ""
        twitterTokenSecret  = ""
        
        super.init()
    }
    
    class var sharedInstance : CheckIn {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CheckIn? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CheckIn()
        }
        return Static.instance!
    }
    required init(coder aDecoder: NSCoder)
    {
        self.checkInID = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.CheckInID) as! NSString))!
        self.checkInDescription = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Description) as! NSString)
        self.address = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Address) as! NSString)
        self.latitude = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Latitude) as! NSString))!
        self.longitude = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Longitude) as! NSString))!
        self.startTime = aDecoder.decodeObjectForKey(Structures.CheckIn.StartTime) as! NSDate
        self.endTime = aDecoder.decodeObjectForKey(Structures.CheckIn.EndTime) as! NSDate
        self.sms = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.SMSMessage) as! NSString)
        self.social = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.SocialMessage) as! NSString)
        self.email = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.EmailMessage) as! NSString)
        self.recievePromt = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.ReceivePrompt) as! NSString)
        self.frequency = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Frequency) as! NSString))!
        self.noOfConfirmation = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Confirmation) as! NSString))!
        self.isCustom = NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Custom) as! NSString))!
        self.fbToken = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.FbToken) as! NSString)
        self.twitterToken = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.TwitterToken) as! NSString)
        self.twitterTokenSecret = Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.TwitterTokenSecret) as! NSString)
        let statusValue = Int(NSNumberFormatter().numberFromString(Utility.InternalDecryption(aDecoder.decodeObjectForKey(Structures.CheckIn.Status) as! NSString))!)
        
        switch statusValue {
        case 0:
            self.status = CheckInStatus.Pending
        case 1:
            self.status = CheckInStatus.Started
        case 2:
            self.status = CheckInStatus.Confirmed
        case 3:
            self.status = CheckInStatus.Deleted
        case 4:
            self.status = CheckInStatus.Closed
        case 5:
            self.status = CheckInStatus.Missed
        default:
            self.status = CheckInStatus.Pending
        }
        
        self.contactLists = aDecoder.decodeObjectForKey(Structures.CheckIn.ContactLists) as! NSMutableArray
    }
    func encodeWithCoder(aCoder: NSCoder){
        
        if let checkInID = self.checkInID{
            aCoder.encodeObject(Utility.InternalEncryption(checkInID.stringValue), forKey: Structures.CheckIn.CheckInID)
        }
        if let checkInDescription = self.checkInDescription{
            aCoder.encodeObject(Utility.InternalEncryption(checkInDescription), forKey: Structures.CheckIn.Description)
        }
        if let address = self.address{
            aCoder.encodeObject(Utility.InternalEncryption(address), forKey: Structures.CheckIn.Address)
        }
        if let latitude = self.latitude{
            aCoder.encodeObject(Utility.InternalEncryption(latitude.stringValue), forKey: Structures.CheckIn.Latitude)
        }
        if let longitude = self.longitude{
            aCoder.encodeObject(Utility.InternalEncryption(longitude.stringValue), forKey: Structures.CheckIn.Longitude)
        }
        if let startTime = self.startTime{
            aCoder.encodeObject(startTime, forKey: Structures.CheckIn.StartTime)
        }
        if let endTime = self.endTime{
            aCoder.encodeObject(endTime, forKey: Structures.CheckIn.EndTime)
        }
        if let sms = self.sms{
            aCoder.encodeObject(Utility.InternalEncryption(sms), forKey: Structures.CheckIn.SMSMessage)
        }
        if let social = self.social{
            aCoder.encodeObject(Utility.InternalEncryption(social), forKey: Structures.CheckIn.SocialMessage)
        }
        if let email = self.email{
            aCoder.encodeObject(Utility.InternalEncryption(email), forKey: Structures.CheckIn.EmailMessage)
        }
        if let contactLists = self.contactLists{
            aCoder.encodeObject(contactLists, forKey: Structures.CheckIn.ContactLists)
        }
        if let frequency = self.frequency{
            aCoder.encodeObject(Utility.InternalEncryption(frequency.stringValue), forKey: Structures.CheckIn.Frequency)
        }
        if let noOfConfirmation = self.noOfConfirmation{
            aCoder.encodeObject(Utility.InternalEncryption(noOfConfirmation.stringValue), forKey: Structures.CheckIn.Confirmation)
        }
        if let isCust = self.isCustom{
            aCoder.encodeObject(Utility.InternalEncryption(isCust.stringValue), forKey: Structures.CheckIn.Custom)
        }
        if let recieveP = self.recievePromt{
            aCoder.encodeObject(Utility.InternalEncryption(recieveP), forKey: Structures.CheckIn.ReceivePrompt)
        }
        if let isfbToken = self.fbToken{
            aCoder.encodeObject(Utility.InternalEncryption(isfbToken), forKey: Structures.CheckIn.FbToken)
        }
        
        if let istwitterToken = self.twitterToken{
            aCoder.encodeObject(Utility.InternalEncryption(istwitterToken), forKey: Structures.CheckIn.TwitterToken)
        }
        
        if let istwitterTokenSecret = self.twitterTokenSecret{
            aCoder.encodeObject(Utility.InternalEncryption(istwitterTokenSecret), forKey: Structures.CheckIn.TwitterTokenSecret)
        }
        let status = NSNumber(int: self.status.rawValue)
        
        aCoder.encodeObject(Utility.InternalEncryption(status.stringValue), forKey: Structures.CheckIn.Status)
    }
    class func saveCurrentCheckInObject(checkInObj : CheckIn)
    {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "CheckInDetail")
        fReq.predicate = NSPredicate(format:"checkinName = %@",Structures.AppKeys.ActiveCheckIn)
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                
                let data = NSKeyedArchiver.archivedDataWithRootObject(checkInObj)
                let newItem: CheckInDetail = temp.objectAtIndex(0) as! CheckInDetail
                newItem.checkinData = data
                newItem.checkinName = Structures.AppKeys.ActiveCheckIn
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }else{
                let data = NSKeyedArchiver.archivedDataWithRootObject(checkInObj)
                let newItem: CheckInDetail = NSEntityDescription.insertNewObjectForEntityForName("CheckInDetail", inManagedObjectContext: Structures.Constant.appDelegate.cdh.backgroundContext!) as! CheckInDetail
                newItem.checkinData = data
                newItem.checkinName = Structures.AppKeys.ActiveCheckIn
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }
        } catch _ as NSError{
            result = nil
        }
        
        
        
    }
    class func getCurrentCheckInObject() -> CheckIn
    {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "CheckInDetail")
        fReq.predicate = NSPredicate(format:"checkinName = %@",Structures.AppKeys.ActiveCheckIn)
        
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                return (NSKeyedUnarchiver.unarchiveObjectWithData((temp.objectAtIndex(0) as! CheckInDetail).checkinData!) as? CheckIn)!
            }else{
                
                return CheckIn()
            }
        } catch _ as NSError{
            result = nil
        }
        return CheckIn()
        
    }
    class func removeActiveCheckInObject(){
        Structures.Constant.appDelegate.prefrence.endTime = ""
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        var result: [AnyObject]?
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "CheckInDetail")
        fReq.predicate = NSPredicate(format:"checkinName = %@",Structures.AppKeys.ActiveCheckIn)
        do {
            result = try Structures.Constant.appDelegate.cdh.backgroundContext!.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                Structures.Constant.appDelegate.cdh.backgroundContext!.deleteObject((temp.objectAtIndex(0) as! CheckInDetail))
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }
        } catch  _ as NSError{
            result = nil
        }
    }
    
    class func isAnyCheckInActive() -> Bool{
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "CheckInDetail")
        fReq.predicate = NSPredicate(format:"checkinName = %@",Structures.AppKeys.ActiveCheckIn)
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                return true
            }else{
                return false
            }
        } catch _ as NSError{
            result = nil
        }
        return false
    }
    class func dictFromCheckIN(checkIN : CheckIn) -> NSDictionary{
        let arrContacts = NSMutableArray(array: checkIN.contactLists)
        var strContacts : NSString = ""
        
        for (var i : Int = 0 ; i < arrContacts.count ; i++)
        {
            let str : NSString = (arrContacts.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID)) as! NSString
            if (strContacts.length == 0)
            {
                strContacts = strContacts.stringByAppendingFormat("\(str)");
            }
            else{
                strContacts = strContacts.stringByAppendingFormat(",\(str)");
            }
        }
        
        let dictionary = [
            Structures.CheckIn.CheckIn_ID : checkIN.checkInID,
            Structures.Alert.Description : checkIN.checkInDescription,
            Structures.Alert.Location : checkIN.address,
            Structures.Constant.Latitude : checkIN.latitude,
            Structures.Constant.Longitude : checkIN.longitude,
            Structures.CheckIn.CheckInStartTime : checkIN.startTime.description,
            Structures.CheckIn.CheckInEndTime :  Structures.Constant.appDelegate.prefrence.endTime,
            Structures.CheckIn.MessageSMS : checkIN.sms,
            Structures.CheckIn.MessageSocial : checkIN.social,
            Structures.CheckIn.MessageEmail : checkIN.email,
            Structures.CheckIn.Receive_Prompt : checkIN.recievePromt,
            Structures.CheckIn.CheckIn_Frequency : checkIN.frequency,
            Structures.Constant.Status : NSNumber(int: checkIN.status.rawValue),
            Structures.Alert.ContactList : strContacts,
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Constant.Time : Utility.getUTCFromDate(),
            Structures.User.User_DeviceToken :  Structures.Constant.appDelegate.prefrence.DeviceToken,
            Structures.User.User_DeviceType : "1",
            Structures.Alert.FB_Token : checkIN.fbToken,
            Structures.Alert.Twitter_Token : checkIN.twitterToken,
            Structures.Alert.Twitter_Token_Secret : checkIN.twitterTokenSecret,
        ]
        return dictionary
    }
    
    class func registerCheckIn(checkIN : CheckIn, isNewCheckIn: Bool) -> Void{
        
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = CheckIn.sharedInstance
            if isNewCheckIn == true{
                wsObj.CreateCheckIn(NSMutableDictionary(dictionary:CheckIn.dictFromCheckIN(checkIN)))
            }else{
                wsObj.UpdateCheckIn(NSMutableDictionary(dictionary:CheckIn.dictFromCheckIN(checkIN)))
            }
        }else{
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
        }
    }
    class func updateCheckInStatus(dict : NSMutableDictionary) -> Void
    {
        print(dict.valueForKey(Structures.Constant.Status))
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = CheckIn.sharedInstance
            if dict.valueForKey(Structures.Constant.Status) as! NSNumber == 1
            {
                wsObj.CheckInStarted(NSMutableDictionary(dictionary:dict))
            }
            else if dict.valueForKey(Structures.Constant.Status) as! NSNumber == 2
            {
                wsObj.ConfirmCheckIn(NSMutableDictionary(dictionary:dict))
            }else if dict.valueForKey(Structures.Constant.Status) as! NSNumber == 3
            {
                wsObj.CancelCheckIn(NSMutableDictionary(dictionary:dict))
            }else if dict.valueForKey(Structures.Constant.Status) as! NSNumber == 4
            {
                wsObj.CloseCheckIn(NSMutableDictionary(dictionary:dict))
            }
            
        }else{
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
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
                    if type == WSRequestType.CreateCheckIn
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                            delegate?.commonCheckInResponse(type, checkIn_ID: NSNumber(integer: jsonResult[Structures.CheckIn.CheckIn_ID] as! Int), dict: jsonResult, isSuccess: true)
                        }
                        else
                        {
                            delegate?.commonCheckInResponse(type, checkIn_ID: NSNumber(integer: 0), dict: jsonResult, isSuccess: false)
                        }
                    }else if type == WSRequestType.UpdateCheckIn
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                            delegate?.commonCheckInResponse(type, checkIn_ID: NSNumber(integer: 0), dict: jsonResult, isSuccess: true)
                        }
                        else
                        {
                            delegate?.commonCheckInResponse(type, checkIn_ID: NSNumber(integer: 0), dict: jsonResult, isSuccess: false)
                        }
                    }else if type == WSRequestType.ConfirmCheckIn || type == WSRequestType.CancelCheckIn
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                            delegate?.commonCheckInResponse(type, checkIn_ID: NSNumber(integer: 0), dict: jsonResult, isSuccess: true)
                        }
                        else
                        {
                            delegate?.commonCheckInResponse(type, checkIn_ID: NSNumber(integer: 0), dict: jsonResult, isSuccess: false)
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
