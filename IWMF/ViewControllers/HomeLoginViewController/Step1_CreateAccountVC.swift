//
//  Step1_CreateAccountVC.swift
//  IWMF
//
//  This class is used for display Step-1 of Create Account and display User Profile.
//
//

import UIKit

enum UserProfile : Int{
    case CreateAccount = 1
    case UpdateUser = 2
}

class Step1_CreateAccountVC: UIViewController,UITableViewDataSource,UITableViewDelegate,NextButtonProtocol,SelctedLanguageProtocol,FreelancerBtProtocol,PersonalDetailTextProtocol,TextViewTextChanged,ARPersonalDetailsTableView, ARFreelancerBtProtocol,CustomAlertViewDelegate,UserModalProtocol {
    var password1 : NSMutableString!
    var password2 : NSMutableString!
    var createAccntArr : NSMutableArray!
    var selectType : Int = 0
        var signOutpass : NSString!
    var signOutTextField : UITextField!
    @IBOutlet var btnInfo : UIButton!
    @IBOutlet var btnHome : UIButton!
    @IBOutlet weak var btnBarDone: UIBarButtonItem!
    @IBOutlet weak var btnBarCancel: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var activeTextField : UITextField!
    var isKeyboardEnable : Bool = false
    let tableFooteHeight : CGFloat = 110
    var freelancer = Bool()
    //  MARK:- Constraint Property
    @IBOutlet weak var verticleSpaceView: NSLayoutConstraint!
    @IBOutlet weak var textViewHeigth: NSLayoutConstraint!
    //  MARK:- View Property
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkInView: UIView!
    @IBOutlet var toolbar : UIToolbar!
    @IBOutlet weak var lblTitle: UILabel!
    var isIbuttonOpen : Bool!
    var devide : CGFloat!
    var arrPassword1 : NSMutableArray!
    var arrPassword2 : NSMutableArray!
    var isFromProfile : Bool!
    var emailRe : NSString!
    override func viewDidLoad() {
        
        
        Structures.Constant.appDelegate.userSignUpDetail = User()
        super.viewDidLoad()
        arrPassword1 = NSMutableArray()
        arrPassword2 = NSMutableArray()
        password1 = ""
        password2 = ""
        emailRe = ""
        devide = 1
        textView.selectable = false
        isIbuttonOpen = false
        isFromProfile = false
        
        self.lblTitle.font = Utility.setNavigationFont()
        freelancer = false
        
        
        createAccntArr = NSMutableArray()
        
        self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
        self.checkInView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)
        
        switch selectType
        {
        case UserProfile.CreateAccount.rawValue :
            
            var cell: NextFooterTableViewCell? = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.nextFooterCellIdentifier) as? NextFooterTableViewCell
            let arr : NSArray = NSBundle.mainBundle().loadNibNamed("NextFooterTableViewCell", owner: self, options: nil)
            cell = arr[0] as?  NextFooterTableViewCell
            cell?.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 80)
            cell?.nextBtn.addTarget(self, action: "nextButtonClicked", forControlEvents: .TouchUpInside)
            cell?.nextBtn.setTitle(NSLocalizedString(Utility.getKey("Next"),comment:""), forState: .Normal)
            tableView.tableFooterView = cell
            
            self.tableView.reloadData()
            
            //Load County List
            Structures.Constant.appDelegate.countryListUpdate()
            
            //New User Dict allocation
            Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.ListName] = NSLocalizedString(Utility.getKey("private_circle_name"),comment:"")
            Structures.Constant.appDelegate.dictSignUpCircle[Structures.User.CircleType] = "1"
            Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.DefaultStatus] = "1"
            Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] = NSMutableArray()
            Structures.Constant.appDelegate.dictSelectToUpdate = Structures.Constant.appDelegate.dictSignUpCircle
            
            
            isFromProfile = false
            self.lblTitle.text = NSLocalizedString(Utility.getKey("create_account_header"),comment:"")
            
            if let path = NSBundle.mainBundle().pathForResource("Step1_CreateAccount", ofType: "plist")
            {
                createAccntArr = NSMutableArray(contentsOfFile: path)
                let arrTemp : NSMutableArray = NSMutableArray(array: createAccntArr)
                
                for (index, element) in arrTemp.enumerate() {
                    
                    if var innerDict = element as? Dictionary<String, AnyObject> {
                        
                        let strTitle = innerDict["Title"] as! String!
                        if strTitle.characters.count != 0
                        {
                            let strPlaceholder = innerDict["Placeholder"] as! NSString!
                            
                            if strPlaceholder != nil
                            {
                                if strPlaceholder != "Please describe"
                                {
                                    innerDict["Placeholder"] = NSLocalizedString(Utility.getKey(strTitle as String),comment:"")
                                }
                            }
                            let strOptionTitle = innerDict["OptionTitle"] as! NSString!
                            if strOptionTitle != nil
                            {
                                if strOptionTitle == "Add"
                                {
                                    innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("add"),comment:"")
                                }
                                else if strOptionTitle == "(Minimum 8 characters)"
                                {
                                    innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("PassHint"),comment:"")
                                }
                            }
                            
                            innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle as String),comment:"")
                            self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                        else
                        {
                            let strPlaceholder = innerDict["Placeholder"] as! String!
                            
                            if strPlaceholder != nil
                            {
                                if strPlaceholder == "Please describe"
                                {
                                    innerDict["Placeholder"] = NSLocalizedString(Utility.getKey(strPlaceholder),comment:"")
                                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            break
        case UserProfile.UpdateUser.rawValue :
            
            isFromProfile = true
            Structures.Constant.appDelegate.userSignUpDetail = Structures.Constant.appDelegate.userSignUpDetail.getLoggedInUser()!
            
            self.lblTitle.text = NSLocalizedString(Utility.getKey("profile"),comment:"")
            
            if let path = NSBundle.mainBundle().pathForResource("UpdateUser", ofType: "plist")
            {
                createAccntArr = NSMutableArray(contentsOfFile: path)
                
                let arrTemp : NSMutableArray = NSMutableArray(array: createAccntArr)
                
                for (index, element) in arrTemp.enumerate() {
                    if var innerDict = element as? Dictionary<String, AnyObject> {
                        let strTitle = innerDict["Title"] as! String!
                        if strTitle.characters.count != 0
                        {
                            
                            let strOptionTitle = innerDict["OptionTitle"] as! NSString!
                            
                            if strOptionTitle != nil
                            {
                                if strOptionTitle == "Add"
                                {
                                    innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("add"),comment:"")
                                }
                                else if strOptionTitle == "Update"
                                {
                                    innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Update"),comment:"")
                                }
                                else if strOptionTitle == "Edit"
                                {
                                    innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                                }
                                else if strOptionTitle == "Choose"
                                {
                                    innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Choose"),comment:"")
                                }
                                if strOptionTitle == "Version"
                                {
                                    innerDict["OptionTitle"] = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String!
                                }
                            }
                            
                            innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle as String),comment:"")
                            self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                    }
                }
            }
            self.getUserData()
            break
        default :
            isFromProfile = false
        }
        
        self.tableView.registerNib(UINib(nibName: "FreelancerTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.FreelancerCellIndentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARPersonalDetailsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARPersonalDetailsTableViewCellIndetifier)
        
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
        
        self.tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "PersonalDetailsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.PersonalDetailCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "LocationListingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.LocationListingCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARFreelancerTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARFreelancerTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARLocationListingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "HelpTextViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
        if isFromProfile == true
        {
            
            Structures.Constant.appDelegate.userSignUpDetail = Structures.Constant.appDelegate.userSignUpDetail.getLoggedInUser()!
            self.getUserData()
        }
        switch selectType
        {
        case UserProfile.CreateAccount.rawValue :
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
            break
        case UserProfile.UpdateUser.rawValue :
            self.tableView.reloadData()
            break
        default :
            print("")
        }
        self.setUpUpperInfoView()
        self.checkInView.hidden = true
        
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnHome.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Right
            btnBarCancel.title = NSLocalizedString(Utility.getKey("done"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
        }
        else
        {
            btnHome.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Left
            btnBarCancel.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("done"),comment:"")
        }
    }
    override func viewWillDisappear(animated: Bool)
    {
        if activeTextField != nil
        {
            activeTextField.resignFirstResponder()
        }
        self.view.endEditing(true)
        self.tableView.contentInset = UIEdgeInsetsZero
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        
        switch selectType
        {
        case UserProfile.CreateAccount.rawValue :
            
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
            break
        default :
            print("")
        }
        
    }
    func keyboardWillShow(notification : NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.size.height + 20 , 0.0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
                var rect : CGRect = self.tableView.frame
                rect.size.height -= keyboardSize.size.height
                if (!CGRectContainsPoint(rect, self.activeTextField.frame.origin) ) {
                    self.tableView.scrollRectToVisible(self.activeTextField.frame, animated: true)
                }
            })
        }
    }
    func keyboardWillHide(notification : NSNotification)
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tableView.contentInset = UIEdgeInsetsZero
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    MARK :- animation methods
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
    func backToPreviousScreen(){
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
        self.setIBtnView()
    }
    
    func setIBtnView(){
        
        if isIbuttonOpen == false
        {
            self.view.bringSubviewToFront(self.checkInView)
            self.checkInView.hidden = false
            isIbuttonOpen = true
            UIView.animateWithDuration(0.80, delay: 0.1, options: .CurveEaseOut , animations:
                {
                    self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                    self.checkInView.frame.origin.y += (UIScreen.mainScreen().bounds.size.height)
                }, completion: nil)
        }
        else
        {
            isIbuttonOpen = false
            UIView.animateWithDuration(0.80, delay: 0.1, options:  .CurveEaseInOut , animations:
                {
                    self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                    self.checkInView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)
                    
                }, completion: {
                    finished in
                    self.setUpUpperInfoView()
                    self.checkInView.hidden = true
                    self.view.bringSubviewToFront(self.tableView)
                    
            })
        }
    }
    
    func setUpUpperInfoView()
    {
        self.textView.text = NSLocalizedString(Utility.getKey("Profile - i button"),comment:"")
    }
    
    @IBAction func btnToolbarDoneClicked(sender:AnyObject)
    {
        self.view.endEditing(true);
        self.activeTextField.resignFirstResponder()
    }
    @IBAction func btnToolbarCancelClicked(sender:AnyObject)
    {
        self.view.endEditing(true);
        self.activeTextField.resignFirstResponder()
    }
    func getUserData()
    {
        let arrTemp : NSArray = NSArray(array: self.createAccntArr)
        for (index, element) in arrTemp.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject>
            {
                let iden = innerDict["Identity"] as! NSString!
                if iden == "UpdatedUsername"{
                    innerDict["Title"] = (Structures.Constant.appDelegate.userSignUpDetail.firstName as NSString as String) + " " + (Structures.Constant.appDelegate.userSignUpDetail.lastName as NSString as String)
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "SelectedJobTitle"{
                    innerDict["Title"] = Structures.Constant.appDelegate.userSignUpDetail.jobTitle
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "Affiliation"{
                    if Structures.Constant.appDelegate.userSignUpDetail.affiliation.length != 0
                    {
                        innerDict["Title"] = Structures.Constant.appDelegate.userSignUpDetail.affiliation
                        self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                    else
                    {
                        innerDict["Title"] = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                        self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
                if iden == "Freelancer"{
                    self.freelancer = Structures.Constant.appDelegate.userSignUpDetail.isFreeLancer as Bool
                }
                if iden == "CountryOfOrigin"{
                    innerDict["Title"] = Utility.findCountryFromCode(Structures.Constant.appDelegate.userSignUpDetail.origin)
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "CountryWhereWorking"{
                    innerDict["Title"] = Utility.findCountryFromCode(Structures.Constant.appDelegate.userSignUpDetail.working)
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                }
            }
        }
        self.tableView.reloadData()
    }
    //MARK : - NextButtonProtocol
    //Updating user
    func nextButtonClicked() {
        
        self.view.endEditing(true)
        
        if selectType == 1{
            registerUser()
        }
        if selectType == 2{
            SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("updating_user"),comment:""), maskType: 4)
            User.registerUser(NSMutableDictionary(dictionary:User.dictToUpdate(Structures.Constant.appDelegate.prefrence.DeviceToken, user: Structures.Constant.appDelegate.userSignUpDetail)),isNewUser : false)
            User.sharedInstance.delegate = self
        }
    }
    func commonUserResponse(wsType : WSRequestType ,dict : NSDictionary, isSuccess : Bool)
    {
        if wsType == WSRequestType.SignOut{
            if isSuccess
            {
                SVProgressHUD.dismiss()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    CheckIn.removeActiveCheckInObject()
                    if Structures.Constant.appDelegate.prefrence.LanguageSelected != nil
                    {
                        if Structures.Constant.appDelegate.prefrence.LanguageSelected == true
                        {
                            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                            let rootViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
                            navigationController.viewControllers = [rootViewController]
                            Structures.Constant.appDelegate.window?.rootViewController = navigationController
                        }
                    }
                })
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    if (Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Status) as! NSString).isEqualToString("3"){
                        if Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) != nil
                        {
                            
                            Utility.showLogOutAlert((Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) as? String!)!, view: self)
                            
                            
                        }
                    }else{
                        if Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) != nil
                        {
                            Utility.showAlertWithTitle(Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) as! String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                        }
                    }
                })
            }
        }else if wsType == WSRequestType.UpdateUser{
            if isSuccess
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let homeViewScreen : HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
                    self.showViewController(homeViewScreen, sender: nil)
                    SVProgressHUD.dismiss()
                })
            }
            else
            {
                SVProgressHUD.dismiss()
            }
        }
        else if wsType == WSRequestType.CheckUserNameEmail{
            if isSuccess{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        Structures.Constant.appDelegate.contactScreensFrom = ContactsFrom.CreateAccount
                        self.performSegueWithIdentifier("CreateContactListPush", sender: nil);
                        SVProgressHUD.dismiss()
                    })
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
            }
        }
    }
    
    
    //MARK : - FreelancerButtonProtocol
    func freelancerButtonClicked(isSelected: NSNumber) {
        Structures.Constant.appDelegate.userSignUpDetail.isFreeLancer = isSelected
        if freelancer == true
        {
            freelancer = false
        }
        else
        {
            freelancer = true
        }
    }
    func textChanged(changedText: NSString) {
        Structures.Constant.appDelegate.userSignUpDetail.affiliation = changedText
        changeValueInMainCheckInArray(changedText, identity: "Affiliation")
    }
    func jobTitleSelcted(selectedText : String){
        Structures.Constant.appDelegate.userSignUpDetail.jobTitle = selectedText
        changeValueInMainCheckInArray(selectedText, identity: "SelectedJobTitle")
    }
    func countryOfOrigin(selectedText: String, selectedCode: String) {
        Structures.Constant.appDelegate.userSignUpDetail.origin = selectedCode
        changeValueInMainCheckInArray(selectedText, identity: "CountryOfOrigin")
    }
    func countryWhereWorking(selectedText: String, selectedCode: String) {
        Structures.Constant.appDelegate.userSignUpDetail.working = selectedCode
        changeValueInMainCheckInArray(selectedText, identity: "CountryWhereWorking")
    }
    // MARK : - DetailTextFieldProtocol
    func textFieldShouldChangeCharactersInRange(textField: UITextField, tableViewCell: PersonalDetailsTableViewCell, identity: NSString, level: NSString, range: NSRange, replacementString string: String) {
        if identity == "Password" || identity == "NewPassword"
        {
            if  textField.text!.characters.count == range.location
            {
                arrPassword1.addObject(string)
            }
            else
            {
                arrPassword1.removeLastObject()
            }
            textField.text = hideTextInTextFieldExceptOne(textField.text) as String
        }
        else if identity == "Re-enterPassword" || identity == "ConfirmPassword"
        {
            if  textField.text!.characters.count == range.location
            {
                arrPassword2.addObject(string)
            }
            else
            {
                arrPassword2.removeLastObject()
            }
            textField.text = hideTextInTextFieldExceptOne(textField.text) as String
        }
        
    }
    func textFieldStartEditing(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString){
        textStartEditing(textField, identity: identity)
    }
    func textFieldEndEditing(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString){
        isValidateField(textField, identity: identity, isEndEditing: true)
    }
    func textFieldShouldReturn(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        if textField.returnKeyType == UIReturnKeyType.Next
        {
            if isValidateField(textField, identity: identity, isEndEditing: false)
            {
                if let cell: PersonalDetailsTableViewCell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: Int(tableViewCell.indexPath.row+1), inSection: 0)) as? PersonalDetailsTableViewCell
                {
                    cell.detailstextField.becomeFirstResponder()
                }
                else
                {
                    self.view.endEditing(true);
                    self.tableView.contentInset = UIEdgeInsetsZero
                    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
                }
            }
        }
        else
        {
            self.view.endEditing(true);
            self.tableView.contentInset = UIEdgeInsetsZero
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
    func textStartEditing(textField : UITextField,  identity : NSString)
    {
        if identity == "Password" || identity == "NewPassword"
        {
            arrPassword1 = NSMutableArray()
            textField.text = ""
            password1 = ""
        }
        else if identity == "Re-enterPassword" || identity == "ConfirmPassword"
        {
            arrPassword2 = NSMutableArray()
            textField.text = ""
            password2 = ""
        }
        textField.inputAccessoryView = toolbar
        self.activeTextField = textField
        
    }
    func hideTextInTextFieldExceptOne(text: NSString!) -> NSString
    {
        var len : Int = 0
        len = text.length
        var test : NSString = ""
        for (var i : Int = 0; i < len ; i++ )
        {
            let range : NSRange = NSMakeRange(i, 1)
            test = text.stringByReplacingCharactersInRange(range, withString: "●")
        }
        return test
    }
    //MARK:- Arabic
    func textFieldShouldChangeCharactersInRange1(textField: UITextField, tableViewCell: ARPersonalDetailsTableViewCell, identity: NSString, level: NSString, range: NSRange, replacementString string: String) {
        if identity == "Password" || identity == "NewPassword"
        {
            if  textField.text!.characters.count == range.location
            {
                arrPassword1.addObject(string)
            }
            else
            {
                arrPassword1.removeLastObject()
            }
            textField.text = hideTextInTextFieldExceptOne(textField.text) as String
        }
        else if identity == "Re-enterPassword" || identity == "ConfirmPassword"
        {
            if  textField.text!.characters.count == range.location
            {
                arrPassword2.addObject(string)
            }
            else
            {
                arrPassword2.removeLastObject()
            }
            textField.text = hideTextInTextFieldExceptOne(textField.text) as String
        }
    }
    func textFieldStartEditing1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        textStartEditing(textField, identity: identity)
    }
    func textFieldEndEditing1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString){
        isValidateField(textField, identity: identity, isEndEditing: true)
    }
    func textFieldShouldReturn1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        if textField.returnKeyType == UIReturnKeyType.Next
        {
            if isValidateField(textField, identity: identity, isEndEditing: false)
            {
                if let cell: ARPersonalDetailsTableViewCell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: Int(tableViewCell.indexPath.row+1), inSection: 0)) as? ARPersonalDetailsTableViewCell
                {
                    cell.detailstextField.becomeFirstResponder()
                }
                else
                {
                    self.view.endEditing(true);
                    self.tableView.contentInset = UIEdgeInsetsZero
                    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
                }
            }
        }
        else
        {
            self.view.endEditing(true);
            self.tableView.contentInset = UIEdgeInsetsZero
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
        }
    }
    func isValidateField(textField : UITextField, identity : NSString, isEndEditing: Bool) -> Bool
    {
        var isValidInfo : Bool = true
        var strTitle : String = ""
        var strButtonText : String = NSLocalizedString(Utility.getKey("Ok"),comment:"")
        
        if identity == "Username"
        {
            if  !Utility.isValidUsername(textField.text!)
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Invalid_username"),comment:"")
            }
            if textField.text!.characters.count > 26
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_25_Character"),comment:"")
            }
            Structures.Constant.appDelegate.userSignUpDetail.userName = textField.text!
        }
        else if identity == "Email"
        {
            if  !Utility.isValidEmail(textField.text!)
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("please_enter_valid_email"),comment:"")
            }
            if textField.text!.characters.count > 100
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_100_Character"),comment:"")
            }
            Structures.Constant.appDelegate.userSignUpDetail.email = textField.text
        }
        else if identity == "ReEnterEmail"
        {
            
            if Structures.Constant.appDelegate.userSignUpDetail.email != textField.text
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Email_notmatch"),comment:"")
                emailRe = ""
            }
            emailRe = textField.text
        }else if identity == "Firstname"{
            if textField.text!.characters.count > 26{
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_25_Character"),comment:"")
            }
            Structures.Constant.appDelegate.userSignUpDetail.firstName = textField.text
        }
        else if identity == "Lastname"
        {
            if textField.text!.characters.count > 26{
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_25_Character"),comment:"")
            }
            Structures.Constant.appDelegate.userSignUpDetail.lastName = textField.text
        }
        else if identity == "Phone"
        {
            if  !Utility.isValidPhone(textField.text!)
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("please_enter_valid_phone"),comment:"")
            }
            Structures.Constant.appDelegate.userSignUpDetail.phone = textField.text
        }
        else if identity == "Please describe"
        {
            if Structures.Constant.appDelegate.userSignUpDetail.gender_type == "3"
            {
                Structures.Constant.appDelegate.userSignUpDetail.gender = textField.text
            }
        }
        else if identity == "Password"
        {
            if textField.text!.characters.count > 0
            {
                password1 = ""
                if arrPassword1.count > 0
                {
                    for(var i : Int  = 0; i < arrPassword1.count; i++)
                    {
                        password1.appendString(arrPassword1.objectAtIndex(i) as! String)
                    }
                }
                if !Utility.isValidPassword(password1 as String, strUserName: Structures.Constant.appDelegate.userSignUpDetail.userName as String)//(password1 as String)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showPasswordAlert()
                        textField.text = nil
                        textField.resignFirstResponder()
                        self.view.endEditing(true)
                    })
                    return false
                }
                Structures.Constant.appDelegate.userSignUpDetail.password = password1
            }
        }
        else if identity == "Re-enterPassword"
        {
            password2 = ""
            if arrPassword2.count > 0
            {
                for(var i : Int  = 0; i < arrPassword2.count; i++)
                {
                    password2.appendString((arrPassword2.objectAtIndex(i) as! String) as String)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if isEndEditing{
                    self.view.endEditing(true);
                    let newContentOffset : CGPoint = CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.height)
                    self.tableView.setContentOffset(newContentOffset, animated: true)
                }
            })
            
            if password2.length > 1
            {
                if (password2 !=  Structures.Constant.appDelegate.userSignUpDetail.password)
                {
                    isValidInfo = false
                    strTitle = NSLocalizedString(Utility.getKey("please_enter_valid_phone"),comment:"")
                    strButtonText = NSLocalizedString(Utility.getKey("try_again"),comment:"")
                    self.password2 = ""
                    self.arrPassword2 = NSMutableArray()
                }
            }
        }
        else if identity == "Affiliation"
        {
            Structures.Constant.appDelegate.userSignUpDetail.affiliation = textField.text
            
        }
        
        if isValidInfo == false {
            Utility.showAlertWithTitle(strTitle, strMessage: "", strButtonTitle: strButtonText, view: self)
            textField.text = nil
            textField.resignFirstResponder()
            self.view.endEditing(true)
            return isValidInfo
        }
        return true
    }
    
    func validateUser() -> Bool{
        
        var isValidInfo : Bool = true
        var strTitle : String = ""
        
        if Structures.Constant.appDelegate.userSignUpDetail.userName.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_username"),comment:"")
        }else if Structures.Constant.appDelegate.userSignUpDetail.email.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_email"),comment:"")
        }
        else if Structures.Constant.appDelegate.userSignUpDetail.email != emailRe {
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("Email_notmatch"),comment:"")
        }else if Structures.Constant.appDelegate.userSignUpDetail.firstName.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_firstname"),comment:"")
        }else if Structures.Constant.appDelegate.userSignUpDetail.lastName.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_lastname"),comment:"")
        }else if Structures.Constant.appDelegate.userSignUpDetail.phone.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_phone_no"),comment:"")
        }
        else if Structures.Constant.appDelegate.userSignUpDetail.gender == ""{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("select_Gender"),comment:"")
        }
        else if Structures.Constant.appDelegate.userSignUpDetail.jobTitle.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_select_job_title"),comment:"")
        }else if Structures.Constant.appDelegate.userSignUpDetail.origin.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_select_country_of_origin"),comment:"")
        }else if Structures.Constant.appDelegate.userSignUpDetail.working.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_select_country_of_working"),comment:"")
        }else if password2 !=  Structures.Constant.appDelegate.userSignUpDetail.password {
            password2 = ""
            arrPassword2 = NSMutableArray()
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("Password_notmatch"),comment:"")
        }
        else if Structures.Constant.appDelegate.userSignUpDetail.password.length == 0 {
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_password"),comment:"")
        }
        
        if isValidInfo == false {
            Utility.showAlertWithTitle(strTitle, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            return isValidInfo
        }
        return true
    }
    func registerUser(){
        
        var validUser : Bool = false
        validUser = validateUser()
        if validUser == false
        {
            return
        }
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("please_wait"),comment:""), maskType: 4)
        User.checkUsernameEmail(NSMutableDictionary(dictionary:User.dictToCheckUsernameEmail(Structures.Constant.appDelegate.userSignUpDetail.userName, email: Structures.Constant.appDelegate.userSignUpDetail.email)))
        User.sharedInstance.delegate = self
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "CreateContactListPush"
        {
            let vc : Step2_CreateAccountVC = segue.destinationViewController as! Step2_CreateAccountVC
            vc.isEditContactList = false
            Structures.Constant.appDelegate.contactScreensFrom =  ContactsFrom.CreateAccount
            vc.circle =  Circle(name:"Private", type:.Private,contactList:[]);
        }
    }
    
    func changeValueInMainCheckInArray(newValue : NSString, identity : NSString){
        for (index, element) in self.createAccntArr.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == identity{
                    innerDict["Value"] = newValue
                    if iden == "SelectedLanguage" || iden == "SelectedJobTitle" || iden == "CountryOfOrigin" || iden == "CountryWhereWorking"{
                        innerDict["Title"] = newValue
                    }
                    if iden == "Affiliation"{
                        innerDict["Title"] = newValue
                        innerDict["value"] = newValue
                        innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Update"),comment:"")
                    }
                    
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }
    
    //MARK:- Start TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.createAccntArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if  self.createAccntArr[indexPath.row]["CellIdentifier"] as? NSString == Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier
        {
            let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier) as! HelpTextViewCell!
            cell.txtHelpTextView.frame = CGRectMake(cell.txtHelpTextView.frame.origin.x, cell.txtHelpTextView.frame.origin.y, tableView.frame.size.width - 60, cell.txtHelpTextView.frame.size.height)
            
            cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("about_reporta_p0assword1"),comment:"") , string: NSLocalizedString(Utility.getKey("about_reporta_password1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("about_reporta_password2"),comment:""), fontName: cell.txtHelpTextView.font)
            
            cell.txtHelpTextView.sizeToFit()
            return cell.txtHelpTextView.frame.size.height + 70
        }
        
        let kRowHeight = self.createAccntArr[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let kCellIdentifier = self.createAccntArr[indexPath.row]["CellIdentifier"] as! String
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "TitleTableViewCellIdentifier"
        {
            if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARTitleTableViewCellIdentifier") as? ARTitleTableViewCell
            {
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! String!
                cell.lblTitle.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                if self.createAccntArr[indexPath.row]["Identity"] as! NSString == "Version"
                {
                    cell.lblDetail.textColor =  UIColor.blackColor()
                }
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell
            {
                
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! String!
                cell.lblTitle.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                if self.createAccntArr[indexPath.row]["Identity"] as! NSString == "Version"
                {
                    cell.lblDetail.textColor =  UIColor.blackColor()
                }
                cell.intialize()
                return cell
            }
        }
        
        if let cell: TitleTableViewCell2 = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell2
        {
            cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! String!
            cell.lblTitle.text = self.createAccntArr[indexPath.row]["Title"] as! String!
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
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "DetailTableViewCellIdentifier"
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARDetailTableViewCellIdentifier") as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! String!
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.createAccntArr[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.createAccntArr[indexPath.row]["Type"] as! Int!
                cell.identity = self.createAccntArr[indexPath.row]["Identity"] as! String!
                cell.intialize()
                
                if cell.isSelectedValue == true
                {
                    cell.ivRight.image = UIImage(named:"ok.png")!
                }
                return cell
            }
        }
        else
        {
            
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell
            {
                
                cell.lblSubDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.createAccntArr[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.createAccntArr[indexPath.row]["Type"] as! Int!
                cell.identity = self.createAccntArr[indexPath.row]["Identity"] as! String!
                cell.intialize()
                
                if cell.isSelectedValue == true
                {
                    cell.ivRight.image = UIImage(named:"ok.png")!
                }
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "LocationListingCellIdentifier"
        {
            if let cell: ARLocationListingCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier) as? ARLocationListingCell
            {
                cell.value = self.createAccntArr[indexPath.row]["Value"] as! NSString!
                cell.detail = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
            
        }
        else
        {
            if let cell: LocationListingCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? LocationListingCell {
                cell.value = self.createAccntArr[indexPath.row]["Value"] as! NSString!
                cell.detail = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "FreelancerCellIndentifier"
        {
            if let cell: ARFreelancerTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARFreelancerTableViewCellIdentifier) as? ARFreelancerTableViewCell {
                cell.isSelectedValue = self.freelancer
                cell.initialize()
                if isFromProfile == true
                {
                    cell.userInteractionEnabled = false
                }
                else
                {
                    cell.delegate = self
                }
                return cell
            }
            
        }
        else
        {
            if let cell: FreelancerTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? FreelancerTableViewCell
            {
                cell.isSelectedValue = self.freelancer
                cell.initialize()
                if isFromProfile == true
                {
                    cell.userInteractionEnabled = false
                }
                else
                {
                    cell.delegate = self
                }
                return cell
            }
            
        }
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "PersonalDetailCellIdentifier"
        {
            if let cell: ARPersonalDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARPersonalDetailsTableViewCellIndetifier") as? ARPersonalDetailsTableViewCell {
                cell.detailstextField.placeholder = self.createAccntArr[indexPath.row]["Placeholder"] as! String!
                cell.detailstextField.accessibilityIdentifier = self.createAccntArr[indexPath.row]["Identity"] as! String!
                cell.identity = self.createAccntArr[indexPath.row]["Identity"] as! NSString!
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
                cell.delegate = self
                if isFromProfile == true
                {
                    cell.userInteractionEnabled = false
                }
                if self.selectType == 1
                {
                    cell.indexPath = indexPath
                    if cell.identity == "Username" {
                        cell.value = Structures.Constant.appDelegate.userSignUpDetail.userName as String
                    }else if cell.identity == "Email" {
                        cell.value = Structures.Constant.appDelegate.userSignUpDetail.email as String
                    }else if cell.identity == "ReEnterEmail"{
                        cell.value = self.emailRe as String
                    }else if cell.identity == "Firstname"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.firstName as String
                    }else if cell.identity == "Lastname"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.lastName as String
                    }else if cell.identity == "Phone"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.phone as String
                    }else if cell.identity == "Password"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.password as String
                    }else if cell.identity == "Re-enterPassword"{
                        cell.value =  password2 as String
                    }else if cell.identity == "Please describe"{
                        if Structures.Constant.appDelegate.userSignUpDetail.gender_type == "3"
                        {
                            cell.userInteractionEnabled = true
                            cell.value =  Structures.Constant.appDelegate.userSignUpDetail.gender as String
                        }
                        else
                        {
                            cell.userInteractionEnabled = false
                        }
                    }
                    else if cell.identity == "Affiliation"{
                        if isFromProfile == true
                        {
                            cell.detailstextField.textColor = UIColor.grayColor()
                        }
                        cell.value = Structures.Constant.appDelegate.userSignUpDetail.affiliation as String
                    }
                }
                cell.initialize()
                return cell
            }
        }
        else
        {
            
            if let cell: PersonalDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? PersonalDetailsTableViewCell {
                cell.detailstextField.placeholder = self.createAccntArr[indexPath.row]["Placeholder"] as! String!
                cell.detailstextField.accessibilityIdentifier = self.createAccntArr[indexPath.row]["Identity"] as! String!
                cell.identity = self.createAccntArr[indexPath.row]["Identity"] as! NSString!
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
                cell.delegate = self
                if isFromProfile == true
                {
                    cell.userInteractionEnabled = false
                }
                if self.selectType == 1
                {
                    cell.indexPath = indexPath
                    if cell.identity == "Username" {
                        cell.value = Structures.Constant.appDelegate.userSignUpDetail.userName as String
                    }else if cell.identity == "Email" {
                        cell.value = Structures.Constant.appDelegate.userSignUpDetail.email as String
                    }else if cell.identity == "ReEnterEmail"{
                        cell.value = emailRe as String
                    }else if cell.identity == "Firstname"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.firstName as String
                    }else if cell.identity == "Lastname"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.lastName as String
                    }else if cell.identity == "Phone"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.phone as String
                    }else if cell.identity == "Password"{
                        cell.value =  Structures.Constant.appDelegate.userSignUpDetail.password as String
                    }else if cell.identity == "Re-enterPassword"{
                        cell.value =  password2 as String
                    }else if cell.identity == "Please describe"{
                        if Structures.Constant.appDelegate.userSignUpDetail.gender_type == "3"
                        {
                            cell.userInteractionEnabled = true
                            cell.value =  Structures.Constant.appDelegate.userSignUpDetail.gender as String
                        }
                        else
                        {
                            cell.userInteractionEnabled = false
                        }
                    }
                    else if cell.identity == "Affiliation"{
                        cell.value = Structures.Constant.appDelegate.userSignUpDetail.affiliation as String
                    }
                }
                cell.initialize()
                return cell
            }
        }
        
        if let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? HelpTextViewCell
        {
            cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("about_reporta_password1"),comment:"") , string: NSLocalizedString(Utility.getKey("about_reporta_password1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("about_reporta_password2"),comment:""), fontName: cell.txtHelpTextView.font)
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.txtHelpTextView.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.txtHelpTextView.textAlignment = NSTextAlignment.Left
            }
            return cell
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "selectJobTitle"{
            selectJobTitle(self.createAccntArr[indexPath.row]["Title"] as! String)
        }
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "selectCountryOfOrigin"{
            selectCountryOfOrigin(self.createAccntArr[indexPath.row]["Title"] as! String, code: Structures.Constant.appDelegate.userSignUpDetail.origin as String)
        }
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "selectCountryOfWorking"{
            selectCountryOfWorking(self.createAccntArr[indexPath.row]["Title"] as! String, code: Structures.Constant.appDelegate.userSignUpDetail.working as String)
        }
        
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "addAffiliation"{
        }
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "editContactDetail"{
            editContactDetail()
        }
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "signOutUser"
        {
            self.signOut()
        }
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "selectGender"{
            updateGender(indexPath)
        }
        if  self.createAccntArr[indexPath.row]["Method"] as! NSString! == "showLegal"{
            showLegalClicked()
        }
    }
    //MARK:- End
    func selectJobTitle(text : String!){
        let selectLanguageScreen : SelectLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectLanguageViewController") as! SelectLanguageViewController
        selectLanguageScreen.delegate = self
        selectLanguageScreen.selectedText = text
        selectLanguageScreen.selectType = 1
        selectLanguageScreen.isFromProfile = 0
        showViewController(selectLanguageScreen, sender: self.view)
    }
    func selectCountryOfOrigin(text : String!, code : String!){
        let selectLanguageScreen : SelectLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectLanguageViewController") as! SelectLanguageViewController
        selectLanguageScreen.delegate = self
        selectLanguageScreen.selectedText = text
        selectLanguageScreen.selectedCode = code
        selectLanguageScreen.selectType = 2
        selectLanguageScreen.isFromProfile = 0
        showViewController(selectLanguageScreen, sender: self.view)
    }
    func selectCountryOfWorking(text : String!, code : String!){
        let selectLanguageScreen : SelectLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectLanguageViewController") as! SelectLanguageViewController
        selectLanguageScreen.delegate = self
        selectLanguageScreen.selectedText = text
        selectLanguageScreen.selectedCode = code
        selectLanguageScreen.selectType = 3
        selectLanguageScreen.isFromProfile = 0
        showViewController(selectLanguageScreen, sender: self.view)
    }
    func editContactDetail(){
        let editProfile : EditProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        showViewController(editProfile, sender: self.view)
    }
    func showLegalClicked() {
        let agreetermsScreen : AgreeTermsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AgreeTermsViewController") as! AgreeTermsViewController
        agreetermsScreen.type = 1;
        showViewController(agreetermsScreen, sender: self.view)
    }
    func updateGender(index: AnyObject)
    {
        let myindexPath : NSIndexPath = index as! NSIndexPath
        
        let dict1 : NSMutableDictionary = createAccntArr.objectAtIndex(myindexPath.row).mutableCopy() as! NSMutableDictionary
        
        if myindexPath.row == 10
        {
            dict1.setObject(1, forKey: "IsSelected")
            Structures.Constant.appDelegate.userSignUpDetail.gender =  createAccntArr.objectAtIndex(myindexPath.row).valueForKey("Title") as! NSString
            Structures.Constant.appDelegate.userSignUpDetail.gender_type = "1"
            
            let dict2 : NSMutableDictionary = createAccntArr.objectAtIndex(11).mutableCopy() as! NSMutableDictionary
            let dict3 : NSMutableDictionary = createAccntArr.objectAtIndex(12).mutableCopy() as! NSMutableDictionary
            
            dict2.setObject(0, forKey: "IsSelected")
            dict3.setObject(0, forKey: "IsSelected")
            
            
            createAccntArr.replaceObjectAtIndex(10, withObject: dict1)
            createAccntArr.replaceObjectAtIndex(11, withObject: dict2)
            createAccntArr.replaceObjectAtIndex(12, withObject: dict3)
            
            
        }
        else if myindexPath.row == 11
        {
            
            dict1.setObject(1, forKey: "IsSelected")
            Structures.Constant.appDelegate.userSignUpDetail.gender =  createAccntArr.objectAtIndex(myindexPath.row).valueForKey("Title") as! NSString
            Structures.Constant.appDelegate.userSignUpDetail.gender_type = "2"
            
            let dict2 : NSMutableDictionary = createAccntArr.objectAtIndex(10).mutableCopy() as! NSMutableDictionary
            let dict3 : NSMutableDictionary = createAccntArr.objectAtIndex(12).mutableCopy() as! NSMutableDictionary
            
            dict2.setObject(0, forKey: "IsSelected")
            dict3.setObject(0, forKey: "IsSelected")
            
            createAccntArr.replaceObjectAtIndex(10, withObject: dict2)
            createAccntArr.replaceObjectAtIndex(11, withObject: dict1)
            createAccntArr.replaceObjectAtIndex(12, withObject: dict3)
        }
        else if myindexPath.row == 12
        {
            dict1.setObject(1, forKey: "IsSelected")
            
            Structures.Constant.appDelegate.userSignUpDetail.gender =   createAccntArr.objectAtIndex(myindexPath.row + 1).valueForKey("Title") as! NSString
            Structures.Constant.appDelegate.userSignUpDetail.gender_type = "3"
            
            let dict2 : NSMutableDictionary = createAccntArr.objectAtIndex(10).mutableCopy() as! NSMutableDictionary
            let dict3 : NSMutableDictionary = createAccntArr.objectAtIndex(11).mutableCopy() as! NSMutableDictionary
            
            
            dict2.setObject(0, forKey: "IsSelected")
            dict3.setObject(0, forKey: "IsSelected")
            
            createAccntArr.replaceObjectAtIndex(10, withObject: dict2)
            createAccntArr.replaceObjectAtIndex(11, withObject: dict3)
            createAccntArr.replaceObjectAtIndex(12, withObject: dict1)
        }
        self.tableView.reloadData()
    }
    
    func signOut(){
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("logging_out"),comment:""), maskType: 4)
        User.signOutUser(NSMutableDictionary(dictionary:User.dictForSignOut()))
        User.sharedInstance.delegate = self
    }
    //MARK:- Custom Alert Delegate Methods
    func showPasswordAlert()
    {
        let alertView = CustomAlertView()
        alertView.containerView = Utility.createContainerView(NSLocalizedString(Utility.getKey("password_alert_message"),comment:"") as String, titelText: NSLocalizedString(Utility.getKey("password_alert_title"),comment:"") as String, isArabic: Structures.Constant.appDelegate.isArabic)
        alertView.delegate = self
        alertView.buttonTitles = [
            NSLocalizedString(Utility.getKey("Ok"),comment:"")
        ]
        alertView.onButtonTouchUpInside = { (alertView: CustomAlertView, buttonIndex: Int) -> Void in
        }
        alertView.show()
    }
    func customAlertViewButtonTouchUpInside(alertView: CustomAlertView, buttonIndex: Int) {
        alertView.close()
    }
}
