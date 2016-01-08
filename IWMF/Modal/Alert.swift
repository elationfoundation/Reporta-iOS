//
//  Alert.swift
//  IWMF
//
//  This class is Alert Model Class. This is used for send Alert.
//
//

import Foundation
protocol AlertModalProtocol{
    func commonAlertResponse(alertID : NSNumber ,dict : NSDictionary, isSuccess : Bool)
}

class Alert: NSObject,WSClientDelegate {
    var alertID : NSNumber
    var situation : NSString!
    var alertDescription: NSString!
    var latitude: NSNumber!
    var longitude: NSNumber!
    var address: NSString!
    var contactLists :NSMutableArray!
    var mediaArray : [Media]!
    var fbToken : NSString!
    var twitterToken : NSString!
    var twitterTokenSecret : NSString!
    var delegate : AlertModalProtocol?
    
    override init() {
        alertID = NSNumber(integer: 0)
        situation = ""
        address = ""
        alertDescription = ""
        latitude = 0
        longitude = 0
        contactLists = NSMutableArray()
        mediaArray = [Media]()
        fbToken             = ""
        twitterToken        = ""
        twitterTokenSecret  = ""
        super.init()
    }
    class var sharedInstance : Alert {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Alert? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Alert()
        }
        return Static.instance!
    }
    class func dictFromAlert(alert : Alert) -> NSDictionary{
        let arrContacts = NSMutableArray(array: alert.contactLists)
        var strContacts : NSString = ""
        
        for (var i : Int = 0 ; i < arrContacts.count ; i++)
        {
            let str : NSString = (arrContacts.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID)) as! NSString
            if (strContacts.length == 0)
            {
                strContacts = strContacts.stringByAppendingFormat("\(str)")
            }
            else{
                strContacts = strContacts.stringByAppendingFormat(",\(str)")
            }
        }
        
        let dictionary = [
            Structures.Alert.AlertID : alert.alertID,
            Structures.Alert.Description : alert.alertDescription,
            Structures.Alert.Situation : alert.situation,
            Structures.Alert.Location : alert.address,
            Structures.Constant.Latitude : alert.latitude,
            Structures.Constant.Longitude : alert.longitude,
            Structures.Alert.ContactList : strContacts,
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Alert.FB_Token : alert.fbToken,
            Structures.Alert.Twitter_Token : alert.twitterToken,
            Structures.Alert.Twitter_Token_Secret : alert.twitterTokenSecret,
            Structures.Constant.Time : Utility.getUTCFromDate(),
            Structures.Alert.SafetyCheckin : "0",
            Structures.Alert.MediaCount : alert.mediaArray.count
        ]
        return dictionary
    }
    
    class func sendAlert(alert : Alert) -> Void{
        if  Utility.isConnectedToNetwork(){
            let wsObj : WSClient = WSClient()
            wsObj.delegate = Alert.sharedInstance
            wsObj.SendAlert(NSMutableDictionary(dictionary:Alert.dictFromAlert(alert)))
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
                    if type == WSRequestType.Alert
                    {
                        if  jsonResult.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                            delegate?.commonAlertResponse(NSNumber(integer: jsonResult[Structures.Alert.AlertID] as! Int), dict:jsonResult, isSuccess: true)
                        }
                        else
                        {
                            delegate?.commonAlertResponse(NSNumber(integer: 0), dict:jsonResult, isSuccess: false)
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
