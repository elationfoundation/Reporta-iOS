//
//  Utility.swift
//  IWMF
//
//  This class used for common Validations, String to Date or Date to String, Encryption Decryption od data.
//
//

import Foundation
import UIKit
import CoreLocation

class Utility
{
    class func setFont()-> UIFont {
        var font = UIFont()
        if CommonUnit.isIphone4(){
            font = Structures.Constant.Roboto_Regular16!
        }else if CommonUnit.isIphone5(){
            font = Structures.Constant.Roboto_Regular16!
        }else if CommonUnit.isIphone6(){
            font = Structures.Constant.Roboto_Regular18!
        }else if CommonUnit.isIphone6plus(){
            font = Structures.Constant.Roboto_Regular20!
        }
        return font
    }
    class func setDetailFont()-> UIFont {
        var font = UIFont()
        if CommonUnit.isIphone4(){
            font = Structures.Constant.Roboto_Regular14!
        }else if CommonUnit.isIphone5(){
            font = Structures.Constant.Roboto_Regular14!
        }else if CommonUnit.isIphone6(){
            font = Structures.Constant.Roboto_Regular16!
        }else if CommonUnit.isIphone6plus(){
            font = Structures.Constant.Roboto_Regular18!
        }
        return font
    }
    class func setNavigationFont()-> UIFont {
        var font = UIFont()
        if CommonUnit.isIphone4(){
            font = Structures.Constant.Roboto_Regular16!
        }else if CommonUnit.isIphone5(){
            font = Structures.Constant.Roboto_Regular18!
        }else if CommonUnit.isIphone6(){
            font = Structures.Constant.Roboto_Regular21!
        }else if CommonUnit.isIphone6plus(){
            font = Structures.Constant.Roboto_Regular22!
        }
        return font
    }
    class func condenseWhitespace(string: String) -> String {
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!$0.characters.isEmpty})
        return components.joinWithSeparator(" ")
    }
    class func trimWhitespace(string: String) -> String
    {
        return string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    class func trimNumberSpecialChar(string: String) -> String
    {
        var strTemp = string as NSString
        strTemp = strTemp.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
        strTemp = strTemp.stringByTrimmingCharactersInSet(NSCharacterSet.symbolCharacterSet())
        strTemp = strTemp.stringByTrimmingCharactersInSet(NSCharacterSet.illegalCharacterSet())
        strTemp = strTemp.stringByTrimmingCharactersInSet(NSCharacterSet.punctuationCharacterSet())
        return strTemp as String
    }
    class func isValidUsername(testStr:String) -> Bool
    {
        let UsernameRegEx =  "^[\\p{L}a-z0-9_]{3,25}$"
        let UsernameTest :NSPredicate! = NSPredicate(format:"SELF MATCHES %@", UsernameRegEx)
        let result = UsernameTest.evaluateWithObject(testStr)
        return result
    }
    class func isValidPassword(strPassword:String, strUserName : String) -> Bool
    {
        if  strPassword.localizedCaseInsensitiveContainsString(strUserName){
            return false
        }
        
        var PasswordRegEx = ""
        if Structures.Constant.appDelegate.strLanguage == Structures.Constant.English{
            PasswordRegEx = "^(?=.*[\\p{L}0-9])(?=.*[A-Z])(?=.*[,~,!,@,#,$,%,^,&,*,(,),-,_,=,+,[,{,],},|,;,:,/,?].*$)(?=\\S+$).{8,25}$"
        }
        else{
            PasswordRegEx =  "^(?=.*[\\p{L}0-9])(?=.*[\\p{L}A-Z])(?=.*[,~,!,@,#,$,%,^,&,*,(,),-,_,=,+,[,{,],},|,;,:,/,?].*$)(?=\\S+$).{8,25}$"
        }
        
        
        let PasswordTest :NSPredicate! = NSPredicate(format:"SELF MATCHES %@", PasswordRegEx)
        let result = PasswordTest.evaluateWithObject(strPassword)
        return result
    }
    class func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx =  "^[\\p{L}_A-Za-z0-9-\\+]+(\\.[\\p{L}_A-Za-z0-9-]+)*@" + "[\\p{L}A-Za-z0-9-]+(\\.[\\p{L}A-Za-z0-9]+)*(\\.[\\p{L}A-Za-z]{2,})$"
        let emailTest :NSPredicate! = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    class func isValidPhone(testStr:String) -> Bool
    {
        let phoneRegEx =  "\\+?[0-9]{4,25}"
        let phoneTest :NSPredicate! = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        let result = phoneTest.evaluateWithObject(testStr)
        return result
    }
    class func setBorderToView(view : UIView, color : UIColor, radius : CGFloat, width : CGFloat){
        view.layer.cornerRadius = radius
        view.layer.borderColor = color.CGColor
        view.layer.borderWidth = width
        view.layer.masksToBounds = true
    }
    class func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor
    {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    class func convertFrequencyToHoursAndMinsFormatString(frequency : NSNumber) -> NSString{
        let freInt : Int = frequency.integerValue
        var hours : Int = 0
        var mins : Int = 0
        if  freInt > 59
        {
            hours = freInt/60
            mins = freInt - (hours * 60)
            if mins == 0
            {
                return  NSString(format: "\(hours) " + NSLocalizedString(Utility.getKey("hours"),comment:""))
            }
            return  NSString(format: "\(hours) " + NSLocalizedString(Utility.getKey("hours"),comment:"") + " - " + "\(mins) " + NSLocalizedString(Utility.getKey("mins"),comment:""))
        }else{
            mins = freInt
            return  NSString(format: "\(mins) " + NSLocalizedString(Utility.getKey("mins"),comment:""))
        }
    }
    class func convertFrequencyToHoursAndMinsFormat(frequency : NSNumber) -> (hours: Int, mins: Int){
        let freInt : Int = frequency.integerValue
        var hours : Int = 0
        var mins : Int = 0
        if  freInt > 60{
            hours = freInt/60
            mins = freInt - (hours * 60)
            return (hours, mins)
        }else{
            mins = freInt
            return (hours, mins)
        }
    }
    class func convertFrequencyToMins(hours : Int, minz : Int) -> Int{
        return (hours * 60) + minz
    }
    
    class func showAlertWithTitle(strTitle : String, strMessage : String,strButtonTitle : String, view : UIViewController){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alert = UIAlertController(title: strTitle, message:  strMessage , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: strButtonTitle , style: .Default, handler: nil))
            view.presentViewController(alert, animated: true, completion: nil)
        })
    }
    class func showLogOutAlert(strTitle : String, view : UIViewController) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let alertController = UIAlertController(title: strTitle , message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                self.forceSignOut()
            }))
            view.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    //MARK:- Remove all pending media
    class func removeAllPendingMedia(){
        var getMediaArray = [] as NSArray!
        let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
        getMediaArray = CommonUnit.getDataFroKey(KEY_PENDING_MEDIA, fromFile: userName)
        
        if (getMediaArray != nil){
            for media in getMediaArray{
                let tempMedia : Media = media as! Media
                CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                CommonUnit.removeFile(tempMedia.name, forKey: KEY_PENDING_MEDIA, fromFile: userName)
            }
        }
    }
    
    class func getUTCFromDate() -> NSString
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en")
        return dateFormatter.stringFromDate(NSDate())
    }
    class func setUTCFromDate() -> NSString
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(NSDate())
    }
    class func dateFromString(date : String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 : NSDate = dateFormatter.dateFromString(date)!
        return date1
    }
    class func getSystemTimeZoneFromDate(date : NSString) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let date1 : NSDate = dateFormatter.dateFromString(date as String)!
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter2.timeZone =  NSTimeZone.localTimeZone()
        dateFormatter2.locale = NSLocale(localeIdentifier: "en")
        let strDate : NSString = dateFormatter2.stringFromDate(date1)
        return  dateFormatter2.dateFromString(strDate as String)!
    }
    class func timeFromDate(date : NSDate) -> NSString{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "en")
        let time = dateFormatter.stringFromDate(date)
        return time
    }
    class func isNilOrEmpty(string: NSString?) -> Bool {
        switch string {
        case .Some(let nonNilString):
            return nonNilString.length == 0
        default:
            return true
        }
    }
    class func isNilOrEmpty<C: CollectionType>(collection: C?) -> Bool {
        switch collection {
        case .Some(let nonNilCollection): return nonNilCollection.count == 0
        default:                          return true
        }
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    class func cancelNotification(notification : NSString){
        for localNoti in UIApplication.sharedApplication().scheduledLocalNotifications!{
            let tempNotification = localNoti
            let dictUserInfo  : NSDictionary = tempNotification.userInfo!
            let strNotification : NSString = dictUserInfo[Structures.CheckIn.Status] as! NSString
            if  strNotification == notification{
                UIApplication.sharedApplication().cancelLocalNotification(tempNotification)
                break
            }
        }
    }
    //get key for NSLocalizedString
    class func getKey(Key:String) -> String
    {
        
       return  NSLocalizedString(Key, tableName: nil, bundle: Structures.Constant.languageBundle, value: "", comment: "")
    }
    //Custom Alert creation method
    class func createContainerView(detailText : NSString, titelText : NSString , isArabic : Bool) -> UIView
    {
        let width : CGFloat = (UIScreen.mainScreen().bounds.width) * 0.85 as CGFloat
        var height : CGFloat = 0
        var msgFontSize : CGFloat = 0
        if(CommonUnit.isIphone4() || CommonUnit.isIphone5()){
            height = 200
            msgFontSize = 14
        }
        else if(CommonUnit.isIphone6()){
            height = 180
            msgFontSize = 16
        }
        else if(CommonUnit.isIphone6plus()){
            height = 200
            msgFontSize = 18
        }
        
        let containerView : UIView = UIView(frame: CGRectMake(0, 0, width , height))
        
        let sampleTitle = UILabel(frame: CGRectMake(0, 3, width, 35))
        sampleTitle.text = titelText as String
        sampleTitle.font = UIFont.boldSystemFontOfSize(msgFontSize + 2)
        sampleTitle.backgroundColor = UIColor.clearColor()
        sampleTitle.textAlignment = NSTextAlignment.Center
        containerView.addSubview(sampleTitle)
        
        let sampleLabel = UILabel(frame: CGRectMake(10, sampleTitle.frame.size.height + 10 , width - 20 , containerView.frame.height-50))
        sampleLabel.backgroundColor = UIColor.clearColor()
        sampleLabel.numberOfLines = 0
        sampleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        if isArabic == true
        {
            sampleLabel.textAlignment = NSTextAlignment.Right
        }
        else
        {
            sampleLabel.textAlignment = NSTextAlignment.Left
        }
        sampleLabel.text = detailText as String
        sampleLabel.font = UIFont.systemFontOfSize(msgFontSize)
        
        let rect = (detailText as NSString).boundingRectWithSize(CGSizeMake(CGFloat((UIScreen.mainScreen().bounds.width) * 0.85), CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(msgFontSize)], context: nil)
        
        sampleLabel.frame = CGRectMake(sampleLabel.frame.origin.x, sampleLabel.frame.origin.y, sampleLabel.frame.size.width, rect.height)
        containerView.frame.size.height = ( sampleLabel.frame.size.height + sampleTitle.frame.size.height + 15 + 10)
        containerView.addSubview(sampleLabel)
        
        return containerView
    }
    class func findCountryFromCode(selectedCode : NSString) -> NSString {
        var seletLang = Structures.Constant.appDelegate.arrCountryList.mutableCopy() as! NSMutableArray
        var selectedText = NSString()
        let resultPredicate = NSPredicate(format: "Identity = %@", selectedCode)
        var searchResults : NSArray! = seletLang.filteredArrayUsingPredicate(resultPredicate) as NSArray
        if searchResults.count > 0 {
            selectedText = searchResults[0]["Title"] as! NSString!
        }
        seletLang = NSMutableArray()
        searchResults = NSArray()
        return selectedText
    }
    class func updateUserHeaderToken(strHeaderToken : NSString) {
//        print(strHeaderToken)
        var userDetail = User()
        userDetail = userDetail.getLoggedInUser()!
        userDetail.headertoken = strHeaderToken
        User.saveUserObject(userDetail)
    }
    class func setSelected(arrayList : NSMutableArray , selectedText : NSString) -> NSMutableArray
    {
        let resultPredicate = NSPredicate(format: "Title = %@", selectedText)
        var searchResults : NSArray! = arrayList.filteredArrayUsingPredicate(resultPredicate) as NSArray
        if searchResults.count > 0 {
            let dictTemp = (searchResults[0] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let index =  arrayList.indexOfObject(dictTemp)
            dictTemp["IsSelected"] = true
            arrayList.replaceObjectAtIndex(index, withObject: dictTemp)
        }
        searchResults = NSArray()
        return arrayList
    }
    
    class func forceSignOut(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            User.removeActiveUser()
            CheckIn.removeActiveCheckInObject()
            Structures.Constant.appDelegate.prefrence.UserAlredyLoggedIn = false
            Structures.Constant.appDelegate.prefrence.LoggedInUser = ""
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            navigationController.viewControllers = [rootViewController]
            Structures.Constant.appDelegate.window?.rootViewController = navigationController
            
        })
    }
    class func generateEncryptedString(strPlainText : String)-> String
    {
        let randomText32 : String = randomString(32)
        let randomText13 : String = randomString(13)
        let encryptedString : NSString = AES256StringEncryptionWithKey(randomText32, encryptedText: strPlainText)
        return appendRandomStringToString(randomText32, string: encryptedString, key2: randomText13) as String
    }
    class func getDecryptedString(strEncryptedText : NSString) -> String{
        if strEncryptedText.length > 45
        {
            let key : String = Utility.encryptionKeyFromString(strEncryptedText as String)
            let encryptedTextData : NSString = Utility.encryptedTextFromString(strEncryptedText)
            return Utility.AES256StringDecryptionWithKey(key, encryptedText: encryptedTextData) as String
        }else{
            return ""
        }
    }
    class func getUsersLastKnownLocation()-> CLLocation {
        var location : CLLocation!
        if Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation.count > 0 {
            location = CLLocation(latitude: (Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation[Structures.Constant.Latitude] as! NSNumber).doubleValue, longitude: (Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation[Structures.Constant.Longitude]as! NSNumber).doubleValue)
        }
        else{
            
            Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation[Structures.Constant.Latitude] = NSNumber(double: Structures.AppKeys.DefaultLatitude)
            Structures.Constant.appDelegate.prefrence.UsersLastKnownLocation[Structures.Constant.Longitude] = NSNumber(double: Structures.AppKeys.DefaultLongitude)
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            
            location = CLLocation(latitude: Structures.AppKeys.DefaultLatitude, longitude: Structures.AppKeys.DefaultLongitude)
        }
        return location
    }
    class func encryptJSONData(strJson : NSString)-> NSData {
        var finalData : NSData! = NSData()
        if strJson.length > 45
        {
            let key : String = Utility.encryptionKeyFromString(strJson)
            let encryptedTextData : NSString = Utility.encryptedTextFromString(strJson)
            if let encrypt : NSString = Utility.AES256StringDecryptionWithKey(key, encryptedText: encryptedTextData){
                finalData = NSData(bytes: encrypt.UTF8String, length: encrypt.length)
            }
        }
        return finalData
    }
    class func randomString(len : Int) -> String{
        let alphabet : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXZY0123456789abcdefghijklmnopqrstuvwxyz"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for(var i : Int = 0 ; i < len ; i++){
            randomString.appendFormat("%C", alphabet.characterAtIndex(Int(arc4random_uniform(UInt32(alphabet.length)))))
        }
        return randomString as String
    }
    //Append randomString to String
    class func appendRandomStringToString(key1 : NSString, string : NSString, key2 : NSString) -> NSString
    {
        return NSString(format: "%@%@%@", key1, string, key2)
    }
    //Remove String from String
    class func encryptedTextFromString(string : NSString) -> NSString{
        let str : NSString = string.substringFromIndex(32)
        return str.substringToIndex(str.length - 13)
    }
    class func encryptionKeyFromString(string : NSString) -> String{
        return string.substringToIndex(32)
    }
    //AES Encryption (encrypt key only)
    class func InternalEncryption(plainText : NSString)-> NSString{
        let key = Structures.Constant.appDelegate.prefrence.appEncryptionKey as String
        
        var cipherData : NSData!
        cipherData = plainText.dataUsingEncoding(NSUTF8StringEncoding)?.AES256EncryptWithKey(key)
        return cipherData.base64EncodedString()
    }
    //AES Decryption (decrypt key only)
    class func InternalDecryption(encryptedText : NSString)-> String{
        let key = Structures.Constant.appDelegate.prefrence.appEncryptionKey as String
        var cipherData : NSData!
        cipherData = encryptedText.base64DecodedData()
        return NSString(data: cipherData.AES256DecryptWithKey(key), encoding: NSUTF8StringEncoding)! as String
    }
    
    class func KeyDecryption(key : String, encryptedText : NSString)-> NSString{
        var cipherData : NSData!
        cipherData = encryptedText.base64DecodedData()
        return NSString(data: cipherData.AES256DecryptWithKey(key), encoding: NSUTF8StringEncoding)!
    }
    //AES String Encryption
    
    class func AES256StringEncryptionWithKey(key : String, encryptedText : NSString)-> NSString{
        //Encryption
        var cipherData : NSData!
        cipherData = encryptedText.dataUsingEncoding(NSUTF8StringEncoding)?.AES256EncryptWithKey(key)
        return cipherData.base64EncodedString()
    }
    class func AES256StringDecryptionWithKey(key : String, encryptedText : NSString)-> NSString{
        //Decryption
        var cipherData : NSData!
        var strDecryptedString : NSString = ""
        cipherData = encryptedText.base64DecodedData()
        strDecryptedString =  NSString(data: cipherData.AES256DecryptWithKey(key), encoding: NSUTF8StringEncoding)!
        return strDecryptedString
    }
}