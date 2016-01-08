//
//  SOS.swift
//  IWMF
//
//  This class is used for store detail of SOS
//
//

import Foundation
import CoreLocation
import CoreData

protocol SOSModalProtocol{
    func commonSOSResponse(wsType : WSRequestType, dict : NSDictionary, isSuccess : Bool)
}

class SOS: NSObject,WSClientDelegate {
    var sosID : NSNumber!
    var latitude : NSNumber!
    var longitude : NSNumber!
    var delegate : SOSModalProtocol?
    
    override init() {
        sosID = NSNumber(integer: 0)
        latitude = NSNumber(double: 0.0)
        longitude = NSNumber(double: 0.0)
        super.init()
    }
    class var sharedInstance : SOS {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : SOS? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SOS()
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder){
        self.sosID  = aDecoder.decodeObjectForKey(Structures.SOS.SosID) as! NSNumber
    }
    func encodeWithCoder(aCoder: NSCoder) {
        if let sosID = self.sosID{
            aCoder.encodeObject(sosID, forKey: Structures.SOS.SosID)
        }
    }
    class func saveSOSObject(sosObj : SOS){
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "SOSData")
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                let data = NSKeyedArchiver.archivedDataWithRootObject(sosObj)
                let newItem: SOSData = temp.objectAtIndex(0) as! SOSData
                newItem.sosData = data
                newItem.sosName = Structures.AppKeys.ActiveSos
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }else{
                let data = NSKeyedArchiver.archivedDataWithRootObject(sosObj)
                let newItem: SOSData = NSEntityDescription.insertNewObjectForEntityForName("SOSData", inManagedObjectContext: Structures.Constant.appDelegate.cdh.backgroundContext!) as! SOSData
                newItem.sosData = data
                newItem.sosName = Structures.AppKeys.ActiveSos
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }
        } catch _ as NSError{
            result = nil
        }
    }
    class func getCurrentSOSObject() -> SOS
    {
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "SOSData")
        fReq.predicate = NSPredicate(format:"sosName = %@",Structures.AppKeys.ActiveSos)
        
        var result: [AnyObject]?
        do {
            result = try Structures.Constant.appDelegate.cdh.managedObjectContext.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                return (NSKeyedUnarchiver.unarchiveObjectWithData((temp.objectAtIndex(0) as! SOSData).sosData!) as? SOS)!
            }else{
                return SOS()
            }
        } catch _ as NSError{
            result = nil
        }
        return SOS()
    }
    
    class func removeActiveSOSObject(){
        var result: [AnyObject]?
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "SOSData")
        fReq.predicate = NSPredicate(format:"sosName = %@",Structures.AppKeys.ActiveSos)
        do {
            result = try Structures.Constant.appDelegate.cdh.backgroundContext!.executeFetchRequest(fReq)
            let temp : NSArray = result!
            if temp.count > 0{
                Structures.Constant.appDelegate.cdh.backgroundContext!.deleteObject((temp.objectAtIndex(0) as! SOSData))
                Structures.Constant.appDelegate.cdh.saveContext(Structures.Constant.appDelegate.cdh.backgroundContext!)
            }
        } catch  _ as NSError{
            result = nil
        }
    }
    class func setActiveSosID(sosID : NSNumber){
        NSUserDefaults.standardUserDefaults().setObject(sosID, forKey: Structures.AppKeys.ActiveSosID)
    }
    class func getActiveSosID() -> NSNumber{
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(Structures.AppKeys.ActiveSosID) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSNumber!
        }
        return NSNumber(int: 0)
    }
    func dictForSOS() -> NSDictionary{
        let dictionary = [
            Structures.Constant.Latitude : latitude,
            Structures.Constant.Longitude : longitude,
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Constant.Time : Utility.getUTCFromDate()
        ]
        return dictionary
    }
    func locationUpdate(notification: NSNotification){
        let userLocation = notification.object as! CLLocation!
        latitude = NSNumber(double: userLocation.coordinate.latitude)
        longitude = NSNumber(double: userLocation.coordinate.longitude)
    }
    func sos() -> Void{
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = SOS.sharedInstance
            wsObj.LockSOS(NSMutableDictionary(dictionary:dictForSOS()))
        }
    }
    func dictToUnlockSOS(password : NSString, passcode : NSString) -> NSDictionary
    {
        var userDetail = User()
        userDetail = userDetail.getLoggedInUser()!
        
        let dictionary = [
            Structures.Constant.Latitude : NSNumber(integer: 0),
            Structures.Constant.Longitude : NSNumber(integer: 0),
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Constant.Time : Utility.getUTCFromDate(),
            Structures.User.User_Password : password,
            Structures.SOS.OTP : passcode,
            Structures.SOS.SOS_ID : sosID,
            Structures.CheckIn.CheckIn_ID : userDetail.checkin_id
        ]
        return dictionary
    }
    func unlockSOS(password : NSString, passcode : NSString) -> Void
    {
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = SOS.sharedInstance
            wsObj.UnlockSOS(NSMutableDictionary(dictionary:dictToUnlockSOS(password, passcode: passcode)))
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
                    if type == WSRequestType.LockSOS
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                            self.sosID = NSNumber(integer: jsonResult[Structures.SOS.SOS_ID] as! Int)
                            SOS.saveSOSObject(self)
                            delegate?.commonSOSResponse(type, dict: jsonResult, isSuccess: true)
                        }
                        else
                        {
                            delegate?.commonSOSResponse(type, dict: jsonResult, isSuccess: false)
                            
                        }
                    }else if type == WSRequestType.UnlockSOS
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                            var userDetail = User()
                            userDetail = userDetail.getLoggedInUser()!
                            userDetail.lockstatus = 0
                            User.saveUserObject(userDetail)
                            SOS.removeActiveSOSObject()
                            delegate?.commonSOSResponse(type, dict: jsonResult, isSuccess: true)
                        }
                        else
                        {
                            delegate?.commonSOSResponse(type, dict: jsonResult, isSuccess: false)
                            
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