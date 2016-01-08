//
//  Media.swift
//  IWMF
//
//  This class is used for store detail of Media
//
//

import Foundation
import CoreTelephony

enum MediaType: Int {
    case Image = 1
    case Video = 2
    case Audio = 3
}

enum NotificationType : Int{
    case CheckIn = 1
    case Alert = 2
}

class Media: NSObject
{
    var time: NSDate!
    var name: String!
    var notificationID: NSNumber!
    var mediaType : MediaType!
    var noficationType : NotificationType!
    var uploadCount : NSNumber!
    override init() {
        notificationID = NSNumber(integer: 0)
        name = ""
        time = NSDate()
        mediaType = .Image
        noficationType = .Alert
        uploadCount = 0
        super.init()
    }
    required init(coder aDecoder: NSCoder)
    {
        self.notificationID  = aDecoder.decodeObjectForKey(Structures.Media.NotificationID) as! NSNumber
        self.name = aDecoder.decodeObjectForKey(Structures.Media.Name) as! String
        self.time = aDecoder.decodeObjectForKey(Structures.Media.Time) as! NSDate
        let mediaTypeV = Int(aDecoder.decodeObjectForKey(Structures.Media.MediaType) as! NSNumber)
        switch mediaTypeV {
            
        case 1:
            self.mediaType = MediaType.Image
        case 2:
            self.mediaType = MediaType.Video
        case 3:
            self.mediaType = MediaType.Audio
            
        default:
            self.mediaType = MediaType.Image
        }
        
        let notifTypeV = Int(aDecoder.decodeObjectForKey(Structures.Media.NoficationType) as! NSNumber)
        switch notifTypeV {
            
        case 1:
            self.noficationType = NotificationType.CheckIn
        case 2:
            self.noficationType = NotificationType.Alert
            
        default:
            self.noficationType = NotificationType.CheckIn
        }
        self.uploadCount  = aDecoder.decodeObjectForKey(Structures.Media.UploadCount) as! NSNumber
    }
    func encodeWithCoder(aCoder: NSCoder) {
        
        if let time = self.time{
            aCoder.encodeObject(time, forKey: Structures.Media.Time)
        }
        if let name = self.name{
            aCoder.encodeObject(name, forKey: Structures.Media.Name)
        }
        if let notificationID = self.notificationID{
            aCoder.encodeObject(notificationID, forKey: Structures.Media.NotificationID)
        }
        let noficationType = NSNumber(integer: self.noficationType.rawValue)
        aCoder.encodeObject(noficationType, forKey: Structures.Media.NoficationType)
        
        let mediaType = NSNumber(integer: self.mediaType.rawValue)
        aCoder.encodeObject(mediaType, forKey: Structures.Media.MediaType)
        
        if let uploadCount = self.uploadCount{
            aCoder.encodeObject(uploadCount, forKey: Structures.Media.UploadCount)
        }
    }
    class func dictFromMedia(media : Media) -> NSDictionary{
        var type : String = "0"
        var exten : String = "jpg"
        if  media.mediaType == .Image
        {
            type = "3"
            exten = "jpg"
        }
        else if  media.mediaType == .Video
        {
            type = "2"
            exten = "mp4"
        }
        else if  media.mediaType == .Audio
        {
            type = "1"
            exten = "caf"
        }
        
        var tbl_id : String = "1"
        if  media.noficationType == .Alert
        {
            tbl_id = "2"
        }
        else if media.noficationType == .CheckIn
        {
            tbl_id = "1"
        }
        var dictionary = NSDictionary()
        if let mediaData : NSData = CommonUnit.getDataFromEncryptedFile("/Media/", fileName: media.name, decryptionKey: Structures.Constant.appDelegate.prefrence.appEncryptionKey as String)
        {
            let strData : NSString = mediaData.base64EncodedString()
            dictionary = [
                Structures.Media.ForeignID :media.notificationID,
                Structures.Media.Extension :exten,
                Structures.Media.Type :type,
                Structures.Media.MediaFile :strData,
                Structures.Media.TableID : tbl_id,
            ]
        }else{
            let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
            CommonUnit.deleteSingleFile(media.name, fromDirectory: "/Media/")
            CommonUnit.removeFile(media.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
        }
        return dictionary
    }
    class func sendMediaObject(media : Media, completionClosure: (isSuccess : Bool) -> Void){
        if  Utility.isConnectedToNetwork()
        {
            var jsonResponse: NSURLResponse?
            var error: NSError?
            let dataValue: NSData?
            do {
                dataValue = try NSURLConnection.sendSynchronousRequest(WSClient.request(Media.dictFromMedia(media), api: Structures.WS.SendMedia), returningResponse: &jsonResponse)
            } catch let error1 as NSError {
                error = error1
                dataValue = nil
            }
            if dataValue != nil {
                if let strJson = NSString.init(data: dataValue!, encoding: NSUTF8StringEncoding)
                {
                    if let finalData : NSData = Utility.encryptJSONData(strJson){
                        if  let jsonResult: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(finalData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!{
                            if error != nil{
                                completionClosure(isSuccess: false)
                            }
                            if  jsonResult[Structures.Constant.Status] as! NSString == "1"{
                                Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                                completionClosure(isSuccess: true)
                            }else{
                                completionClosure(isSuccess: false)
                            }
                        } else {
                            completionClosure(isSuccess: false)
                            SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
                        }
                    }
                }
            }
            else {
                completionClosure(isSuccess: false)
                SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
            }
        }else{
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
        }
    }
    class func sendMediaObjectOnOtherThread(media : Media, completionClosure: (isSuccess : Bool) -> Void){
        NSURLConnection.sendAsynchronousRequest(WSClient.request(Media.dictFromMedia(media), api: Structures.WS.SendMedia), queue: NSOperationQueue(), completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if data != nil {
                
                if let strJson = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                {
                    if let finalData : NSData = Utility.encryptJSONData(strJson){
                        if let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(finalData, options: .MutableContainers)) as? NSDictionary {
                            if error != nil{
                                completionClosure(isSuccess: false)
                            }
                            if  jsonResult[Structures.Constant.Status] as! NSString == "1"{
                                Utility.updateUserHeaderToken(jsonResult.objectForKey(Structures.Constant.Headertoken) as! String)
                                completionClosure(isSuccess: true)
                            }else{
                                completionClosure(isSuccess: false)
                            }
                        } else {
                            completionClosure(isSuccess: false)
                            SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
                        }
                    }
                }
            }
            else {
                completionClosure(isSuccess: false)
                SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
            }
        })
    }
}