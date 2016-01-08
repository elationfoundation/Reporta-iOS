//
//  Struct.swift
//  IWMF
//
//  Common keys which is used in Web Service name, User's detail, SOS, Alert, Check-in, Check-in Status, App Keys, TableviewCelIdentifires, Media.
//
//

import Foundation

class Structures
{
    struct WS
    {
        //API BASE URL
        static let BaseURL = ""
        
        //API Version Name
        static let ApiVersion = ""
        static let AboutReporta = "aboutreporta/"
        static let TermsAndConditions = "termsandconditions/"
        static let LogInUser = "user/login"
        static let RegisterCheckIN = "checkin/createcheckin"
        static let SendAlert = "checkin/sendalert"
        static let SendMedia = "media/addmedia"
        static let UpdateStatus = "checkin/updatecheckinstatus"
        static let SOS = "checkin/sos"
        static let UnlockSOS = "checkin/unlockapp"
        static let CreateUser = "user/createuser"
        static let ForgotPassword = "user/forgotpassword"
        static let SignOut = "user/signout"
        static let CheckUserNameEmail = "user/checkusernameemail"
        static let TestMedia = "media/testupload"
    }
    struct User
    {
        static let UserName = "UserName"
        static let SelectedLanguage = "SelectedLanguage"
        static let LanguageCode = "LanguageCode"
        static let Language = "Language"
        static let Email = "Email"
        static let FirstName = "FirstName"
        static let LastName = "LastName"
        static let Phone = "Phone"
        static let JobTitle = "JobTitle"
        static let Affiliation = "Affiliation"
        static let IsFreeLancer = "IsFreeLancer"
        static let Origin = "Origin"
        static let Password = "Password"
        static let Working = "Working"
        static let SendMail = "SendMail"
        static let SendConfirmationMail = "SendConfirmationMail"
        static let StatusValue = "StatusValue"
        static let Gender = "Gender"
        static let GenderType = "GenderType"
        static let LockStatus = "LockStatus"
        static let CheckInID = "CheckInID"
        static let HeaderToken = "HeaderToken"
        static let AppEncryptionKey = "AppEncryptionKey"
        static let UserEmail = "email"
        static let User_LanguageCode = "language_code"
        static let User_Name = "username"
        static let User_Password = "password"
        static let User_DeviceToken = "devicetoken"
        static let User_DeviceType = "devicetype"
        static let ForceLogin = "forcelogin"
        static let User_Language = "language"
        static let User_FirstName = "firstname"
        static let User_LastName = "lastname"
        static let User_Phone = "phone"
        static let CountryOrigin = "origin_country"
        static let CountryWorking = "working_country"
        static let AffiliationID = "affiliation_id"
        static let Freelancer = "freelancer"
        static let User_JobTitle = "jobtitle"
        static let User_SendMail = "sendmail"
        static let SendUpdateFromReporta = "send_update_repota_email"
        static let CircleType = "circle"
        static let User_Gender = "gender"
        static let User_GenderType = "gender_type"
        static let IsCreateUser = "iscreateuser"
        static let User_LockStatus = "lockstatus"
        
        
    }
    struct SOS{
        static let SosID = "SosID"
        static let OTP = "otp"
        static let SOS_ID = "sos_id"
    }
    struct CheckIn{
        static let CheckInID = "CheckInID"
        static let CheckIn_ID = "checkin_id"
        static let Description = "CheckInDescription"
        static let Address = "CheckInAddress"
        static let Latitude = "CheckInLatitude"
        static let Longitude = "CheckInLongitude"
        static let StartTime = "CheckInStartTime"
        static let EndTime = "CheckInEndTime"
        static let SMSMessage = "CheckInSMSMessage"
        static let SocialMessage = "CheckInSocialMessage"
        static let EmailMessage = "CheckInEmailMessage"
        static let ReceivePrompt = "CheckInReceivePromt"
        static let Frequency = "CheckInFrequency"
        static let Confirmation = "CheckInConfirmation"
        static let Custom = "CheckInFrequencyCustom"
        static let Status = "CheckInStatus"
        static let ContactLists = "CheckInContactLists"
        static let CheckInMedia = "CheckInMediaArray"
        static let FbToken  = "FbToken"
        static let TwitterToken = "TwitterToken"
        static let TwitterTokenSecret  = "TwitterTokenSecret"
        static let CheckInStartTime  = "starttime"
        static let MessageSMS  = "message_sms"
        static let MessageSocial  = "message_social"
        static let MessageEmail  = "message_email"
        static let Receive_Prompt  = "receiveprompt"
        static let CheckIn_Frequency  = "frequency"
        static let CheckInConfirmedCount  = "checkinconfirmedcount"
        static let CheckInEndTime  = "endtime"
        
    }
    struct CheckInStatus{
        static let StartReminder = "StartReminder"
        static let CheckInClosed = "CheckInClosed"
        static let Confirmation = "Confirmation"
        static let Start = "Start"
        static let CloseReminder = "CloseReminder"
        static let Reminder = "Reminder"
        static let MissedCheckIn = "MissedCheckIn"
    }
    struct AppKeys{
        static let LoggedInUser = "LoggedInUser"
        static let ActiveCheckInID = "ActiveCheckInID"
        static let ActiveCheckIn = "ActiveCheckIn"
        static let Active_CheckIn = "activecheckin"
        static let ActiveSosID = "ActiveSosID"
        static let ActiveSos = "ActiveSos"
        static let GooglePlaceAPIKey = ""
        static let FacebookAppId = ""
        static let TwitterConsumerSecret = ""
        static let TwitterConsumerKey = ""
        static let NoLocations = "Sorry, No Locations Available"
        static let LookingLocations = "Looking for Near By Places"
        static let ApplicationState = "ApplicationState"
        static let DefaultLatitude : Double = 40.689152
        static let DefaultLongitude : Double = -74.044462
        static var Spanish = "spanish"
        static var French = "french"
        static var Turkish = "turkish"
        static var Arabic = "arabic"
        static var Hebrew = "hebrew"
        static var English = "english"
        static var ID = "id"
        static var LastStatusTime = "laststatustime"
        
    }
    struct Constant {
        static let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        static var LocationUpdate = "LocationUpdateNotification"
        static var Roboto_BoldCondensed = "Roboto-BoldCondensed"
        static var Roboto_Regular = "Roboto-Regular"
        static let English = "EN"
        static let Spanish = "ES"
        static let Arabic = "AR"
        static let French = "FR"
        static let Hebrew = "IW"
        static let Turkish = "TR";
        static var languageBundle : NSBundle!
        static var Roboto_Regular12 = UIFont(name: Roboto_Regular, size: 12)
        static var Roboto_Regular14 = UIFont(name: Roboto_Regular, size: 14)
        static var Roboto_Regular15 = UIFont(name: Roboto_Regular, size: 15)
        static var Roboto_Regular16 = UIFont(name: Roboto_Regular, size: 16)
        static var Roboto_Regular18 = UIFont(name: Roboto_Regular, size: 18)
        static var Roboto_Regular19 = UIFont(name: Roboto_Regular, size: 19)
        static var Roboto_Regular20 = UIFont(name: Roboto_Regular, size: 20)
        static var Roboto_Regular21 = UIFont(name: Roboto_Regular, size: 21)
        static var Roboto_Regular22 = UIFont(name: Roboto_Regular, size: 22)
        static var Roboto_Regular34 = UIFont(name: Roboto_Regular, size: 34)
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let TimezoneID = "timezone_id"
        static let Time = "time"
        static let Status = "status"
        static let Headertoken = "headertoken"
        static let ContactListID = "contactlist_id"
        static let ListID = "list_id"
        static let DefaultStatus = "defaultstatus"
        static let ListName = "listname"
        static let Contacts = "contacts"
        static let Message = "message"
        
    }
    struct TableViewCellIdentifiers{
        static let TitleTableViewCellIdentifier = "TitleTableViewCellIdentifier"
        static let DetailTableViewCellIdentifier = "DetailTableViewCellIdentifier"
        static let CheckInDetailIdentifier = "CheckInDetailTableviewCellIdentifier"
        static let CheckInLocationTableViewCellIdentifier = "CheckInLocationTableViewCellIdentifier"
        static let CheckInFooterCellIdentifier = "CheckInFooterCellIdentifier"
        static let DoneFooterCellIdentifier = "DoneFooterCellIdentifier"
        static let AlertMessageCellIdentifier = "CheckInAlertMessageCellIdentifier"
        static let LocationListingCellIdentifier = "LocationListingCellIdentifier"
        static let ConfirmedCICellIdentifier = "ConfirmedCICellIdentifier"
        static let SendAlertIdentifier = "SendAlertIdentifier"
        static let CheckInDoneCellIdentifier = "CheckInDoneCellIdentifier"
        static let SituationTitleCellIdentifier = "SituationTitleCellIdentifier"
        static let FreelancerCellIndentifier = "FreelancerCellIndentifier"
        static let PersonalDetailCellIdentifier = "PersonalDetailCellIdentifier"
        static let nextFooterCellIdentifier = "nextFooterCellIdentifier"
        static let CreateNewUserTableViewCellIdentifer = "CreateNewUserTableViewCellIdentifer"
        static let TitleTableViewCellIdentifier2 = "TitleTableViewCellIdentifier2"
        static let ARPersonalDetailsTableViewCellIndetifier = "ARPersonalDetailsTableViewCellIndetifier"
        static let ARDetailTableViewCellIdentifier =  "ARDetailTableViewCellIdentifier"
        static let ARTitleTableViewCellIdentifier = "ARTitleTableViewCellIdentifier"
        static let ARSituationTitleCellIdentifier = "ARSituationTitleCellIdentifier"
        static let ARLocationListingCellIdentifier = "ARLocationListingCellIdentifier"
        static let ARFreelancerTableViewCellIdentifier = "ARFreelancerTableViewCellIdentifier"
        static let HelpTextViewCellIdentifier = "HelpTextViewCellIdentifier"
        static let EnableFriendUnlockCellIdentifier = "EnableFriendUnlockCell"
    }
    struct Media {
        static let Time = "Time"
        static let Name = "Name"
        static let NotificationID = "NotificationID"
        static let MediaType = "MediaType"
        static let NoficationType = "NoficationType"
        static let Latitude = "Latitude"
        static let Longitude = "Longitude"
        static let UploadCount = "UploadCount"
        static let ForeignID = "foreign_id"
        static let Extension = "extension"
        static let Type = "mediatype"
        static let MediaFile = "mediafile"
        static let TableID = "table_id"
        
        
    }
    struct Alert {
        static let AlertMedia = "AlertMedia"
        static let AlertID = "alert_id"
        static let Description = "description"
        static let Situation = "situation"
        static let Location = "location"
        static let SafetyCheckin = "safetycheckin"
        static let MediaCount = "mediacount"
        static let ContactList = "contactlist"
        static let FB_Token = "fb_token"
        static let Twitter_Token = "twitter_token"
        static let Twitter_Token_Secret = "twitter_token_secret"
        
    }
    
}