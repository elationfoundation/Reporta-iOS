//
//  EditProfileViewController.swift
//  IWMF
//
// This class is used for Edit Profile.
//
//

import UIKit

class EditProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,PersonalDetailTextProtocol,ARPersonalDetailsTableView,ARFreelancerBtProtocol,FreelancerBtProtocol,NextButtonProtocol,SelctedLanguageProtocol,TextViewTextChanged,CustomAlertViewDelegate,WSClientDelegate,UserModalProtocol{
    @IBOutlet weak var tableView: UITableView!
    var freelancer = Bool()
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var editProfileArray : NSMutableArray!
    var userDetail = User()
    var activeTextField : UITextField!
    @IBOutlet var toolbar : UIToolbar!
    @IBOutlet weak var btnBarDone: UIBarButtonItem!
    @IBOutlet weak var btnBarCancel: UIBarButtonItem!
        
    override func viewDidLoad() {
        
        
        
        labelTitle.text=NSLocalizedString(Utility.getKey("profile"),comment:"")
        freelancer = false
        self.editProfileArray = NSMutableArray()
        labelTitle.font = Utility.setNavigationFont()
        
        self.userDetail = self.userDetail.getLoggedInUser()!
        
        var cell: CheckInFooterTableViewCell? = tableView.dequeueReusableCellWithIdentifier("CheckInFooterCellIdentifier") as? CheckInFooterTableViewCell
        let arr : NSArray = NSBundle.mainBundle().loadNibNamed("CheckInFooterTableViewCell", owner: self, options: nil)
        cell = arr[0] as? CheckInFooterTableViewCell
        cell?.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 142)
        cell?.btnStartNow.setTitle(NSLocalizedString(Utility.getKey("Update"),comment:""), forState: .Normal)
        cell?.btnStartLater.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
        
        cell?.btnStartNow.addTarget(self, action: "nextButtonClicked", forControlEvents: .TouchUpInside)
        cell?.btnStartLater.addTarget(self, action: "btnBackClicked:", forControlEvents: .TouchUpInside)
        tableView.tableFooterView = cell
        
        if let path = NSBundle.mainBundle().pathForResource("editContactDetails", ofType: "plist")
        {
            editProfileArray = NSMutableArray(contentsOfFile: path)
            
            let arrTemp : NSMutableArray = NSMutableArray(array: editProfileArray)
            
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject>
                {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        let strOptionTitle = innerDict["OptionTitle"] as! NSString!
                        if strOptionTitle != nil
                        {
                            if strOptionTitle == "Edit"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                            }
                        }
                        
                        let strPlaceholder = innerDict["Placeholder"] as! NSString!
                        if strPlaceholder != nil
                        {
                            if strPlaceholder == "Firstname"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("First name"),comment:"")
                            }
                            else if strPlaceholder == "Lastname"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Last name"),comment:"")
                            }
                            else if strPlaceholder == "Email"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Email"),comment:"")
                            }
                            else if strPlaceholder == "Phone"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Phone"),comment:"")
                            }
                            if strPlaceholder == "Enter New Password"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Enter New Password"),comment:"")
                            }
                            else if strPlaceholder == "Re-enter New Password"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Re-enter New Password"),comment:"")
                            }
                            else if strPlaceholder == "Affiliation"
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                            }
                        }
                        
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        }
        
        getUserData()
        
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "PersonalDetailsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.PersonalDetailCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "ARPersonalDetailsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARPersonalDetailsTableViewCellIndetifier)
        
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
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            btnBarCancel.title = NSLocalizedString(Utility.getKey("done"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
            btnDone.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        }
        else
        {
            btnBarCancel.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("done"),comment:"")
            
            btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            btnDone.hidden = true
        }
        self.tableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        if activeTextField != nil
        {
            activeTextField.resignFirstResponder()
        }
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillShow(notification : NSNotification)
    {
        if activeTextField != nil{
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
    }
    func keyboardWillHide(notification : NSNotification)
    {
        if activeTextField != nil{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tableView.contentInset = UIEdgeInsetsZero
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero
            })
        }
    }
    func getUserData(){
        let arrTemp : NSArray = NSArray(array: self.editProfileArray)
        for (index, element) in arrTemp.enumerate()
        {
            if var innerDict = element as? Dictionary<String, AnyObject>
            {
                let iden = innerDict["Identity"] as! NSString!
                if iden == "UpdatedUsername"{
                    innerDict["Title"] = (self.userDetail.firstName as NSString as String) + " " + (self.userDetail.lastName as String)
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "SelectedJobTitle"{
                    innerDict["Title"] = self.userDetail.jobTitle
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "Affiliation"{
                    if self.userDetail.affiliation.length != 0
                    {
                        innerDict["Title"] = self.userDetail.affiliation
                        self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                    else
                    {
                        innerDict["Title"] = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                        self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
                if iden == "Freelancer"{
                    self.freelancer = self.userDetail.isFreeLancer as Bool
                }
                if iden == "CountryOfOrigin"{
                    innerDict["Title"] = Utility.findCountryFromCode(self.userDetail.origin)
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "CountryWhereWorking"{
                    innerDict["Title"] = Utility.findCountryFromCode(self.userDetail.working)
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "Firstname"{
                    innerDict["Title"] = self.userDetail.firstName
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "Lastname"{
                    innerDict["Title"] = self.userDetail.lastName
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "Email"{
                    innerDict["Title"] = self.userDetail.email
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
                if iden == "Phone"{
                    innerDict["Title"] = self.userDetail.phone
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //MARK : - NavigationBar Methods
    @IBAction func btnBackClicked(sender: AnyObject) {
        self.view.endEditing(true)
        backToPreviousScreen()
    }
    @IBAction func btnDoneClicked(sender: AnyObject) {
        self.view.endEditing(true)
        backToPreviousScreen()
    }
    
    func validateAllField() -> Bool
    {
        var isValidInfo : Bool = true
        var strTitle : String = ""
        if self.userDetail.email.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_email"),comment:"")
        }else if self.userDetail.firstName.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_firstname"),comment:"")
        }else if self.userDetail.lastName.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_lastname"),comment:"")
        }else if self.userDetail.phone.length == 0{
            isValidInfo = false
            strTitle = NSLocalizedString(Utility.getKey("please_enter_phone_no"),comment:"")
        }
        if isValidInfo == false {
            Utility.showAlertWithTitle(strTitle, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
        return isValidInfo
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
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
    //MARK:- Common method textfield
    func textStartEditing(textField : UITextField,  identity : NSString)
    {
        textField.inputAccessoryView = toolbar
        self.activeTextField = textField
    }
    func isValidateField(textField : UITextField, identity : NSString, isEndEditing: Bool) -> Bool
    {
        var isValidInfo : Bool = true
        var strTitle : String = ""
        
        if identity == "Email"
        {
            self.userDetail.email = textField.text
            if  !Utility.isValidEmail(textField.text!)
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("please_enter_valid_email"),comment:"")
                userDetail.email = ""
            }
            if textField.text!.characters.count > 100
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_100_Character"),comment:"")
                userDetail.email = ""
            }
            self.getUserData()
        }
        else if identity == "Firstname"
        {
            self.userDetail.firstName = textField.text
            if textField.text!.characters.count > 26
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_25_Character"),comment:"")
            }else if textField.text!.characters.count == 0{
                
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("please_enter_firstname"),comment:"")
            }
            self.getUserData()
        }
        else if identity == "Lastname"
        {
            self.userDetail.lastName = textField.text
            if textField.text!.characters.count > 26{
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("Could_not_More_Than_25_Character"),comment:"")
            }else if textField.text!.characters.count == 0{
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("please_enter_lastname"),comment:"")
            }
            self.getUserData()
        }
        else if identity == "Phone"
        {
            if  !Utility.isValidPhone(textField.text!)
            {
                isValidInfo = false
                strTitle = NSLocalizedString(Utility.getKey("please_enter_valid_phone"),comment:"")
            }
            else
            {
                self.userDetail.phone = textField.text
            }
            self.getUserData()
        }
        else if identity == "Affiliation"
        {
            userDetail.affiliation = textField.text
            getUserData()
        }
        if isValidInfo == false {
            textField.text = nil
            textField.resignFirstResponder()
            self.view.endEditing(true)
            Utility.showAlertWithTitle(strTitle, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
        return isValidInfo
    }
    
    //MARK:- DetailTextFieldProtocol
    func textFieldStartEditing(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        textStartEditing(textField, identity: identity)
    }
    func textFieldEndEditing(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        isValidateField(textField, identity: identity, isEndEditing: true)
    }
    func textFieldShouldReturn(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString){
        
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
    func textFieldShouldChangeCharactersInRange(textField: UITextField, tableViewCell: PersonalDetailsTableViewCell, identity: NSString, level: NSString, range: NSRange, replacementString string: String)
    {
    }
    
    //MARK: - ARPersonalDetailsTableView
    func textFieldShouldChangeCharactersInRange1(textField: UITextField, tableViewCell: ARPersonalDetailsTableViewCell, identity: NSString, level: NSString, range: NSRange, replacementString string: String) {
    }
    func textFieldStartEditing1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        textStartEditing(textField, identity: identity)
    }
    func textFieldEndEditing1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    {
        isValidateField(textField, identity: identity, isEndEditing: true)
    }
    func textFieldShouldReturn1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString){
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
    
    //MARK: - TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.editProfileArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kRowHeight = self.editProfileArray[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let kCellIdentifier = self.editProfileArray[indexPath.row]["CellIdentifier"] as! String
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier) as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = self.editProfileArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.editProfileArray[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.editProfileArray[indexPath.row]["Type"] as! Int!
                cell.identity = self.editProfileArray[indexPath.row]["Identity"] as! String!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell {
                cell.lblSubDetail.text = self.editProfileArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.editProfileArray[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.editProfileArray[indexPath.row]["Type"] as! Int!
                cell.identity = self.editProfileArray[indexPath.row]["Identity"] as! String!
                cell.intialize()
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "PersonalDetailCellIdentifier"
        {
            if let cell: ARPersonalDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARPersonalDetailsTableViewCellIndetifier") as? ARPersonalDetailsTableViewCell
            {
                cell.detailstextField.placeholder = self.editProfileArray[indexPath.row]["Placeholder"] as! String!
                cell.detailstextField.accessibilityIdentifier = self.editProfileArray[indexPath.row]["Identity"] as! String!
                cell.lblDetail.text = ""
                cell.identity = self.editProfileArray[indexPath.row]["Identity"] as! NSString!
                cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! NSString!
                cell.indexPath = indexPath
                cell.delegate = self
                cell.initialize()
                if cell.identity == "Email" {
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Firstname"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Lastname"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Phone"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }
                else if cell.identity == "NewPassword"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }
                else if cell.identity == "ConfirmPassword"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }
                else if cell.identity == "Affiliation"{
                    if self.userDetail.affiliation.length != 0
                    {
                        cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                        cell.detailstextField.placeholder = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                    }
                    else
                    {
                        cell.detailstextField.placeholder = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                    }
                }
                return cell
            }
        }
        else
        {
            if let cell: PersonalDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? PersonalDetailsTableViewCell {
                cell.detailstextField.placeholder = self.editProfileArray[indexPath.row]["Placeholder"] as! String!
                cell.detailstextField.accessibilityIdentifier = self.editProfileArray[indexPath.row]["Identity"] as! String!
                cell.lblDetail.text = ""
                cell.identity = self.editProfileArray[indexPath.row]["Identity"] as! NSString!
                cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! NSString!
                cell.indexPath = indexPath
                cell.delegate = self
                cell.initialize()
                
                if cell.identity == "Email" {
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Firstname"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Lastname"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Phone"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "NewPassword"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "ConfirmPassword"{
                    cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                }else if cell.identity == "Affiliation"{
                    if self.userDetail.affiliation.length != 0
                    {
                        cell.detailstextField.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                        cell.detailstextField.placeholder = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                    }
                    else
                    {
                        cell.detailstextField.placeholder = NSLocalizedString(Utility.getKey("Affiliation"),comment:"")
                    }
                }
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "TitleTableViewCellIdentifier"
        {
            if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARTitleTableViewCellIdentifier") as? ARTitleTableViewCell
            {
                cell.lblDetail.text = self.editProfileArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! String!
                cell.lblTitle.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell
            {
                cell.lblDetail.text = self.editProfileArray[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! String!
                cell.lblTitle.text = self.editProfileArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        
        if let cell: TitleTableViewCell2 = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell2
        {
            cell.levelString = self.editProfileArray[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.editProfileArray[indexPath.row]["Title"] as! String!
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
        
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "LocationListingCellIdentifier"
        {
            if let cell: ARLocationListingCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARLocationListingCellIdentifier) as? ARLocationListingCell
            {
                cell.value = self.editProfileArray[indexPath.row]["Value"] as! NSString!
                cell.detail = self.editProfileArray[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.editProfileArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
            
        }
        else
        {
            if let cell: LocationListingCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? LocationListingCell {
                cell.value = self.editProfileArray[indexPath.row]["Value"] as! NSString!
                cell.detail = self.editProfileArray[indexPath.row]["OptionTitle"] as! String!
                cell.title = self.editProfileArray[indexPath.row]["Title"] as! String!
                cell.intialize()
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "FreelancerCellIndentifier"
        {
            if let cell: ARFreelancerTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARFreelancerTableViewCellIdentifier) as? ARFreelancerTableViewCell {
                cell.isSelectedValue = self.freelancer
                cell.delegate = self
                cell.initialize()
                return cell
            }
            
        }
        else
        {
            if let cell: FreelancerTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? FreelancerTableViewCell {
                cell.isSelectedValue = self.freelancer
                cell.delegate = self
                cell.initialize()
                return cell
            }
            
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if  self.editProfileArray[indexPath.row]["Method"] as! NSString! == "selectJobTitle"{
            selectJobTitle(self.editProfileArray[indexPath.row]["Title"] as! String)
        }
        if  self.editProfileArray[indexPath.row]["Method"] as! NSString! == "selectCountryOfOrigin"{
            selectCountryOfOrigin(self.editProfileArray[indexPath.row]["Title"] as! String, code: self.userDetail.origin as String)
        }
        if  self.editProfileArray[indexPath.row]["Method"] as! NSString! == "selectCountryOfWorking"{
            selectCountryOfWorking(self.editProfileArray[indexPath.row]["Title"] as! String, code: self.userDetail.working as String)
        }
        if  self.editProfileArray[indexPath.row]["Method"] as! NSString! == "changePassword"{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.changePassword()
            })
        }
    }
    func nextButtonClicked() {
        if !validateAllField()
        {
            return
        }
        SVProgressHUD.dismiss()
        
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("updating_user"),comment:""), maskType: 4)
        
        User.registerUser(NSMutableDictionary(dictionary:User.dictToUpdate(Structures.Constant.appDelegate.prefrence.DeviceToken, user: self.userDetail)),isNewUser : false)
        User.sharedInstance.delegate = self
        
        
        /*User.registerUser(User.dictToUpdate(Structures.Constant.appDelegate.prefrence.DeviceToken, user: self.userDetail),isNewUser : false, completionClosure: { (isSuccess) -> Void in
            if isSuccess
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    SVProgressHUD.dismiss()
                })
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    if (Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                        if Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) != nil
                        {
                            Utility.showLogOutAlert((Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) as? String!)!, view: self)
                            
                            
                        }
                    }else{
                        if Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) != nil
                        {
                            
                            Utility.showAlertWithTitle((Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                        }
                    }
                })
            }
        })*/
    }
    
    
    func commonUserResponse(wsType : WSRequestType ,dict : NSDictionary, isSuccess : Bool)
    {
        if isSuccess{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                SVProgressHUD.dismiss()
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
                if (dict.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        Utility.showLogOutAlert((dict.valueForKey(Structures.Constant.Message) as? String!)!, view: self)
                    }
                }else{
                    if dict.valueForKey(Structures.Constant.Message) != nil
                    {
                        Utility.showAlertWithTitle((dict.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                    }
                }
            })
        }
    }
    
    func selectJobTitle(text : String!){
        let selectLanguageScreen : SelectLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectLanguageViewController") as! SelectLanguageViewController
        selectLanguageScreen.delegate = self
        selectLanguageScreen.selectedText = text
        selectLanguageScreen.selectType = 1
        selectLanguageScreen.isFromProfile = 1
        showViewController(selectLanguageScreen, sender: self.view)
    }
    func selectCountryOfOrigin(text : String!, code : String!){
        let selectLanguageScreen : SelectLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectLanguageViewController") as! SelectLanguageViewController
        selectLanguageScreen.delegate = self
        selectLanguageScreen.selectedText = text
        selectLanguageScreen.selectedCode = code
        selectLanguageScreen.selectType = 2
        selectLanguageScreen.isFromProfile = 1
        showViewController(selectLanguageScreen, sender: self.view)
    }
    func selectCountryOfWorking(text : String!, code : String!){
        let selectLanguageScreen : SelectLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SelectLanguageViewController") as! SelectLanguageViewController
        selectLanguageScreen.delegate = self
        selectLanguageScreen.selectedText = text
        selectLanguageScreen.selectedCode = code
        selectLanguageScreen.selectType = 3
        selectLanguageScreen.isFromProfile = 1
        showViewController(selectLanguageScreen, sender: self.view)
    }
    //MARK:- Profile New
    //MARK : - FreelancerButtonProtocol
    func freelancerButtonClicked(isSelected: NSNumber) {
        self.userDetail.isFreeLancer = isSelected
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
        self.userDetail.affiliation = changedText
        changeValueInMainCheckInArray(changedText, identity: "Affiliation")
    }
    //MARK : - SelctedLanguageProtocol
    func jobTitleSelcted(selectedText : String){
        self.userDetail.jobTitle = selectedText
        changeValueInMainCheckInArray(selectedText, identity: "SelectedJobTitle")
    }
    func countryOfOrigin(selectedText: String, selectedCode: String) {
        self.userDetail.origin = selectedCode
        changeValueInMainCheckInArray(selectedText, identity: "CountryOfOrigin")
    }
    func countryWhereWorking(selectedText: String, selectedCode: String) {
        self.userDetail.working = selectedCode
        changeValueInMainCheckInArray(selectedText, identity: "CountryWhereWorking")
    }
    func changeValueInMainCheckInArray(newValue : NSString, identity : NSString){
        for (index, element) in self.editProfileArray.enumerate() {
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
                    
                    self.editProfileArray.replaceObjectAtIndex(index, withObject: innerDict)
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }
    //Update Password Alert
    func changePassword(){
        let alertController =  UIAlertController(title: NSLocalizedString(Utility.getKey("Update Password"),comment:"") , message: nil , preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler{(textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("Current password"),comment:"")
            textField.secureTextEntry = true
            if Structures.Constant.appDelegate.isArabic == true{
                textField.textAlignment = NSTextAlignment.Right
            }else{
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder =  NSLocalizedString(Utility.getKey("New password"),comment:"")
            textField.secureTextEntry = true
            if Structures.Constant.appDelegate.isArabic == true{
                textField.textAlignment = NSTextAlignment.Right
            }else{
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString(Utility.getKey("Confirm password"),comment:"")
            textField.secureTextEntry = true
            if Structures.Constant.appDelegate.isArabic == true{
                textField.textAlignment = NSTextAlignment.Right
            }else{
                textField.textAlignment = NSTextAlignment.Left
            }
        }
        let updateAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Update"),comment:""), style: .Default) { (_) in
            let CurrentPassword = alertController.textFields![0]
            let NewPasscode = alertController.textFields![1]
            let ConfirmPasscode = alertController.textFields![2]
            if (CurrentPassword.text!.characters.count > 0 && NewPasscode.text!.characters.count > 0 && ConfirmPasscode.text!.characters.count > 0) {
                let CurrentPassword : String = CurrentPassword.text!
                let NewPasscode : String = NewPasscode.text!
                let ConfirmPasscode : String = ConfirmPasscode.text!
                
                if !Utility.isValidPassword(NewPasscode, strUserName: self.userDetail.userName as String)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.showPasswordAlert()
                    })
                }
                else if (NewPasscode.characters.count > 0 && ConfirmPasscode !=  NewPasscode)
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.showWarningAlert(NSLocalizedString(Utility.getKey("Password_notmatch"),comment:""), strMessage: "", strButtonText: NSLocalizedString(Utility.getKey("try_again"),comment:""))
                    })
                }
                else if NewPasscode.localizedCaseInsensitiveContainsString(self.userDetail.userName as String){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.showPasswordAlert()
                    })
                }else{
                    self.ResetPassword(CurrentPassword, newPass: NewPasscode)
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.showWarningAlert(NSLocalizedString(Utility.getKey("please_enter_password"),comment:""), strMessage: "", strButtonText: NSLocalizedString(Utility.getKey("Ok"),comment:""))
                    (NSLocalizedString(Utility.getKey("please_enter_password"),comment:""), strMessage: "")
                })
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Default) { (_) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    func showWarningAlert(strTiitle : NSString, strMessage : NSString, strButtonText : NSString){
        
        let alertController =  UIAlertController(title:  strTiitle as String , message: strMessage as String, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: strButtonText as String, style: .Default) { (_) in
            self.changePassword()
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func ResetPassword(oldPass : NSString, newPass : NSString)
    {
        SVProgressHUD.show()
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic ["oldpassword"] = oldPass
        dic ["newpassword"] = newPass
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.ResetPassword(dic)
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
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if  (response is NSString)
        {
            SVProgressHUD.dismiss()
        }
        else{
            
            if let data : NSData? = NSData(data: response as! NSData)
            {
                if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if type == WSRequestType.ResetPassword
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let alertController = UIAlertController(title: dic.valueForKey(Structures.Constant.Message) as? String , message: "", preferredStyle: .Alert)
                                alertController.addAction(UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:""), style: .Default, handler: { action in
                                    self.backToPreviousScreen()
                                }))
                                self.presentViewController(alertController, animated: true, completion: nil)
                                
                            })
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            SVProgressHUD.dismiss()
                            
                        }
                        else if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                            SVProgressHUD.dismiss()
                            if dic.valueForKey(Structures.Constant.Message) != nil
                            {
                                
                                
                                Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String!)!, view: self)
                                
                            }
                        }
                        else
                        {
                            SVProgressHUD.dismiss()
                            
                            Utility.showAlertWithTitle(dic.objectForKey(Structures.Constant.Message) as! String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                            
                        }
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
        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
    }
}
