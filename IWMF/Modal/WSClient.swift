//
//  WSClient.swift
//  IWMF
//
//  This class is used for Call Web Service.
//
//

import UIKit



enum WSRequestType : Int
{
    case Login = 1
    case Register
    case UpdateUser
    case ForgetPassword
    case SignOut
    case CheckUserNameEmail
    case Alert
    case CreateCheckIn
    case UpdateCheckIn
    case ConfirmCheckIn
    case CheckInStarted
    case CancelCheckIn
    case CloseCheckIn
    case LockSOS
    case UnlockSOS
    case GetContactList
    case DeleteContactList
    case CreateContactList
    case SetDefaultContactList
    case GetAllContacts
    case CreateContactCircle
    case SendMailWithMedia
    case AddMedia
    case UpdateContactList
    case ResetPassword
}

protocol WSClientDelegate
{
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    func WSResponseEoor(error:NSError, ReqType type:WSRequestType)
}

class WSClient: NSObject {
    var wsType : WSRequestType!
    var delegate : WSClientDelegate!
    let baseURL : String! = String(format: "%@", Structures.WS.BaseURL + Structures.WS.ApiVersion)
    func PostRequestFor(dic : NSMutableDictionary , API:String)
    {
        if  Utility.isConnectedToNetwork()
        {
            
            let jsonData:NSData!
            do {
                jsonData = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            } catch _ as NSError {
                jsonData = nil
            }
            var JSONString : NSString! = NSString(bytes: jsonData.bytes, length: jsonData.length, encoding: NSUTF8StringEncoding)
            
            JSONString = JSONString.urlEncode()
            
            let randomText32 : String = Utility.randomString(32)
            let randomText13 : String = Utility.randomString(13)
            let encryptedString : NSString = Utility.AES256StringEncryptionWithKey(randomText32, encryptedText: JSONString)
            var encryptedJSONString : NSString = Utility.appendRandomStringToString(randomText32, string: encryptedString, key2: randomText13)
            encryptedJSONString = encryptedJSONString.urlEncode()
            
            var urlstr : String! = String(format: "%@%@", baseURL,API)
            
            let strindData : NSString! = NSString(format: "bulkdata=%@", encryptedJSONString)
            let requestData : NSData! = NSData(bytes: strindData.UTF8String, length: strindData.length)
            urlstr = urlstr.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url: NSURL! = NSURL(string: urlstr)
            
            var headertoken : String = "0"
            
            let tokenString = Structures.Constant.appDelegate.prefrence.DeviceToken
            let TokenRandomText32 : String = Utility.randomString(32)
            let TokenRandomText13 : String = Utility.randomString(13)
            let encryptedtokenString : NSString = Utility.AES256StringEncryptionWithKey(TokenRandomText32, encryptedText: tokenString)
            let finalEncryptedtokenString : NSString = Utility.appendRandomStringToString(TokenRandomText32, string: encryptedtokenString, key2: TokenRandomText13)
            
            let language_code : String = Structures.Constant.appDelegate.prefrence.LanguageCode as String
            let language_codeRandomText32 : String = Utility.randomString(32)
            let language_codeRandomText13 : String = Utility.randomString(13)
            let encryptedLanguage_CodeString : NSString = Utility.AES256StringEncryptionWithKey(language_codeRandomText32, encryptedText: language_code)
            let finalEncryptedLanguage_CodeString : NSString = Utility.appendRandomStringToString(language_codeRandomText32, string: encryptedLanguage_CodeString, key2: language_codeRandomText13)
            
            //Added for ignore logIn Screen when "userDetail.headertoken" not available
            if !(API as NSString).isEqualToString("user/login") && !(API as NSString).isEqualToString("user/checkusernameemail") && !(API as NSString).isEqualToString("user/forgotpassword") && !(API as NSString).isEqualToString("user/createuser")
            {
                var userDetail = User()
                if userDetail.getLoggedInUser() != nil{
                    userDetail = userDetail.getLoggedInUser()!
                    if userDetail.headertoken != nil{
                        headertoken = userDetail.headertoken as String
                    }
                }
            }
            //added for add headertoken in "user/createuser" WebService because its used in Update Profile.
            if let iscreateuser = dic[Structures.User.IsCreateUser] as? NSString
            {
                if iscreateuser.isEqualToString("0")
                {
                    var userDetail = User()
                    if userDetail.getLoggedInUser() != nil{
                        userDetail = userDetail.getLoggedInUser()!
                        if userDetail.headertoken != nil{
                            headertoken = userDetail.headertoken as String
                        }
                    }
                }
            }
            let  theRequest : NSMutableURLRequest! = NSMutableURLRequest(URL: url)
            theRequest.setValue(headertoken, forHTTPHeaderField: Structures.Constant.Headertoken)
            theRequest.setValue(finalEncryptedtokenString as String, forHTTPHeaderField: Structures.User.User_DeviceToken)
            theRequest.setValue(finalEncryptedLanguage_CodeString as String, forHTTPHeaderField: Structures.User.User_LanguageCode)
            theRequest.HTTPMethod = "POST"
            theRequest.HTTPBody = requestData
            
            self.ProcessRequest(theRequest)
        }
        else
        {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""))
        }
    }
    //Add Contact
    func createSingleContact(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.GetContactList
        self.PostRequestFor(dic, API: "contact/createsinglecontact")
    }
    //new Fo Media
    func sendMailWithMedia(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.SendMailWithMedia
        self.PostRequestFor(dic, API: "checkin/sendmailwithmedia")
    }
    //New 1 for create contact circle
    func createContactCircletWithData(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.CreateContactCircle
        self.PostRequestFor(dic, API: "contact/createcontactcircle")
    }
    func getContactListWithData(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.GetContactList
        self.PostRequestFor(dic, API: "contact/allcirclewithcontacts")
    }
    func allcirclewithstatusWithData(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.GetContactList
        self.PostRequestFor(dic, API: "contact/allcirclewithstatus")
    }
    //Get all Existing contact
    func allExistingContacts(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.GetContactList
        self.PostRequestFor(dic, API: "contact/allexistingcontacts")
    }
    //Update Contact list for existing contact
    func updateContactList(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.UpdateContactList
        self.PostRequestFor(dic, API: "contact/updatecontactlist")
    }
    //Get All contact
    func getAllContacts(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.GetAllContacts
        self.PostRequestFor(dic, API: "contact/allcontacts")
    }
    func setDefaultContactList(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.SetDefaultContactList
        self.PostRequestFor(dic, API: "contact/changedefaultstatus")
    }
    func deleteContactCircleWithData(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.DeleteContactList
        self.PostRequestFor(dic, API: "contact/deletecircle")
    }
    func deleteContactWithData(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.DeleteContactList
        self.PostRequestFor(dic, API: "contact/deletecontact")
    }
    func ResetPassword(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.ResetPassword
        self.PostRequestFor(dic, API: "user/resetpassword")
    }
    func userLogin(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.Login
        self.PostRequestFor(dic, API: Structures.WS.LogInUser)
    }
    func registerUser(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.Register
        self.PostRequestFor(dic, API: Structures.WS.CreateUser)
    }
    func updateUser(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.UpdateUser
        self.PostRequestFor(dic, API: Structures.WS.CreateUser)
    }
    func forgetPassword(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.ForgetPassword
        self.PostRequestFor(dic, API: Structures.WS.ForgotPassword)
    }
    func signOut(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.SignOut
        self.PostRequestFor(dic, API: Structures.WS.SignOut)
    }
    func CheckUserNameEmail(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.CheckUserNameEmail
        self.PostRequestFor(dic, API: Structures.WS.CheckUserNameEmail)
    }
    func SendAlert(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.Alert
        self.PostRequestFor(dic, API: Structures.WS.SendAlert)
    }
    func CreateCheckIn(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.CreateCheckIn
        self.PostRequestFor(dic, API: Structures.WS.RegisterCheckIN)
    }
    func UpdateCheckIn(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.UpdateCheckIn
        self.PostRequestFor(dic, API: Structures.WS.RegisterCheckIN)
    }
    
    func CheckInStarted(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.CheckInStarted
        self.PostRequestFor(dic, API: Structures.WS.UpdateStatus)
    }
    func ConfirmCheckIn(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.ConfirmCheckIn
        self.PostRequestFor(dic, API: Structures.WS.UpdateStatus)
    }
    func CancelCheckIn(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.CancelCheckIn
        self.PostRequestFor(dic, API: Structures.WS.UpdateStatus)
    }
    func CloseCheckIn(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.CloseCheckIn
        self.PostRequestFor(dic, API: Structures.WS.UpdateStatus)
    }
    func UnlockSOS(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.UnlockSOS
        self.PostRequestFor(dic, API: Structures.WS.UnlockSOS)
    }
    func LockSOS(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.LockSOS
        self.PostRequestFor(dic, API: Structures.WS.SOS)
    }
    func AddMedia(dic : NSMutableDictionary)
    {
        wsType = WSRequestType.AddMedia
        self.PostRequestFor(dic, API: Structures.WS.SendMedia)
    }
    func ProcessRequest(request : NSMutableURLRequest)
    {
        let operation : AFHTTPRequestOperation! =  AFHTTPRequestOperation(request: request)
        operation.setCompletionBlockWithSuccess({ (operation :AFHTTPRequestOperation! , responseObject) -> Void in
            
            if let strJson : NSString! = NSString(data:  responseObject as! NSData, encoding: NSUTF8StringEncoding){
                if let finalData : NSData = Utility.encryptJSONData(strJson!){
                    let str : NSString! = NSString(data:  finalData, encoding: NSUTF8StringEncoding)
                    if  str.rangeOfString("{").location == NSNotFound
                    {
                        self.delegate.WSResponse(str, ReqType: self.wsType)
                    }
                    else{
                        
                        self.delegate.WSResponse(finalData, ReqType: self.wsType)
                    }
                }
            }
            }, failure: { (operation :AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.delegate.WSResponseEoor(error, ReqType: self.wsType)
        })
        operation.start()
    }
    
    class func request (dict : NSDictionary, api : NSString) -> NSMutableURLRequest {
        
        let jsonData:NSData!
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        } catch _ as NSError {
            jsonData = nil
        }
        var JSONString : NSString! = NSString(bytes: jsonData.bytes, length: jsonData.length, encoding: NSUTF8StringEncoding)
        JSONString = JSONString.urlEncode()
        
        let randomText32 : String = Utility.randomString(32)
        let randomText13 : String = Utility.randomString(13)
        let encryptedString : NSString = Utility.AES256StringEncryptionWithKey(randomText32, encryptedText: JSONString)
        var encryptedJSONString : NSString = Utility.appendRandomStringToString(randomText32, string: encryptedString, key2: randomText13)
        encryptedJSONString = encryptedJSONString.urlEncode()
        
        var urlstr : String! = String(format: "%@%@", Structures.WS.BaseURL+Structures.WS.ApiVersion,api)
        let strindData : NSString! = NSString(format: "bulkdata=%@", encryptedJSONString)
        let requestData : NSData! = NSData(bytes: strindData.UTF8String, length: strindData.length)
        urlstr = urlstr.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: urlstr)
        
        var headertoken : String = "0"
        
        let tokenString = Structures.Constant.appDelegate.prefrence.DeviceToken
        let TokenRandomText32 : String = Utility.randomString(32)
        let TokenRandomText13 : String = Utility.randomString(13)
        let encryptedtokenString : NSString = Utility.AES256StringEncryptionWithKey(TokenRandomText32, encryptedText: tokenString)
        let finalEncryptedtokenString : NSString = Utility.appendRandomStringToString(TokenRandomText32, string: encryptedtokenString, key2: TokenRandomText13)
        
        
        let language_code : String = Structures.Constant.appDelegate.prefrence.LanguageCode as String
        let language_codeRandomText32 : String = Utility.randomString(32)
        let language_codeRandomText13 : String = Utility.randomString(13)
        let encryptedLanguage_CodeString : NSString = Utility.AES256StringEncryptionWithKey(language_codeRandomText32, encryptedText: language_code)
        let finalEncryptedLanguage_CodeString : NSString = Utility.appendRandomStringToString(language_codeRandomText32, string: encryptedLanguage_CodeString, key2: language_codeRandomText13)
        
        //Added for ignore logIn Screen when "userDetail.headertoken" not available
        if !api.isEqualToString("user/login") && !api.isEqualToString("user/checkusernameemail") && !api.isEqualToString("user/forgotpassword") && !api.isEqualToString("user/createuser")
        {
            var userDetail = User()
            if userDetail.getLoggedInUser() != nil{
                userDetail = userDetail.getLoggedInUser()!
                if userDetail.headertoken != nil{
                    headertoken = userDetail.headertoken as String
                }
            }
        }
        //added for add headertoken in "user/createuser" WebService because its used in Update Profile.
        if let iscreateuser = dict[Structures.User.IsCreateUser] as? NSString
        {
            if iscreateuser .isEqualToString("0")
            {
                var userDetail = User()
                if userDetail.getLoggedInUser() != nil{
                    userDetail = userDetail.getLoggedInUser()!
                    if userDetail.headertoken != nil{
                        headertoken = userDetail.headertoken as String
                    }
                }
            }
        }
        
        let  theRequest : NSMutableURLRequest! = NSMutableURLRequest(URL: url!)
        theRequest.setValue(headertoken, forHTTPHeaderField: Structures.Constant.Headertoken)
        theRequest.setValue(finalEncryptedtokenString as String, forHTTPHeaderField: Structures.User.User_DeviceToken)
        theRequest.setValue(finalEncryptedLanguage_CodeString as String, forHTTPHeaderField: Structures.User.User_LanguageCode)
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = requestData
        return theRequest
    }
    
}
