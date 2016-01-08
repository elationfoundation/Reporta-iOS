//
//  CheckInViewContrller.swift
//  IWMF
//
// This class is used for create user interface of Check-in and implemented functionality of Send Check-in.
//
//

import Foundation
import UIKit
import CoreLocation

enum CheckInType : Int{
    case NewCheckIn = 0
    case ExistingCheckIN = 1
}

class CheckInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckInDescriptionProtocol, LocationDetailProtocol, ChooseFrequencyProtocol, CIAlertMessageProtocol, SetTimeProtocol, CheckInFooterButtonsProtocol , CheckInContactProtocol, FooterDoneButtonProtol,MediaDetailProtocol, CheckInFooterProtocol, CheckInSocialProtocol, WSClientDelegate,CheckInModalProtocol
{
    @IBOutlet weak var checkInLable: UILabel!
    var descriptionScreen : CheckInDescriptionViewController!
    var locationDetailScreen : LocationViewController!
    var frequencyScreen : CheckInFrequencyViewController!
    var user = User()
    var isIbuttonOpen : Bool!
    var devide : CGFloat!
    @IBOutlet weak var tblView: UITableView!
    var CheckInArray: NSMutableArray!
    var checkIn : CheckIn!
    var checkInpassword : NSString!
    var checkInType : CheckInType!
    var circlePrivate : Circle!
    var circlePublic : Circle!
    var arrPublicContacts : NSMutableArray = NSMutableArray()
    var arrPrivateCircle : NSMutableArray = NSMutableArray()
    var isAnyChangeInCheckIn : Bool!
    //  MARK:- Constraint Property
    @IBOutlet weak var verticleSpaceView: NSLayoutConstraint!
    @IBOutlet weak var textViewHeigth: NSLayoutConstraint!
    //  MARK:- View Property
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkInView: UIView!
    @IBOutlet var btnInfo : UIButton!
    @IBOutlet var btnHome : UIButton!
    var strFbToken, strTwToken, strTwTokenSecret : NSString!
    //    MARK :- animation methods
    
    
    override func viewDidLoad()
    {
        
        self.user = self.user.getLoggedInUser()!
        textView.selectable = false
        devide = 1
        strFbToken = ""
        strTwToken = ""
        strTwTokenSecret = ""
        isAnyChangeInCheckIn = false
        
        Structures.Constant.appDelegate.prefrence.isFacebookSelected = false
        Structures.Constant.appDelegate.prefrence.isTwitterSelected = false
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        
        Structures.Constant.appDelegate.commonLocation.getUserCurrentLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate:", name:Structures.Constant.LocationUpdate, object: nil)
        
        self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
        self.checkInView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)
        
        self.textView.editable = false
        
        self.checkInLable.font =  Utility.setNavigationFont()
        self.checkInLable.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
        self.CheckInArray = NSMutableArray()
        var checkInTemp : NSMutableArray!
        
        if let path = NSBundle.mainBundle().pathForResource("CheckIn", ofType: "plist") {
            checkInTemp = NSMutableArray(contentsOfFile: path)
            let arrTemp : NSMutableArray = NSMutableArray(array: checkInTemp)
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        let strOptionTitle = innerDict["OptionTitle"] as! String!
                        if strOptionTitle != nil
                        {
                            if strOptionTitle == "Add"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("add"),comment:"")
                            }
                            else if strOptionTitle == "Choose your location"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("choose_your_location"),comment:"")
                            }
                            else if strOptionTitle == "Choose options"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("choose_options"),comment:"")
                            }
                            else if strOptionTitle == "Optional"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("optional"),comment:"")
                            }
                            else if strOptionTitle == "Edit"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                            }
                        }
                        
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        checkInTemp.replaceObjectAtIndex(index, withObject: innerDict)
                        
                    }
                }
            }
        }
        if CheckIn.isAnyCheckInActive()
        {
            self.checkIn = CheckIn.getCurrentCheckInObject()
            self.checkInType = .ExistingCheckIN
            
            if checkIn.contactLists.count > 0{
                
                for (var i = 0 ; i < checkIn.contactLists.count ; i++)
                {
                    if checkIn.contactLists.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "1"
                    {
                        arrPrivateCircle.addObject(checkIn.contactLists.objectAtIndex(i))
                    }
                    if checkIn.contactLists.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "2"
                    {
                        arrPublicContacts.addObject(checkIn.contactLists.objectAtIndex(i))
                    }
                }
                
            }else{
                getContactListWithData()
            }
            self.checkIn.mediaArray = [Media]()
        }else{
            
            
            getContactListWithData()
            
            self.checkIn = CheckIn()
            
            Structures.Constant.appDelegate.prefrence.endTime = ""
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            self.checkInType = .NewCheckIn
        }
        
        if  self.checkInType == .ExistingCheckIN
        {
            var cell: CheckInDoneFooterCell? = tblView.dequeueReusableCellWithIdentifier("CheckInDoneFooterCell") as? CheckInDoneFooterCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("CheckInDoneFooterCell", owner: self, options: nil)
                cell = arr[0] as? CheckInDoneFooterCell
            }
            cell?.btnDone.setTitle(NSLocalizedString(Utility.getKey("save"),comment:""), forState: .Normal)
            cell?.btnConfirmCheckIN.setTitle(NSLocalizedString(Utility.getKey("confirm_now"),comment:""), forState: .Normal)
            cell?.btnCancelCheckIN.setTitle(NSLocalizedString(Utility.getKey("closenow"),comment:""), forState: .Normal)
            if  self.checkIn.status.rawValue == 0
            {
                cell?.btnConfirmCheckIN.setTitle(NSLocalizedString(Utility.getKey("start_now"),comment:""), forState: .Normal)
            }
            cell?.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 204)
            tblView.tableFooterView = cell
            self.automaticallyAdjustsScrollViewInsets = false
            cell?.delegate = self
            self.tblView.reloadData()
        }
        
        
        for (_, element) in checkInTemp.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == "Description"{
                    innerDict["Value"] = self.checkIn.checkInDescription!
                }
                if iden == "Location"{
                    innerDict["Value"] = self.checkIn.address!
                }
                if iden == "SelectedContactsList"{
                    if arrPublicContacts.count > 0{
                        for (index, element) in arrPublicContacts.enumerate(){
                            let dict = NSMutableDictionary(dictionary: innerDict)
                            if let conList = element as? ContactList{
                                dict["Title"] = conList.contactListName
                                dict["ContactListID"] = conList.contactListID as Int
                                if index == arrPublicContacts.count-1{
                                    dict["Level"] = "Bottom"
                                }else{
                                    dict["Level"] = "Middle"
                                }
                            }
                            self.CheckInArray.addObject(dict)
                        }
                    }
                    continue
                }
                self.CheckInArray.addObject(innerDict)
            }
        }
        formatCheckInViewController()
        self.tblView.registerNib(UINib(nibName: "CheckInDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.CheckInDetailIdentifier)
        self.tblView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "CheckInFooterTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.CheckInFooterCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "LocationListingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.LocationListingCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "ConfirmedCICell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ConfirmedCICellIdentifier)
        self.tblView.registerNib(UINib(nibName: "DoneFooterCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DoneFooterCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "CheckInDoneFooterCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.CheckInDoneCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
        self.tblView.registerNib(UINib(nibName: "ARLocationListingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        tblView.rowHeight = UITableViewAutomaticDimension
        
        
        
        super.viewDidLoad()
        updateStatusText()
    }
    func formatCheckInViewController()
    {
        if  self.checkInType == .NewCheckIn{
            self.CheckInArray.removeObjectAtIndex(0)
            self.CheckInArray.removeObjectAtIndex(0)
        }else{
            self.CheckInArray.removeObjectAtIndex(self.CheckInArray.count-1)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool)
    {
        self.checkInView.hidden = true
        self.setUpUpperInfoView()
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnHome.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Right
        }
        else
        {
            btnHome.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Left
        }
        isIbuttonOpen = false
        super.viewWillAppear(animated)
        if Structures.Constant.appDelegate.window?.rootViewController is UINavigationController
        {
            Structures.Constant.appDelegate.hideSOSButton()
        }
        else
        {
            Structures.Constant.appDelegate.showSOSButton()
        }
        if  self.checkInType == .ExistingCheckIN
        {
            
            self.tblView.reloadData()
        }
    }
    @IBAction func btnHomePressed(sender: AnyObject) {
        if Structures.Constant.appDelegate.isArabic == true
        {
            setIBtnView()
        }
        else
        {
            backToPreviousScreen()
        }
    }
    func backToPreviousScreen()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnInfoPressed(sender: AnyObject) {
        if Structures.Constant.appDelegate.isArabic == true
        {
            backToPreviousScreen()
        }
        else
        {
            setIBtnView()
        }
    }
    @IBAction func arrowButton(sender: AnyObject)
    {
        setIBtnView()
    }
    
    func setIBtnView(){
        if isIbuttonOpen == false
        {
            self.view.bringSubviewToFront(self.checkInView)
            self.checkInView.hidden = false
            isIbuttonOpen = true
            textView.scrollRangeToVisible(NSRange(location:0, length:0))
            UIView.animateWithDuration(0.80, delay: 0.1, options: .CurveEaseOut , animations:
                {
                    self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                    self.checkInView.frame.origin.y += (UIScreen.mainScreen().bounds.size.height)
                }, completion:
                {
                    finished in
            })
        }
        else
        {
            isIbuttonOpen = false
            UIView.animateWithDuration(0.80, delay: 0.1, options:  .CurveEaseInOut , animations:
                {
                    self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                    self.checkInView.frame.origin.y -= (UIScreen.mainScreen().bounds.size.height)
                }, completion:
                {
                    finished in
                    self.setUpUpperInfoView()
                    self.checkInView.hidden = true
                    self.view.bringSubviewToFront(self.tblView)
            })
        }
    }
    func setUpUpperInfoView()
    {
        self.textView.text = NSLocalizedString(Utility.getKey("Check In - i button"),comment:"")
    }
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Structures.Constant.LocationUpdate, object: nil)
    }
    func locationUpdate(notification: NSNotification){
        let location = notification.object as! CLLocation!
        if self.checkInType == .NewCheckIn
        {
            self.checkIn.latitude = NSNumber(double: location.coordinate.latitude)
            self.checkIn.longitude = NSNumber(double: location.coordinate.longitude)
        }
    }
    func updateStatusText(){
        if  self.checkInType == .ExistingCheckIN
        {
            
            if Structures.Constant.appDelegate.prefrence.endTime .isEqualToString("")
            {
                let date = NSDate(timeInterval: (self.checkIn.frequency.doubleValue  * 60 * 24 ), sinceDate: NSDate())
                self.checkIn.endTime = date
                CheckIn.saveCurrentCheckInObject(self.checkIn)
            }
            
            let arrTemp : NSArray = NSArray(array: self.CheckInArray)
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let iden = innerDict["Identity"] as! NSString!
                    
                    if iden == "ConfirmationHeader"
                    {
                        if  self.checkIn.status.rawValue == 0
                        {
                            innerDict["Value"] = Utility.timeFromDate(self.checkIn.startTime)
                            innerDict["Title"] = NSLocalizedString(Utility.getKey("checkin_will_start_at"),comment:"")
                        }
                        else
                        {
                            var nextConfirmation : NSDate = NSDate()
                            if Structures.Constant.appDelegate.prefrence.laststatustime != nil
                            {
                                nextConfirmation = NSDate(timeInterval: (checkIn.frequency.doubleValue) * 60 , sinceDate: Structures.Constant.appDelegate.prefrence.laststatustime)
                            }
                            else
                            {
                                nextConfirmation = NSDate(timeInterval: (checkIn.frequency.doubleValue) * 60 , sinceDate: NSDate())
                            }
                            if nextConfirmation.compare(self.checkIn.endTime) == NSComparisonResult.OrderedAscending
                            {
                                innerDict["Value"] = Utility.timeFromDate(nextConfirmation)
                                innerDict["Title"] = NSLocalizedString(Utility.getKey("Your next confirmation is at"),comment:"")
                            }
                            else
                            {
                                innerDict["Value"] = Utility.timeFromDate(self.checkIn.endTime)
                                innerDict["Title"] = NSLocalizedString(Utility.getKey("checkin_close_at"),comment:"")//checkin_close_at
                            }
                        }
                        self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                    if iden == "Location"{
                        innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Update"),comment:"")
                        self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                    if iden == "Frequency"{
                        innerDict["OptionTitle"] = Utility.convertFrequencyToHoursAndMinsFormatString(self.checkIn.frequency)
                        self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                    if iden == "Alert"{
                        if self.checkIn.sms.length > 0 || self.checkIn.social.length > 0 || self.checkIn.email.length > 0{
                            innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                            self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                    }
                    if iden == "EndTime"{
                        if Structures.Constant.appDelegate.prefrence.endTime .isEqualToString(""){
                            self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                        else{
                            innerDict["OptionTitle"] = Utility.timeFromDate(self.checkIn.endTime)
                            self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                    }
                    if iden == "Media"{
                        if self.checkIn.mediaArray.count > 0{
                            innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                            self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                    }
                }
            }
            self.tblView.reloadData()
        }
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func changeValueInMainCheckInArray(newValue : NSString, identity : NSString)
    {
        for (index, element) in self.CheckInArray.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == identity{
                    innerDict["Value"] = newValue
                    if iden == "Location"{
                        innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Update"),comment:"")
                    }
                    if iden == "Frequency"{
                        innerDict["OptionTitle"] = Utility.convertFrequencyToHoursAndMinsFormatString(self.checkIn.frequency)
                    }
                    if iden == "Alert"{
                        if self.checkIn.sms.length > 0 || self.checkIn.social.length > 0 || self.checkIn.email.length > 0{
                            innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                        }
                    }
                    if iden == "EndTime"{
                        innerDict["OptionTitle"] = Utility.timeFromDate(self.checkIn.endTime)
                    }
                    if iden == "Media"{
                        if self.checkIn.mediaArray.count > 0{
                            innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                        }
                    }
                    self.CheckInArray.replaceObjectAtIndex(index, withObject: innerDict)
                    self.tblView.reloadData()
                    break
                }
            }
        }
    }
    // MARK: - CheckIn Description
    func checkInDescription(description : NSString){
        self.checkIn.checkInDescription = description
        changeValueInMainCheckInArray(description, identity: "Description")
    }
    //MARK:- Location Changed Delegate Method
    func locationTextChanged(changedText : NSString, location : CLLocation){
        self.checkIn.latitude = NSNumber(double: location.coordinate.latitude)
        self.checkIn.longitude = NSNumber(double: location.coordinate.longitude)
        self.checkIn.address = changedText
        if changedText.length > 0{
            changeValueInMainCheckInArray(changedText, identity: "Location")
        }
    }
    //MARK:- Frequency Promts Delegate Method
    func chooseFrequencyAndPromts(frequency : NSNumber, promts : NSString, isCustom : Bool){
        self.checkIn.frequency = frequency
        self.checkIn.recievePromt = promts
        self.checkIn.isCustom = isCustom
        changeValueInMainCheckInArray(self.checkIn.frequency.stringValue, identity: "Frequency")
    }
    //MARK:- CIAlertMessageProtocol Delegate Method
    func alertMessageModified(email : NSString, sms : NSString, social : NSString){
        self.checkIn.email = email
        self.checkIn.sms = sms
        self.checkIn.social = social
        changeValueInMainCheckInArray("", identity: "Alert")
    }
    //MARK:- CheckIn ContactList View Controller Delegate Methods
    func checkInContact(arr : NSMutableArray?, type: viewType!)
    {
        if type == viewType.Public
        {
            arrPublicContacts = arr!
        }
        else if type == viewType.Private
        {
            arrPrivateCircle = arr!
        }
        self.tblView.reloadData()
    }
    func checkInSocial(strTwitterToken: NSString, strTwitterSecret: NSString, strFacebookToken: NSString)
    {
        strFbToken = strFacebookToken
        strTwToken = strTwitterToken
        strTwTokenSecret = strTwitterSecret
        
        self.checkIn.fbToken = strFbToken
        self.checkIn.twitterToken = strTwToken
        self.checkIn.twitterTokenSecret = strTwTokenSecret
        
        self.tblView.reloadData()
    }
    //MARK:- Media delegate
    func addMedia(mediaObject: Media) {
        self.checkIn.mediaArray.append(mediaObject)
        changeValueInMainCheckInArray("", identity: "Media")
    }
    //MARK:- Set Time Delegate Method Delegate Method
    func selectedTimeByUser(date : NSDate, type : SetTime)
    {
        if type == .EndTime
        {
            
            Structures.Constant.appDelegate.prefrence.endTime = date.description
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            self.checkIn.endTime = date
            changeValueInMainCheckInArray("", identity: "EndTime")
        }
        else
        {
            self.checkIn.startTime = date
            if NSDate().compare(self.checkIn.startTime) == NSComparisonResult.OrderedAscending
            {
                self.checkIn.status = .Pending
            }
            else
            {
                self.checkIn.status = .Started
            }
            startCheckInNow()
        }
    }
    //MARK:- Set Time Delegate Method Delegate Method
    func startNowButtonPressed(){
        self.checkIn.startTime = NSDate()
        self.checkIn.status = .Started
        startCheckInNow()
    }
    func startLaterButtonPressed(){
        let startTimeScreen : SetTimeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SetTimeViewController") as! SetTimeViewController
        startTimeScreen.setTime = .StartTime
        startTimeScreen.endDate = self.checkIn.endTime
        startTimeScreen.delegate = self
        showViewController(startTimeScreen, sender: self.view)
    }
    //MARK:- startThe CheckIN
    func startCheckInNow(){
        registerCheckIN()
    }
    func validateCheckIn() -> Bool{
        var isValidInfo : Bool = true
        var strTitle : String = ""
        
        if self.checkIn.checkInDescription.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("enter_valid_description"),comment:"")
        }else if self.checkIn.address.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("choose_valid_location"),comment:"")
        }else if self.checkIn.latitude.doubleValue == 0 || self.checkIn.longitude.doubleValue == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("choose_valid_location"),comment:"")
        }else if self.checkIn.contactLists.count == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("select_valid_contact_list"),comment:"")
        }else if self.checkIn.frequency.integerValue == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("enter_valid_checkin"),comment:"")
        }
        if isValidInfo == false {
            Utility.showAlertWithTitle(strTitle, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
        return isValidInfo
    }
    func registerCheckIN()
    {
        self.checkIn.contactLists.removeAllObjects()
        self.checkIn.contactLists.removeAllObjects()
        
        self.checkIn.contactLists.addObjectsFromArray(arrPrivateCircle as [AnyObject])
        self.checkIn.contactLists.addObjectsFromArray(arrPublicContacts as [AnyObject])
        self.checkIn.fbToken = strFbToken
        self.checkIn.twitterToken = strTwToken
        self.checkIn.twitterTokenSecret = strTwTokenSecret
        if !validateCheckIn()
        {
            return
        }
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("registerning_checkin"),comment:""))
        
        CheckIn.registerCheckIn(self.checkIn, isNewCheckIn: true)
        CheckIn.sharedInstance.delegate = self
        
    }
    func appendPendingMedia()
    {
        if self.checkIn.mediaArray.count > 0 {
            let arrStore : NSMutableArray = NSMutableArray()
            for (var i : Int = 0; i < self.checkIn.mediaArray.count ; i++)
            {
                let tempMedia : Media = self.checkIn.mediaArray[i] as Media
                tempMedia.notificationID = self.checkIn.checkInID
                arrStore.addObject(tempMedia)
            }
            let userName = String(format: "%@", Structures.Constant.appDelegate.prefrence.LoggedInUser)
            CommonUnit.appendDataWithKey(KEY_PENDING_MEDIA, inFile: userName, list: arrStore)
            SVProgressHUD.dismiss()
        }
    }
    func startUploadingMedia()
    {
        let totalCnt : Int  = self.checkIn.mediaArray.count
        var tempMessage = ""
        if self.checkIn.status.rawValue == 0
        {
            tempMessage = ""
        }else{
            var startOffsetFrequency : Double = 0
            if self.checkIn.startTime.compare(NSDate()) == NSComparisonResult.OrderedDescending
            {
                startOffsetFrequency = self.checkIn.startTime.timeIntervalSinceDate(NSDate())
            }
            let nextConfirmation = NSDate(timeInterval: (startOffsetFrequency+(self.checkIn.frequency.doubleValue) * 60), sinceDate: NSDate())
            tempMessage = NSString(format: NSLocalizedString(Utility.getKey("your_next_conf"),comment:"") as String , (Utility.timeFromDate(nextConfirmation))) as String
        }
        var uploadingSuccessFully : Bool = true
        for  _ in self.checkIn.mediaArray{
            if !uploadingSuccessFully{
                break
            }
            let strIndi : String = NSString(format: NSLocalizedString(Utility.getKey("uploading_of"),comment:""), totalCnt+1 - self.checkIn.mediaArray.count, totalCnt) as String
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.showWithStatus(strIndi, maskType: 4)
            })
            let tempMedia : Media = self.checkIn.mediaArray[0] as Media
            tempMedia.notificationID = self.checkIn.checkInID
            Media.sendMediaObject(tempMedia, completionClosure: { (isSuccess) -> Void in
                if isSuccess{
                    // Delete from directory
                    if tempMedia.mediaType == MediaType.Video
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    else  if tempMedia.mediaType == MediaType.Image
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    else  if tempMedia.mediaType == MediaType.Audio
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    self.checkIn.mediaArray.removeAtIndex(0)
                    CheckIn.saveCurrentCheckInObject(self.checkIn)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                else{
                    uploadingSuccessFully = false
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.appendPendingMedia()
                        let alert = UIAlertController(title: NSString(format: NSLocalizedString(Utility.getKey("failed_to_upload_media_but"),comment:"")) as String , message: tempMessage, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                            self.backToPreviousScreen()
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                if self.checkIn.mediaArray.count == 0
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //All Media Sent Successfully
                        let dic : NSMutableDictionary = NSMutableDictionary()
                        dic [Structures.Media.ForeignID] = self.checkIn.checkInID
                        dic [Structures.Media.TableID] = NotificationType.CheckIn.rawValue
                        let wsObj : WSClient = WSClient()
                        wsObj.delegate = self
                        wsObj.sendMailWithMedia(dic)
                        SVProgressHUD.showSuccessWithStatus(NSLocalizedString(Utility.getKey("all_media_uploaded"),comment:""))
                        SVProgressHUD.show()
                    })
                }
            })
        }
    }
    func setUpLocalNotifications(action : NSString, body : NSString, fireDate : NSDate, userInfo : NSDictionary){
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = action as String
        localNotification.alertBody = body as String
        localNotification.fireDate = fireDate
        localNotification.userInfo = userInfo as [NSObject : AnyObject]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    //MARK:- Confirm Button Footer Cell Protocol
    func anyChangeInCheckIn()-> Bool{
        
        if CheckIn.isAnyCheckInActive()
        {
            var tempCheckIn : CheckIn = CheckIn.sharedInstance
            tempCheckIn = CheckIn.getCurrentCheckInObject()
            if tempCheckIn.checkInDescription != self.checkIn.checkInDescription {
                return true
            }
            else if tempCheckIn.address != self.checkIn.address{
                return true
            }
            else if tempCheckIn.contactLists != self.checkIn.contactLists{
                return true
            }
            else if tempCheckIn.sms != self.checkIn.sms{
                return true
            }
            else if tempCheckIn.email != self.checkIn.email{
                return true
            }
            else if tempCheckIn.social != self.checkIn.social{
                return true
            }
            else if tempCheckIn.recievePromt != self.checkIn.recievePromt{
                return true
            }
            else if tempCheckIn.frequency != self.checkIn.frequency{
                return true
            }
            else if tempCheckIn.endTime != self.checkIn.endTime{
                return true
            }
            else if self.checkIn.mediaArray != nil {
                if self.checkIn.mediaArray.count > 0 {
                    return true
                }
                return false
            }
        }
        return false
    }
    func checkInSaveChangeAlert(){
        
        if  Utility.isConnectedToNetwork(){
            
            isAnyChangeInCheckIn = anyChangeInCheckIn()
            if isAnyChangeInCheckIn == true{
                let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("save_the_changes"),comment:""), message:"", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("save"),comment:""), style: .Default, handler: { action in
                    self.checkIn.contactLists.removeAllObjects()
                    self.checkIn.contactLists.addObjectsFromArray(self.arrPrivateCircle as [AnyObject])
                    self.checkIn.contactLists.addObjectsFromArray(self.arrPublicContacts as [AnyObject])
                    
                    
                    self.isAnyChangeInCheckIn = true
                    self.confirmCheckInPressed()
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Default, handler: { action in
                    self.isAnyChangeInCheckIn = false
                    self.confirmCheckInPressed()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                self.isAnyChangeInCheckIn = false
                confirmCheckInPressed()
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.appendPendingMedia()
                let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""), message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler:{ action in
                    self.backToPreviousScreen()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    func confirmCheckInPressed()
    {
        if !validateCheckIn()
        {
            return
        }
        var status : NSNumber = NSNumber(integer : 2)
        //pending checkin to Active
        if self.checkIn.status.rawValue == 0
        {
            status = NSNumber(integer : 1)
        }
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("confirming_checkin"),comment:""), maskType: 4)
        
        CheckIn.updateCheckInStatus(NSMutableDictionary(dictionary:self.dictStatusCheckIn(self.checkIn, status : status)))
        CheckIn.sharedInstance.delegate = self
    }
    //MARK:- Save Button Footer Cell Protocol
    func doneButtonPressed()
    {
        
        if  Utility.isConnectedToNetwork(){
            
            self.checkIn.contactLists.removeAllObjects()
            self.checkIn.contactLists.addObjectsFromArray(arrPrivateCircle as [AnyObject])
            self.checkIn.contactLists.addObjectsFromArray(arrPublicContacts as [AnyObject])
            
            if !validateCheckIn()
            {
                return
            }
            
            SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("editing_checkin"),comment:""), maskType: 4)
            CheckIn.registerCheckIn(self.checkIn, isNewCheckIn: false)
            CheckIn.sharedInstance.delegate = self
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.appendPendingMedia()
                let alert = UIAlertController(title: NSLocalizedString(Utility.getKey("internet_connection_unavailable"),comment:""), message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler:{ action in
                    self.backToPreviousScreen()
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    //MARK:- Cancel Button Footer Cell Protocol
    func cancelCheckInPressed(){
        let alertController = UIAlertController(title: NSLocalizedString(Utility.getKey("Enter Password"),comment:""), message: NSLocalizedString(Utility.getKey("enter_pass_to_deactive_acheckin"),comment:""), preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("Password"),comment:"")
            textField.secureTextEntry = true
            if Structures.Constant.appDelegate.isArabic == true
            {
                textField.textAlignment = NSTextAlignment.Right
            }
            else
            {
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        let okAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default) { (_) in
            let tfPassword = alertController.textFields![0]
            let password : NSString = tfPassword.text!
            self.checkInpassword = tfPassword.text
            if password.length>0{
                SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("canceling_checkin"),comment:""), maskType: 4)
                CheckIn.updateCheckInStatus(NSMutableDictionary(dictionary:self.dictCloseStatusCheckIn(self.checkIn, status : NSNumber(integer : 3))))
                CheckIn.sharedInstance.delegate = self
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                if (Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Status) as! NSString).isEqualToString("0")
                {
                    let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
                    let message = NSLocalizedString(Utility.getKey("failed_to_cancel_checkin"),comment:"")
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backToPreviousScreen()
                        })
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        CheckIn.removeActiveCheckInObject()
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
                
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel) { (action) in
        }
        if Structures.Constant.appDelegate.isArabic == true
        {
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
        }
        else
        {
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func dictStatusCheckIn(checkIN : CheckIn, status : NSNumber) -> NSDictionary{
        var dictionary = NSDictionary()
        if isAnyChangeInCheckIn == true{
            
            let arrContacts = NSMutableArray(array: checkIN.contactLists)
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
            
            dictionary = [
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
                Structures.Constant.Status : status,
                Structures.Alert.ContactList : strContacts,
                Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
                Structures.Constant.Time : Utility.getUTCFromDate(),
                Structures.User.User_DeviceToken : Structures.Constant.appDelegate.prefrence.DeviceToken,
                Structures.User.User_DeviceType : "1",
                Structures.Alert.FB_Token : checkIN.fbToken,
                Structures.Alert.Twitter_Token : checkIN.twitterToken,
                Structures.Alert.Twitter_Token_Secret : checkIN.twitterTokenSecret,
                "ismadeanychanges" : "1"
            ]
        }else{
            dictionary = [
                Structures.CheckIn.CheckIn_ID : checkIN.checkInID,
                Structures.Constant.Latitude : self.checkIn.latitude,
                Structures.Constant.Longitude : self.checkIn.longitude,
                Structures.Constant.Status : status,
                Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
                Structures.Constant.Time : Utility.getUTCFromDate(),
                "ismadeanychanges" : "0"
            ]
        }
        return dictionary
    }
    func dictCloseStatusCheckIn(checkIN : CheckIn, status : NSNumber) -> NSDictionary{
        let dictionary = [
            Structures.CheckIn.CheckIn_ID : checkIN.checkInID,
            Structures.Constant.Latitude : self.checkIn.latitude,
            Structures.Constant.Longitude : self.checkIn.longitude,
            Structures.Constant.Status : status,
            Structures.Constant.TimezoneID : NSTimeZone.systemTimeZone().description,
            Structures.Constant.Time : Utility.getUTCFromDate(),
            Structures.User.User_Password : checkInpassword
        ]
        return dictionary
    }
    // MARK: - RegisterKeyBoard Notification
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CheckInArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kRowHeight = self.CheckInArray[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = self.CheckInArray[indexPath.row]["CellIdentifier"] as! String
        if let cell: CheckInDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? CheckInDetailTableViewCell {
            cell.value = self.CheckInArray[indexPath.row]["Value"] as! NSString!
            cell.identity = self.CheckInArray[indexPath.row]["Identity"] as! String!
            cell.title = self.CheckInArray[indexPath.row]["Title"] as! String!
            cell.intialize()
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.textView.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.textView.textAlignment = NSTextAlignment.Left
            }
            return cell
        }
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "LocationListingCellIdentifier"
        {
            if let cell: ARLocationListingCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier) as? ARLocationListingCell
            {
                cell.value = self.CheckInArray[indexPath.row]["Value"] as! NSString!
                cell.detail = self.CheckInArray[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.CheckInArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: LocationListingCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? LocationListingCell
            {
                cell.value = self.CheckInArray[indexPath.row]["Value"] as! NSString!
                cell.detail = self.CheckInArray[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.CheckInArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        if let cell: TitleTableViewCell2 = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell2 {
            cell.levelString = self.CheckInArray[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.CheckInArray[indexPath.row]["Title"] as! String!
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Left
            }
            cell.intialize()
            return cell
        }
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier
        {
            if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier) as? ARTitleTableViewCell
            {
                cell.lblDetail.text = self.CheckInArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.CheckInArray[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.CheckInArray[indexPath.row]["Title"] as! String!
                cell.type = self.CheckInArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                if ( self.CheckInArray[indexPath.row]["Identity"] as! NSString == "PublicContactsList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if arrPublicContacts.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.CheckInArray[indexPath.row]["Identity"] as! NSString == "SocialMediaList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if !strTwToken.isEqualToString("") || !strFbToken.isEqualToString("")
                    {
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.CheckInArray[indexPath.row]["Identity"] as! NSString == "PrivateContactsList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if arrPrivateCircle.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                return cell
            }
        }
        else
        {
            if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell {
                cell.lblDetail.text = self.CheckInArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.CheckInArray[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.CheckInArray[indexPath.row]["Title"] as! String!
                cell.type = self.CheckInArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                if ( self.CheckInArray[indexPath.row]["Identity"] as! NSString == "PublicContactsList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if arrPublicContacts.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.CheckInArray[indexPath.row]["Identity"] as! NSString == "SocialMediaList"  )
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if !strTwToken.isEqualToString("") || !strFbToken.isEqualToString("")
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                else if ( self.CheckInArray[indexPath.row]["Identity"] as! NSString == "PrivateContactsList")
                {
                    cell.lblTitle.textColor = UIColor.grayColor()
                    if arrPrivateCircle.count > 0
                    {
                        cell.lblTitle.textColor = UIColor.blackColor()
                        cell.lblDetail.text = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                    }
                }
                return cell
            }
        }
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier) as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = self.CheckInArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.CheckInArray[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.CheckInArray[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.CheckInArray[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.CheckInArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell {
                cell.lblSubDetail.text = self.CheckInArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.CheckInArray[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.CheckInArray[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.CheckInArray[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.CheckInArray[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        if let cell: ConfirmedCICell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? ConfirmedCICell {
            cell.selectionStyle = .None
            cell.value = self.CheckInArray[indexPath.row]["Value"] as! String!
            cell.title = self.CheckInArray[indexPath.row]["Title"] as! String!
            cell.intialize()
            return cell
        }
        if let cell: CheckInFooterTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? CheckInFooterTableViewCell {
            cell.delegate = self
            cell.selectionStyle = .None
            return cell
        }
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showDescriptionScreen"{
            showDescriptionScreen(self.CheckInArray[indexPath.row]["Value"] as! NSString)
        }
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showLocationDetailScreen"{
            showLocationDetailScreen(self.CheckInArray[indexPath.row]["Value"] as! NSString)
        }
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showFrequencyPromtsScreen"{
            showFrequencyScreen(self.checkIn.frequency, promts: self.checkIn.recievePromt, isCustom: self.checkIn.isCustom.boolValue)
        }
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showAlertMessagesScreen"{
            showAlertMessagesScreen(self.checkIn.email, sms: self.checkIn.sms, social: self.checkIn.social)
        }
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showEndTimeScreen"{
            showEndTimeScreen(0, mins: 0)
        }
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showAllContactsList"{
            showAllContactsList(indexPath.row)
        }
        if  self.CheckInArray[indexPath.row]["Method"] as! NSString! == "showMideaPickerView"{
            showMideaPickerView()
        }
    }
    func showDescriptionScreen(text : NSString){
        descriptionScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckInDescriptionViewController") as! CheckInDescriptionViewController
        if let viewController = descriptionScreen{
            viewController.delegate = self
            viewController.textViewText = text
            viewController.changeTitle = 0
            showViewController(viewController, sender: self.view)
        }
    }
    func showLocationDetailScreen(text : NSString){
        
        locationDetailScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationViewController") as! LocationViewController
        if let viewController = locationDetailScreen{
            viewController.delegate = self
            viewController.userLocation = CLLocation(latitude: self.checkIn.latitude.doubleValue, longitude: self.checkIn.longitude.doubleValue)
            viewController.userLocationString = text
            viewController.changeTitle = 0
            showViewController(viewController, sender: self.view)
        }
    }
    func showFrequencyScreen(frequency : NSNumber, promts : NSString, isCustom : Bool){
        frequencyScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CheckInFrequencyViewController") as! CheckInFrequencyViewController
        if let viewController = frequencyScreen{
            viewController.delegate = self
            viewController.frequency = frequency
            viewController.isCustom = isCustom
            viewController.promots = promts
            showViewController(viewController, sender: self.view)
        }
    }
    func showAlertMessagesScreen(email : NSString, sms : NSString, social : NSString){
        let alertMessageScreen : CIALertMessageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CIALertMessageViewController") as! CIALertMessageViewController
        alertMessageScreen.delegate = self
        alertMessageScreen.emailMSG = email as String
        alertMessageScreen.smsMSG = sms as String
        alertMessageScreen.socialMSG = social as String
        showViewController(alertMessageScreen, sender: self.view)
    }
    func showEndTimeScreen(hour : Int, mins : Int){
        let endTimeScreen : SetTimeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SetTimeViewController") as! SetTimeViewController
        endTimeScreen.setTime = .EndTime
        let frequency : NSTimeInterval = (self.checkIn.frequency.doubleValue * 60) + (2 * 60)
        let nextConfirmation = NSDate(timeInterval:frequency, sinceDate:NSDate())
        endTimeScreen.endDate = nextConfirmation
        endTimeScreen.delegate = self
        showViewController(endTimeScreen, sender: self.view)
    }
    func showAllContactsList(SelectedRow: NSInteger){
        let circleScreen : CreateOrSaveCircleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateOrSaveCircleVC") as! CreateOrSaveCircleVC
        circleScreen.delegate = self
        circleScreen.changeTitle = 0
        if self.CheckInArray.objectAtIndex(SelectedRow).valueForKey("Identity") as? NSString == viewType.Private.rawValue{
            circleScreen.myViewType = viewType.Private
            circleScreen.arrSelected = arrPrivateCircle
            circlePrivate = Circle(name:"Private", type:.Private,contactList:[])
            if  (circlePrivate == nil)
            {
                circlePrivate = Circle(name:"Private", type:.Private,contactList:[])
            }
            circleScreen.circle = circlePrivate
            showViewController(circleScreen, sender: self.view)
        }
        else if self.CheckInArray.objectAtIndex(SelectedRow).valueForKey("Identity") as? NSString == viewType.Public.rawValue
        {
            circleScreen.myViewType = viewType.Public
            circleScreen.arrSelected = arrPublicContacts
            circlePublic = Circle(name:"Public", type:.Public,contactList:[])
            if  (circlePublic == nil)
            {
                circlePublic = Circle(name:"Public", type:.Private,contactList:[])
            }
            circleScreen.circle = circlePublic
            showViewController(circleScreen, sender: self.view)
        }
        else if self.CheckInArray.objectAtIndex(SelectedRow).valueForKey("Identity") as? NSString == viewType.Social.rawValue
        {
            let circleScreen : SocialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SocialViewController") as! SocialViewController
            circleScreen.mySocialViewFrom = socialViewFrom.CheckIn
            circleScreen.delegate = self
            showViewController(circleScreen, sender: self.view)
        }
    }
    func showMideaPickerView(){
        let mediaPickerScreen : MediaPickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MediaPickerViewController") as! MediaPickerViewController
        mediaPickerScreen.delegate = self
        mediaPickerScreen.mediaFor = .CheckIn
        showViewController(mediaPickerScreen, sender: self.view)
    }
    
    
    func commonCheckInResponse(wsType : WSRequestType, checkIn_ID : NSNumber ,dict : NSDictionary, isSuccess : Bool)
    {
        if wsType == WSRequestType.CreateCheckIn{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            if isSuccess
            {
                Structures.Constant.appDelegate.isUnlockAppAlertOpen = false
                Structures.Constant.appDelegate.prefrence.laststatustime = self.checkIn.startTime
                AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                
                self.checkIn.checkInID = checkIn_ID
                var isEndDateSet : Bool = true
                if  Structures.Constant.appDelegate.prefrence.endTime .isEqualToString(""){
                    isEndDateSet = false
                    let date = NSDate(timeInterval: (self.checkIn.frequency.doubleValue  * 60 * 24 ), sinceDate: NSDate())
                    self.checkIn.endTime = date
                }
                var message = ""
                var title = ""
                let startedDate = self.checkIn.startTime
                let frequency : NSTimeInterval = (self.checkIn.frequency.doubleValue)
                let endTime : NSDate = self.checkIn.endTime
                let currentDate = NSDate()
                //Remonder Before 5 min
                var startOffsetReminder : Double = 0
                if frequency >= 30
                {
                    if currentDate.compare(startedDate) == NSComparisonResult.OrderedAscending
                    {
                        startOffsetReminder = startedDate.timeIntervalSinceDate(currentDate)
                    }
                    let triggerDurationReminder : Double = startOffsetReminder  + (frequency - 10) * 60
                    let nextConfirmationReminder = NSDate(timeInterval: triggerDurationReminder, sinceDate: currentDate)
                    if (isEndDateSet == false || nextConfirmationReminder.compare(endTime) == NSComparisonResult.OrderedAscending)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Reminder ]
                            self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_remind"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: nextConfirmationReminder, userInfo: userInfo)
                        })
                        if isEndDateSet == true
                        {
                            //Close Reminder
                            let timeInterval = startedDate.timeIntervalSinceDate(endTime)
                            if  Int(timeInterval) >= (60 * 30)
                            {
                                let  startOffsetReminder = currentDate.timeIntervalSinceDate(endTime)
                                if startOffsetReminder > 10 * 60
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.CloseReminder]
                                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed_10min"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.checkIn.endTime), userInfo: userInfo)
                                    })
                                }
                            }
                        }
                    }
                }
                //Confirmation Before 1 min
                var startOffsetFrequency : Double = 0
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    startOffsetFrequency = startedDate.timeIntervalSinceDate(currentDate)
                }
                let nextConfirmationFrequency = NSDate(timeInterval: (startOffsetFrequency + (frequency - 2) * 60), sinceDate: currentDate)
                if (isEndDateSet == false || endTime.compare(nextConfirmationFrequency) == NSComparisonResult.OrderedDescending)
                {
                    let nextConfirmationMsg = NSDate(timeInterval: (startOffsetFrequency + (frequency) * 60), sinceDate: currentDate)
                    title = NSLocalizedString(Utility.getKey("checkin_is_now_active"),comment:"")
                    message =  NSString(format: NSLocalizedString(Utility.getKey("your_next_conf"),comment:"") , (Utility.timeFromDate(nextConfirmationMsg))) as String
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Confirmation]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), fireDate: nextConfirmationFrequency, userInfo: userInfo)
                    })
                }
                
                //Miss Check-In
                var startOffsetFreq : Double = 0
                var trigerDuration : Double = 0
                //startedDate > currentDate
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    // Future date
                    startOffsetFreq = startedDate.timeIntervalSinceDate(currentDate)
                }
                trigerDuration = startOffsetFreq + ((frequency + 1) * 60)
                //startedDate < currentDate
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedAscending
                {
                    trigerDuration = trigerDuration - (currentDate.timeIntervalSinceDate(self.checkIn.startTime))
                }
                let newDate = NSDate(timeInterval: trigerDuration, sinceDate: currentDate)
                if isEndDateSet == false || newDate.compare(endTime) == NSComparisonResult.OrderedAscending
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.MissedCheckIn]
                        self.setUpLocalNotifications( String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), body: String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), fireDate: newDate, userInfo: userInfo)
                    })
                }
                
                //CheckIn endTime Close Reminder
                if (isEndDateSet == true && currentDate.compare(endTime) == NSComparisonResult.OrderedAscending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID,Structures.CheckIn.Status : Structures.CheckInStatus.CheckInClosed ]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), fireDate: self.checkIn.endTime, userInfo: userInfo)
                    })
                }
                // Pending Check In Reminder
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    title  = NSString(format: NSLocalizedString(Utility.getKey("checkin_begin_at"),comment:"") , (Utility.timeFromDate(self.checkIn.startTime))) as String
                    message = ""
                    // 5 minutes before start time for pending check in
                    startOffsetFrequency = 0
                    startOffsetFrequency = startedDate.timeIntervalSinceDate(currentDate)
                    if (startOffsetReminder >= 30 * 60)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.StartReminder,]
                            self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_will_start_in_10"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_will_start_in_10"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.checkIn.startTime), userInfo: userInfo)
                        })
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Start,]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_will_start_now"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_will_start_now"),comment:""), fireDate: self.checkIn.startTime, userInfo: userInfo)
                    })
                }
                
                //Save CheckinObject to Model
                CheckIn.saveCurrentCheckInObject(self.checkIn)
                NSUserDefaults.standardUserDefaults().synchronize()
                if self.checkIn.mediaArray.count > 0
                {
                    self.startUploadingMedia()
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                            self.backToPreviousScreen()
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }else{
                for tempMedia in self.checkIn.mediaArray{
                    if tempMedia.mediaType == MediaType.Video
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    else  if tempMedia.mediaType == MediaType.Image
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    else  if tempMedia.mediaType == MediaType.Audio
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                        if dict.valueForKey(Structures.Constant.Message) != nil
                        {
                            
                            Utility.showLogOutAlert((dict.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                            
                        }
                    }else{
                        if dict.valueForKey(Structures.Constant.Message) != nil
                        {
                            Utility.showAlertWithTitle(dict.valueForKey(Structures.Constant.Message) as! String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                        }
                    }
                })
            }
        }else if wsType == WSRequestType.UpdateCheckIn{
            if isSuccess{
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                CheckIn.saveCurrentCheckInObject(self.checkIn)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                self.updateStatusText()
                let currentDate = NSDate()
                if self.checkIn.startTime.compare(currentDate) == NSComparisonResult.OrderedDescending//Greater
                {
                    Structures.Constant.appDelegate.prefrence.laststatustime = self.checkIn.startTime
                }
                else
                {
                    Structures.Constant.appDelegate.prefrence.laststatustime = currentDate
                }
                
                AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                
                var isEndDateSet : Bool = true
                if Structures.Constant.appDelegate.prefrence.endTime .isEqualToString("")
                {
                    isEndDateSet = false
                    let date = NSDate(timeInterval: (self.checkIn.frequency.doubleValue  * 60 * 24 ), sinceDate: currentDate)
                    self.checkIn.endTime = date
                }
                let message = ""
                let title = NSLocalizedString(Utility.getKey("checkin_edited_suc"),comment:"")
                let startedDate = self.checkIn.startTime
                let frequency : NSTimeInterval = (self.checkIn.frequency.doubleValue)
                let endTime : NSDate = self.checkIn.endTime
                
                //Remonder Before 5 min
                var startOffsetReminder : Double = 0
                if frequency >= 30
                {
                    if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                    {
                        startOffsetReminder = startedDate.timeIntervalSinceDate(currentDate)
                    }
                    let triggerDurationReminder : Double = startOffsetReminder  + (frequency - 10) * 60
                    let nextConfirmationReminder = NSDate(timeInterval: triggerDurationReminder, sinceDate: currentDate)
                    if (isEndDateSet == false || nextConfirmationReminder.compare(endTime) == NSComparisonResult.OrderedAscending)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Reminder]
                            self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_remind"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: nextConfirmationReminder, userInfo: userInfo)
                        })
                        if isEndDateSet == true
                        {
                            //Close Reminder
                            let timeInterval = startedDate.timeIntervalSinceDate(endTime)
                            if  Int(timeInterval) >= (60 * 30)
                            {
                                let  startOffsetReminder = currentDate.timeIntervalSinceDate(endTime)
                                if startOffsetReminder > 10 * 60
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.CloseReminder]
                                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed_10min"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.checkIn.endTime), userInfo: userInfo)
                                        
                                    })
                                }
                            }
                        }
                    }
                }
                //Confirmation Before 1 min
                var startOffsetFrequency : Double = 0
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    startOffsetFrequency = startedDate.timeIntervalSinceDate(currentDate)
                }
                let nextConfirmationFrequency = NSDate(timeInterval: (startOffsetFrequency + (frequency - 2) * 60), sinceDate: currentDate)
                if (isEndDateSet == false || endTime.compare(nextConfirmationFrequency) == NSComparisonResult.OrderedDescending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Confirmation]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), fireDate: nextConfirmationFrequency, userInfo: userInfo)
                    })
                }
                
                //Miss Check-In
                var startOffsetFreq : Double = 0
                var trigerDuration : Double = 0
                //startedDate > currentDate
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    // Future date
                    startOffsetFreq = startedDate.timeIntervalSinceDate(currentDate)
                }
                trigerDuration = startOffsetFreq + ((frequency + 1) * 60)
                //startedDate < currentDate
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedAscending
                {
                    trigerDuration = trigerDuration - (currentDate.timeIntervalSinceDate(self.checkIn.startTime))
                }
                let newDate = NSDate(timeInterval: trigerDuration, sinceDate: currentDate)
                if isEndDateSet == false || newDate.compare(endTime) == NSComparisonResult.OrderedAscending
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.MissedCheckIn]
                        self.setUpLocalNotifications( String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), body: String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), fireDate: newDate, userInfo: userInfo)
                    })
                }
                
                //CheckIn endTime Close Reminder
                if (isEndDateSet == true && currentDate.compare(endTime) == NSComparisonResult.OrderedAscending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID,Structures.CheckIn.Status : Structures.CheckInStatus.CheckInClosed ]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), fireDate: self.checkIn.endTime, userInfo: userInfo)
                    })
                }
                // Pending Check In Reminder
                if startedDate.compare(currentDate) == NSComparisonResult.OrderedDescending
                {
                    // 5 minutes before start time for pending check in
                    startOffsetFrequency = 0
                    startOffsetFrequency = startedDate.timeIntervalSinceDate(currentDate)
                    if (startOffsetReminder >= 30 * 60)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID,
                                Structures.CheckIn.Status : Structures.CheckInStatus.StartReminder,
                            ]
                            self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_will_start_in_10"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_will_start_in_10"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.checkIn.startTime), userInfo: userInfo)
                        })
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID,
                            Structures.CheckIn.Status : Structures.CheckInStatus.Start,
                        ]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_will_start_now"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_will_start_now"),comment:""), fireDate: self.checkIn.startTime, userInfo: userInfo)
                    })
                }
                if self.checkIn.mediaArray.count > 0{
                    self.startUploadingMedia()
                }else{
                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                        self.backToPreviousScreen()
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                for tempMedia in self.checkIn.mediaArray{
                    if tempMedia.mediaType == MediaType.Video
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    else  if tempMedia.mediaType == MediaType.Image
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                    else  if tempMedia.mediaType == MediaType.Audio
                    {
                        CommonUnit.deleteSingleFile(tempMedia.name, fromDirectory: "/Media/")
                    }
                }
                SVProgressHUD.dismiss()
                
                if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        Utility.showLogOutAlert((dict.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                    }
                }else{
                    self.backToPreviousScreen()
                }
            }
        }
        else if wsType == WSRequestType.ConfirmCheckIn || wsType == WSRequestType.CheckInStarted {
            if isSuccess{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    Utility.cancelNotification(Structures.CheckInStatus.Confirmation)
                    Utility.cancelNotification(Structures.CheckInStatus.Reminder)
                    Utility.cancelNotification(Structures.CheckInStatus.CloseReminder)
                    Utility.cancelNotification(Structures.CheckInStatus.CheckInClosed)
                    Utility.cancelNotification(Structures.CheckInStatus.MissedCheckIn)
                })
                CheckIn.saveCurrentCheckInObject(self.checkIn)
                NSUserDefaults.standardUserDefaults().synchronize()
                
                if self.isAnyChangeInCheckIn == false{
                    //pending checkin to Active
                    if CheckIn.isAnyCheckInActive()
                    {
                        self.checkIn = CheckIn.getCurrentCheckInObject()
                        self.checkInType = .ExistingCheckIN
                        for (var i = 0 ; i < self.checkIn.contactLists.count ; i++)
                        {
                            if self.checkIn.contactLists.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "1"
                            {
                                self.arrPrivateCircle.addObject(self.checkIn.contactLists.objectAtIndex(i))
                            }
                            if self.checkIn.contactLists.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "2"
                            {
                                self.arrPublicContacts.addObject(self.checkIn.contactLists.objectAtIndex(i))
                            }
                        }
                        self.checkIn.mediaArray = [Media]()
                    }
                }
                if self.checkIn.status.rawValue == 0
                {
                    self.checkIn.startTime = NSDate()
                    self.checkIn.status = .Started
                    CheckIn.saveCurrentCheckInObject(self.checkIn)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                var isEndDateSet : Bool = true
                var endTime : NSDate!
                self.checkIn.status = .Confirmed
                let startedDate = self.checkIn.startTime
                let currentTime : NSDate = NSDate()
                let frequency : NSTimeInterval = (self.checkIn.frequency.doubleValue)
                
                Structures.Constant.appDelegate.prefrence.laststatustime = currentTime
                AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                let lastConfirmCheckinTime : NSDate = Structures.Constant.appDelegate.prefrence.laststatustime
                
                if Structures.Constant.appDelegate.prefrence.endTime .isEqualToString("")
                {
                    isEndDateSet = false
                    endTime = NSDate(timeInterval: (self.checkIn.frequency.doubleValue  * 60 * 24 ), sinceDate: lastConfirmCheckinTime )
                    self.checkIn.endTime = endTime
                }
                else
                {
                    endTime = self.checkIn.endTime
                }
                //Remonder Before 5 min
                var startOffsetReminder : Double = 0
                if frequency >= 30
                {
                    if startedDate.compare(currentTime) == NSComparisonResult.OrderedDescending
                    {
                        startOffsetReminder = startedDate.timeIntervalSinceDate(currentTime)
                    }
                    let triggerDurationReminder : Double = startOffsetReminder  + (frequency - 10) * 60
                    let nextConfirmationReminder = NSDate(timeInterval: triggerDurationReminder, sinceDate: currentTime)
                    if (isEndDateSet == false || nextConfirmationReminder.compare(endTime) == NSComparisonResult.OrderedAscending)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Reminder]
                            self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_remind"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: nextConfirmationReminder, userInfo: userInfo)
                        })
                        if isEndDateSet == true
                        {
                            //Close Reminder
                            let timeInterval = startedDate.timeIntervalSinceDate(endTime)
                            if  Int(timeInterval) >= (60 * 30)
                            {
                                let  startOffsetReminder = currentTime.timeIntervalSinceDate(endTime)
                                if startOffsetReminder > 10 * 60
                                {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.CloseReminder]
                                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed_10min"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_10min"),comment:""), fireDate: NSDate(timeInterval: -600, sinceDate: self.checkIn.endTime), userInfo: userInfo)
                                    })
                                }
                            }
                        }
                    }
                }
                //Confirmation Before 1 min
                var startOffsetFrequency : Double = 0
                if startedDate.compare(currentTime) == NSComparisonResult.OrderedDescending
                {
                    startOffsetFrequency = startedDate.timeIntervalSinceDate(currentTime)
                }
                let triggerDurationFrequency : Double = startOffsetFrequency + (frequency - 2) * 60
                let nextConfirmationFrequency = NSDate(timeInterval: triggerDurationFrequency, sinceDate: currentTime)
                if (isEndDateSet == false || endTime.compare(nextConfirmationFrequency) == NSComparisonResult.OrderedDescending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.Confirmation]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), body: NSLocalizedString(Utility.getKey("confirm_checkin_now"),comment:""), fireDate: nextConfirmationFrequency, userInfo: userInfo)
                    })
                }
                
                //Miss Check-In
                var startOffsetFreq : Double = 0
                var trigerDuration : Double = 0
                //startedDate > currentDate
                if startedDate.compare(currentTime) == NSComparisonResult.OrderedDescending
                {
                    // Future date
                    startOffsetFreq = startedDate.timeIntervalSinceDate(currentTime)
                }
                trigerDuration = startOffsetFreq + ((frequency + 1) * 60)
                //startedDate < currentDate
                if startedDate.compare(currentTime) == NSComparisonResult.OrderedAscending
                {
                    trigerDuration = trigerDuration - (currentTime.timeIntervalSinceDate(lastConfirmCheckinTime))
                }
                let newDate = NSDate(timeInterval: trigerDuration, sinceDate: currentTime)
                
                if isEndDateSet == false || newDate.compare(endTime) == NSComparisonResult.OrderedAscending
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID, Structures.CheckIn.Status : Structures.CheckInStatus.MissedCheckIn]
                        Structures.Constant.appDelegate.setUpLocalNotificationsReActive( String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), body: String(format: NSLocalizedString(Utility.getKey("you_missed_chechin_confirmation"),comment:"") , (Utility.timeFromDate(newDate))), fireDate: newDate, userInfo: userInfo)
                    })
                }
                
                //CheckIn endTime Close Reminder
                if (isEndDateSet == true && currentTime.compare(endTime) == NSComparisonResult.OrderedAscending)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let userInfo : NSDictionary = ["CheckInID" : self.checkIn.checkInID,Structures.CheckIn.Status : Structures.CheckInStatus.CheckInClosed ]
                        self.setUpLocalNotifications(NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), body: NSLocalizedString(Utility.getKey("checkin_closed"),comment:""), fireDate: self.checkIn.endTime, userInfo: userInfo)
                    })
                }
                
                if self.checkIn.mediaArray.count > 0{
                    self.startUploadingMedia()
                }else{
                    var title = ""
                    let nextConfirmation = NSDate(timeInterval: (startOffsetFrequency+(frequency) * 60), sinceDate: currentTime)
                    if nextConfirmation.compare(self.checkIn.endTime) == NSComparisonResult.OrderedAscending{
                        title = NSString(format: NSLocalizedString(Utility.getKey("your_next_conf"),comment:"") , (Utility.timeFromDate(nextConfirmation) as String)) as String
                    }else{
                        title = NSString(format: NSLocalizedString(Utility.getKey("checkin_closed_at"),comment:"") , (Utility.timeFromDate(self.checkIn.endTime))) as String
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.backToPreviousScreen()
                            })
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                if (dict.valueForKey(Structures.Constant.Status) as! NSString).isEqualToString("0")
                {
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        CheckIn.removeActiveCheckInObject()
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                    
                }
            }
        } else if wsType == WSRequestType.CancelCheckIn{
            
            
            let title = NSLocalizedString(Utility.getKey("confirmation"),comment:"")
            var message = ""
            if isSuccess{
                message = NSLocalizedString(Utility.getKey("checkin_canceled"),comment:"")
                CheckIn.removeActiveCheckInObject()
                Utility.removeAllPendingMedia()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backToPreviousScreen()
                        })
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                if (dict.valueForKey(Structures.Constant.Status) as! NSString).isEqualToString("0")
                {
                    message = NSLocalizedString(Utility.getKey("failed_to_cancel_checkin"),comment:"")
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Cancel) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.backToPreviousScreen()
                        })
                    }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        CheckIn.removeActiveCheckInObject()
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
            }
        }
        
    }
    
    
    //MARK:- WSDelegate
    func getContactListWithData()
    {
        SVProgressHUD.show()
        let dic : NSMutableDictionary = NSMutableDictionary()
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.getContactListWithData(dic)
    }
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if  (response is NSString)
        {
            SVProgressHUD.dismiss()
        }
        else
        {
            let data : NSData? = NSData(data: response as! NSData)
            if   (data != nil)
            {
                if  let dic : NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!{
                    if  type == WSRequestType.GetContactList
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            let arrCircle : NSArray  = dic.valueForKey("data") as! NSArray
                            for (var i = 0 ; i < arrCircle.count ; i++)
                            {
                                if arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1" &&  arrCircle.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "1"
                                {
                                    arrPrivateCircle.removeAllObjects()
                                    arrPrivateCircle.addObject(arrCircle.objectAtIndex(i))
                                }
                                else if arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1" &&  arrCircle.objectAtIndex(i).valueForKey(Structures.User.CircleType) as! NSString == "2"
                                {
                                    arrPublicContacts.removeAllObjects()
                                    arrPublicContacts.addObject(arrCircle.objectAtIndex(i))
                                }
                            }
                            dispatch_async(dispatch_get_main_queue())
                                {
                                    self.checkIn.contactLists.addObjectsFromArray(self.arrPrivateCircle as [AnyObject])
                                    self.checkIn.contactLists.addObjectsFromArray(self.arrPublicContacts as [AnyObject])
                                    if CheckIn.isAnyCheckInActive()
                                    {
                                        CheckIn.saveCurrentCheckInObject(self.checkIn)
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                    }
                                    self.tblView.reloadData()
                            }
                            SVProgressHUD.dismiss()
                        }
                        else if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                            SVProgressHUD.dismiss()
                            if dic.valueForKey(Structures.Constant.Message) != nil
                            {
                                
                                Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                                
                                
                                
                            }
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                    else if  type == WSRequestType.SendMailWithMedia
                    {
                        SVProgressHUD.dismiss()
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            var startOffsetFrequency : Double = 0
                            if self.checkIn.startTime.compare(NSDate()) == NSComparisonResult.OrderedDescending
                            {
                                startOffsetFrequency = self.checkIn.startTime.timeIntervalSinceDate(NSDate())
                            }
                            let nextConfirmation = NSDate(timeInterval: (startOffsetFrequency+(self.checkIn.frequency.doubleValue) * 60), sinceDate: NSDate())
                            var message = ""
                            var title = ""
                            if self.checkIn.status.rawValue == 0
                            {
                                title = NSString(format: NSLocalizedString(Utility.getKey("checkin_begin_at"),comment:"") , (Utility.timeFromDate(self.checkIn.startTime))) as String
                                message = ""
                            }
                            else
                            {
                                title = NSLocalizedString(Utility.getKey("checkin_is_now_active"),comment:"")
                                message =  NSString(format: NSLocalizedString(Utility.getKey("your_next_conf"),comment:"") , (Utility.timeFromDate(nextConfirmation))) as String
                            }
                            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                                self.backToPreviousScreen()
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
                SVProgressHUD.dismiss()
            }
            else
            {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func WSResponseEoor(error:NSError, ReqType type:WSRequestType)
    {
        SVProgressHUD.dismiss()
        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        
    }    
    
}