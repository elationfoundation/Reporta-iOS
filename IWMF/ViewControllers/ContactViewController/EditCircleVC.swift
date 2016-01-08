//
//  EditCircleVC.swift
//  IWMF
//
//  This class is used for display contact of active circle and allows user to Edit name of circle, delete contact of acive circle.
//
//

import UIKit
enum EditCircleType : Int{
    case circleEdit = 1
    case circleNew = 2
}

class EditCircleVC: UIViewController, WSClientDelegate, UIAlertViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var textCircleName: UITextField!
    @IBOutlet weak var ENtextCircleName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSaveEdit: UIButton!
    var selectedRow: Int!
    var selectedSection: Int!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var EnbtnAdd: UIButton!
    @IBOutlet weak var ENlblCount: UILabel!
    @IBOutlet weak var EntxtSearch: UITextField!
    @IBOutlet weak var EnBtnEdit: UIButton!
    var objEditCircleType : EditCircleType!
    var userDetail = User()
    var isAddManually : Bool!
    var dictContactList : NSDictionary!
    var arrSearchResult :NSMutableArray!
    var dictTemp: NSDictionary!
    var arrSection : NSArray!
    var textColor , lineColor, active_circle_text : UIColor!
    var circle : Circle!
        var isSearchActive, isContactAvailable, isFromCancel : Bool!
    @IBOutlet weak var viewEditAR: UIView!
    @IBOutlet weak var viewEditEN: UIView!
    @IBOutlet weak var txtSearchBG: UIImageView!
    @IBOutlet weak var btnFooterNext: UIButton!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var tblBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var EnBtnEditWidth: NSLayoutConstraint!
    var names : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblList.sectionIndexColor = UIColor.blackColor()
        tblList.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        tblList.sectionIndexBackgroundColor = UIColor.clearColor()
        tblList.backgroundColor = Structures.Constant.appDelegate.tableBackground
        self.view.backgroundColor = Structures.Constant.appDelegate.tableBackground
        textColor = UIColor(red:87/255, green:87/255, blue:87/255, alpha:1.0)
        lineColor = Utility.UIColorFromHex(0xD7D7D7, alpha: 1)
        active_circle_text = Utility.UIColorFromHex(0x0F89DC, alpha: 1)
        tblList.scrollEnabled = false
        tblList.sectionIndexMinimumDisplayRowCount = NSInteger.max
        
        txtSearch.placeholder=NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        EntxtSearch.placeholder=NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        
        textCircleName.placeholder=NSLocalizedString(Utility.getKey("contact_list_name"),comment:"")
        ENtextCircleName.placeholder=NSLocalizedString(Utility.getKey("contact_list_name"),comment:"")
        
        lblCount.text = ""
        ENlblCount.text = ""
        lblTitle.text =  NSLocalizedString(Utility.getKey("contacts"),comment:"")
        isSearchActive = false
        arrSearchResult = [] as NSMutableArray
        arrSection = NSArray()
        viewSearch.hidden = true
        
        btnFooterNext.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: UIControlState.Normal)
        
        isContactAvailable = false
        
        lblTitle.font = Utility.setNavigationFont()
        textCircleName.font = Utility.setFont()
        
        if CommonUnit.isIphone4()
        {
            btnAdd.titleLabel?.font = UIFont.systemFontOfSize(18)
        }
        else if CommonUnit.isIphone5()
        {
            btnAdd.titleLabel?.font = UIFont.systemFontOfSize(20)
        }
        else if CommonUnit.isIphone6()
        {
            btnAdd.titleLabel?.font = UIFont.systemFontOfSize(23)
        }
        else if CommonUnit.isIphone6plus()
        {
            btnAdd.titleLabel?.font = UIFont.systemFontOfSize(24)
        }
        
        if Structures.Constant.appDelegate.strLanguage == Structures.Constant.French{
            EnBtnEditWidth.constant = 70
        }
        
        txtSearch.font = textCircleName.font
        lblCount.font = textCircleName.font
        EntxtSearch.font = textCircleName.font
        ENlblCount.font = textCircleName.font
        ENlblCount.font = textCircleName.font
        ENtextCircleName.font = textCircleName.font
        EnbtnAdd.titleLabel?.font = textCircleName.font
        EnBtnEdit.titleLabel?.font = textCircleName.font
        txtSearch.delegate = self
        EntxtSearch.delegate = self
        if objEditCircleType == .circleEdit
        {
            if (dictTemp?.valueForKey("Contacts") as! NSArray).count > 0
            {
                lblCount.text = "(" + String((dictTemp?.valueForKey("Contacts") as! NSArray).count) + ")"
                ENlblCount.text = "(" + String((dictTemp?.valueForKey("Contacts") as! NSArray).count) + ")"
                getContactList()
            }
        }
        else if objEditCircleType == .circleNew
        {
            
        }
    }
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool)
    {
        textCircleName.textColor = UIColor.blackColor()
        textCircleName.userInteractionEnabled = false
        ENtextCircleName.textColor = UIColor.blackColor()
        ENtextCircleName.userInteractionEnabled = false
        
        btnAdd.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
        EnbtnAdd.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
        btnSaveEdit.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
        EnBtnEdit.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
        btnSaveEdit.setTitle(NSLocalizedString(Utility.getKey("Edit"),comment:""), forState: UIControlState.Normal)
        EnBtnEdit.setTitle(NSLocalizedString(Utility.getKey("Edit"),comment:""), forState: UIControlState.Normal)
        isAddManually = false
        isFromCancel = false
        if Structures.Constant.appDelegate.isContactUpdated == true
        {
            if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
            {
                btnBack.hidden = true
                ARbtnBack.hidden = true
                getContactList()
            }
            else
            {
                getContactListWithData()
            }
        }
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
            viewEditAR.hidden = false
            viewEditEN.hidden = true
            textCircleName.textAlignment = NSTextAlignment.Right
            ENtextCircleName.textAlignment = NSTextAlignment.Right
            txtSearch.textAlignment =  NSTextAlignment.Right
            EntxtSearch.textAlignment =  NSTextAlignment.Right
            txtSearchBG.image = UIImage(named: "ARsearch-bg.png")
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            viewEditAR.hidden = true
            viewEditEN.hidden = false
            textCircleName.textAlignment = NSTextAlignment.Left
            ENtextCircleName.textAlignment = NSTextAlignment.Left
            txtSearch.textAlignment =  NSTextAlignment.Left
            EntxtSearch.textAlignment =  NSTextAlignment.Left
            txtSearchBG.image = UIImage(named: "search-bg.png")
        }
        if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
        {
            textCircleName.text = Structures.Constant.appDelegate.dictSignUpCircle.objectForKey(Structures.Constant.ListName) as? String
            ENtextCircleName.text = Structures.Constant.appDelegate.dictSignUpCircle.objectForKey(Structures.Constant.ListName) as? String
            Structures.Constant.appDelegate.dictSelectToUpdate = Structures.Constant.appDelegate.dictSignUpCircle
        }
        else
        {
            dispatch_async(dispatch_get_main_queue())
                {
                    self.tblBottomSpace.constant = 0
            }
            
            viewFooter.hidden = true
            if dictTemp.valueForKey(Structures.Constant.ContactListID) == nil
            {
                
                let strCircle=NSString(format:"%d",(dictTemp.valueForKey("circle_id")?.intValue!)!)
                
                Structures.Constant.appDelegate.dictSelectToUpdate.setValue(strCircle, forKey: Structures.Constant.ContactListID)
                
                Structures.Constant.appDelegate.dictSelectToUpdate.setValue((dictTemp.valueForKey(Structures.Constant.ListName) as! NSString), forKey: Structures.Constant.ListName)
                Structures.Constant.appDelegate.dictSelectToUpdate.setValue("0", forKey: "is_associated")
                if circle.circleType == CircleType.Private
                {
                    Structures.Constant.appDelegate.dictSelectToUpdate.setValue("1", forKey: Structures.User.CircleType)
                }
                else
                {
                    Structures.Constant.appDelegate.dictSelectToUpdate.setValue("2", forKey: Structures.User.CircleType)
                }
            }
            else
            {
                Structures.Constant.appDelegate.dictSelectToUpdate = dictTemp
            }
            
            textCircleName.text = dictTemp.objectForKey(Structures.Constant.ListName) as? String
            ENtextCircleName.text = dictTemp.objectForKey(Structures.Constant.ListName) as? String
        }
        
    }
    func getContactListWithData()
    {
        SVProgressHUD.show()
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        if  circle.circleType == CircleType.Private
        {
            dic [Structures.User.CircleType] = "1"
        }
        else if  circle.circleType == CircleType.Public
        {
            dic [Structures.User.CircleType] = "2"
        }
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.getContactListWithData(dic);
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnBackPress(sender: AnyObject)
    {
        if isContactAvailable == true
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            
            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("no_contact_added"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            
        }
    }
    @IBAction func btnSaveEditPress(sender: AnyObject)
    {
        let btn: UIButton = sender as! UIButton
        if btn.titleLabel?.text ==  NSLocalizedString(Utility.getKey("Edit"),comment:"")
        {
            btn.setTitle(NSLocalizedString(Utility.getKey("save"),comment:""), forState: UIControlState.Normal)
            textCircleName.textColor = active_circle_text
            textCircleName.userInteractionEnabled = true
            textCircleName.becomeFirstResponder()
            
            ENtextCircleName.textColor = active_circle_text
            ENtextCircleName.userInteractionEnabled = true
            ENtextCircleName.becomeFirstResponder()
            
        }
        else
        {
            btn.setTitle( NSLocalizedString(Utility.getKey("Edit"),comment:""), forState: UIControlState.Normal)
            textCircleName.textColor = UIColor.blackColor()
            textCircleName.userInteractionEnabled = false
            textCircleName.resignFirstResponder()
            
            ENtextCircleName.textColor = UIColor.blackColor()
            ENtextCircleName.userInteractionEnabled = false
            ENtextCircleName.resignFirstResponder()
            
            
            if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
            {
                if Structures.Constant.appDelegate.isArabic == true
                {
                    Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.ListName] = textCircleName.text
                }
                else
                {
                    Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.ListName] = ENtextCircleName.text
                }
            }
            else
            {
                createContactCircletWithData()
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    @IBAction func btnFooterNextClick(sender: AnyObject)
    {
        if (Structures.Constant.appDelegate.dictSignUpCircle?.valueForKey("Contacts") as! NSArray).count > 0
        {
            let vc : Step4_CreateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step4_CreateAccountVC") as! Step4_CreateAccountVC
            vc.circle =  self.circle!
            showViewController(vc, sender: self.view)
        }
        else
        {
            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("no_contact_added"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
    }
    @IBAction func btnCancelPress(sender: AnyObject)
    {
        deleteContactCircleWithData()
    }
    @IBAction func btnAddPress(sender: AnyObject)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        actionSheetController.view.tintColor = UIColor.blackColor()
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel)
            { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let first: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("add_from_addressbook"),comment:""), style: .Default) { action -> Void in
            [self.performSegueWithIdentifier("AddressBookPush", sender: nil)];
        }
        actionSheetController.addAction(first)
        
        let second: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("add_from_Reporta"),comment:""), style: .Default) { action -> Void in
            [self.performSegueWithIdentifier("AddExistingContactSegue", sender: nil)];
        }
        actionSheetController.addAction(second)
        
        let third: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("add_manually"),comment:""), style: .Default) { action -> Void in
            self.isAddManually = true
            [self.performSegueWithIdentifier("viewContactDetailPush", sender: nil)];
        }
        actionSheetController.addAction(third)
        
        actionSheetController.popoverPresentationController?.sourceView = sender as? UIView
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if  segue.identifier == "AddressBookPush"
        {
            let vc : AllContactsListVC = segue.destinationViewController as! AllContactsListVC
            vc.objContactViewType =  contactViewType.FromAddressBook
            vc.circle  = self.circle
        }
        else if  segue.identifier == "AddExistingContactSegue"
        {
            let vc : AddExistingContact = segue.destinationViewController as! AddExistingContact
            vc.contactlist_id = dictTemp.objectForKey(Structures.Constant.ContactListID) as! NSString
        }
        else if  segue.identifier == "viewContactDetailPush"
        {
            if isAddManually == true
            {
                let vc : AddContactViewController = segue.destinationViewController as! AddContactViewController
                vc.circle = self.circle
                vc.objAddContactType = AddContactType.New
            }
            else
            {
                let vc : AddContactViewController = segue.destinationViewController as! AddContactViewController
                if !isSearchActive
                {
                    let strKey : String = arrSection.objectAtIndex(selectedSection) as! String
                    vc.dictDetailEdit = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(selectedRow) as!  NSMutableDictionary
                }
                else
                {
                    if arrSearchResult.count > 0
                    {
                        vc.dictDetailEdit = arrSearchResult[selectedRow] as!  NSMutableDictionary
                    }
                }
                vc.strSelectedContactIndex = selectedRow
                vc.circle = self.circle
                vc.objAddContactType = AddContactType.Edit
            }
        }
    }
    func deleteContactCircleWithData(){
        
        SVProgressHUD.show()
        isFromCancel = true
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic[Structures.Constant.ContactListID] = (dictTemp.objectForKey(Structures.Constant.ContactListID) as! NSString).integerValue
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.deleteContactCircleWithData(dic)
        
    }
    func createContactCircletWithData()
    {
        SVProgressHUD.show()
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic [Structures.Constant.ListID] = dictTemp?.valueForKey(Structures.Constant.ContactListID) as! NSString
        if Structures.Constant.appDelegate.isArabic == true
        {
            dic [Structures.Constant.ListName] = textCircleName.text
        }
        else
        {
            dic [Structures.Constant.ListName] = ENtextCircleName.text
        }
        
        if  circle.circleType == CircleType.Private
        {
            dic [Structures.User.CircleType] = "1"
        }
        else if  circle.circleType == CircleType.Public
        {
            dic [Structures.User.CircleType] = "2"
        }
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.createContactCircletWithData(dic);
    }
    func getContactList()
    {
        SVProgressHUD.show()
        if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
        {
            dictContactList  = CommonUnit.getSectionFromDictionary(Structures.Constant.appDelegate.dictSignUpCircle?.valueForKey("Contacts") as! NSArray as [AnyObject], isAllConact: true)
            lblCount.text = "(" + String((Structures.Constant.appDelegate.dictSignUpCircle?.valueForKey("Contacts") as! NSArray).count) + ")"
            ENlblCount.text = "(" + String((Structures.Constant.appDelegate.dictSignUpCircle?.valueForKey("Contacts") as! NSArray).count) + ")"
        }
        else
        {
            dictContactList  = CommonUnit.getSectionFromDictionary(dictTemp?.valueForKey("Contacts") as! NSArray as [AnyObject], isAllConact: true)
        }
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
        
        if arrSection.count > 0
        {
            isContactAvailable = true
            viewSearch.hidden = false
            tblList.scrollEnabled = true
            tblList.sectionIndexMinimumDisplayRowCount = NSInteger.min
        }
        else
        {
            isContactAvailable = false
            viewSearch.hidden = true
            tblList.scrollEnabled = false
            tblList.sectionIndexMinimumDisplayRowCount = NSInteger.max
        }
        tblList.reloadData()
        SVProgressHUD.dismiss()
    }
    func deleteContactAlert(indexPath : NSIndexPath){
        
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString(Utility.getKey("delete_contact_msg"),comment:""), message: nil, preferredStyle: .Alert)
        let yes: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("yes"),comment:""), style: .Cancel)
            { action -> Void in
                self.deleteContactWithData(indexPath.row, deleteSection: indexPath.section)
        }
        let no: UIAlertAction = UIAlertAction(title:NSLocalizedString(Utility.getKey("no"),comment:"") , style: .Default) { action -> Void in
            self.tblList.reloadData()
        }
        if Structures.Constant.appDelegate.isArabic == true
        {
            alert.addAction(no)
            alert.addAction(yes)
        }else{
            alert.addAction(yes)
            alert.addAction(no)
        }
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func deleteLastContactAlert(indexPath : NSIndexPath){
        let alert: UIAlertController = UIAlertController(title: NSLocalizedString(Utility.getKey("delete_last_contact"),comment:""), message: nil, preferredStyle: .Alert)
        let yes: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("delete_now"),comment:""), style: .Cancel)
            { action -> Void in
                self.deleteContactCircleWithData()
        }
        let no: UIAlertAction = UIAlertAction(title:NSLocalizedString(Utility.getKey("Cancel"),comment:"") , style: .Default) { action -> Void in
            self.tblList.reloadData()
        }
        if Structures.Constant.appDelegate.isArabic == true
        {
            alert.addAction(no)
            alert.addAction(yes)
        }else{
            alert.addAction(yes)
            alert.addAction(no)
        }
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    //MARK:- UItableview Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        if isContactAvailable == true
        {
            
            if !isSearchActive
            {
                
                if arrSection.count > 0
                {
                    return arrSection.count
                }
                else
                {
                    return 0
                }
                
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 1
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if isContactAvailable == true
        {
            if !isSearchActive
            {
                if arrSection.count > 0
                {
                    let strKey : String = arrSection.objectAtIndex(section) as! String
                    return (dictContactList.valueForKey(strKey) as! NSArray ).count
                }
                else
                {
                    return 0;
                }
            }
            else
            {
                if arrSearchResult.count > 0
                {
                    return arrSearchResult.count
                }
                else
                {
                    return 0
                }
            }
        }
        else
        {
            return 1
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.backgroundColor = tblList.backgroundColor
        cell.contentView.backgroundColor = cell.backgroundColor
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if isContactAvailable == true
        {
            let cellIdentifier : String = "AllContactCell"
            var cell: AllContactCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AllContactCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("AllContactCell", owner: self, options: nil)
                if Structures.Constant.appDelegate.isArabic == true{
                    cell = arr[1] as? AllContactCell
                }else{
                    cell = arr[0] as? AllContactCell
                }
                
            }
            if !isSearchActive
            {
                let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
                if arrSection.count > 0
                {
                    cell?.btnLock.hidden = false
                    
                    let strStatus : String = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("sos_enabled") as! String
                    cell?.btnLock.contentMode = UIViewContentMode.ScaleAspectFill
                    
                    if strStatus == "0"
                    {
                        cell?.btnLock.setImage(UIImage(named: "unlock.png") as UIImage?, forState: .Normal)
                        cell?.btnLock.hidden = true
                    }
                    else if strStatus == "1"
                    {
                        cell?.btnLock.setImage(UIImage(named: "lock.png") as UIImage?, forState: .Normal)
                    }
                    else if strStatus == "2"
                    {
                        cell?.btnLock.setImage(UIImage(named: "pending.png") as UIImage?, forState: .Normal)
                    }
                    
                    
                    cell?.lblName.textColor =  textColor
                    cell?.lblName.text = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
                }
            }
            else
            {
                if arrSearchResult.count > 0
                {
                    cell?.btnLock.hidden = false
                    
                    let strStatus : NSString = arrSearchResult.objectAtIndex(indexPath.row).valueForKey("sos_enabled") as! NSString
                    cell?.btnLock.contentMode = UIViewContentMode.ScaleAspectFill
                    
                    if strStatus == "0"
                    {
                        cell?.btnLock.setImage(UIImage(named: "unlock.png") as UIImage?, forState: .Normal)
                        cell?.btnLock.hidden = true
                    }
                    else if strStatus == "1"
                    {
                        cell?.btnLock.setImage(UIImage(named: "lock.png") as UIImage?, forState: .Normal)
                    }
                    else if strStatus == "2"
                    {
                        cell?.btnLock.setImage(UIImage(named: "pending.png") as UIImage?, forState: .Normal)
                    }
                    
                    
                    
                    cell?.lblName.textColor =  textColor
                    cell?.lblName.text = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as!  String) + " " + (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
                }
            }
            
            cell?.lblBottomLineFull.hidden = true
            cell?.lblTopLineFull.hidden = true
            cell?.lblBottomLineShort.backgroundColor =  lineColor
            return cell!
        }
        else
        {
            let cellIdentifier : String = "BuildThisCircleCell"
            var cell: BuildThisCircleCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? BuildThisCircleCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("BuildThisCircleCell", owner: self, options: nil)
                cell = arr[0] as? BuildThisCircleCell
            }
            cell?.selectionStyle =  UITableViewCellSelectionStyle.None
            if  circle.circleType == CircleType.Private
            {
                cell?.lblText.text = NSLocalizedString(Utility.getKey("create_new_private_circle"),comment:"")
            }
            else
            {
                cell?.lblText.text = NSLocalizedString(Utility.getKey("create_new_public_circle"),comment:"")
            }
            //Build This Circle
            cell?.btnBuildThisCircle.setTitle(NSLocalizedString(Utility.getKey("build_this_circle"),comment:""), forState: UIControlState.Normal)
            cell?.btnBuildThisCircle.addTarget(self, action: Selector("btnAddPress:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            //Cancel
            cell?.btnCancel.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: UIControlState.Normal)
            cell?.btnCancel.addTarget(self, action: Selector("btnCancelPress:"), forControlEvents: UIControlEvents.TouchUpInside)
            return cell!
        }
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if !isSearchActive
        {
            if arrSection.count > 0
            {
                let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
                if arrSection.count > 1
                {
                    deleteContactAlert(indexPath)
                }
                else if arrSection.count == 1 && (dictContactList.valueForKey(strKey) as! NSArray).count > 1
                {
                    deleteContactAlert(indexPath)
                }
                else
                {
                    deleteLastContactAlert(indexPath)
                }
            }
        }
        else
        {
            if arrSection.count > 0
            {
                let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
                if arrSection.count > 1
                {
                    deleteContactAlert(indexPath)
                }
                else if arrSection.count == 1 && (dictContactList.valueForKey(strKey) as! NSArray).count > 1
                {
                    deleteContactAlert(indexPath)
                }
                else
                {
                    deleteLastContactAlert(indexPath)
                }
            }
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
        {
            return UITableViewCellEditingStyle.None
        }
        else{
            return UITableViewCellEditingStyle.Delete
        }
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> NSString
    {
        return String(NSLocalizedString(Utility.getKey("menu_delete"),comment:""))
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = tblList.backgroundColor
        
        if !isSearchActive
        {
            let lblTop: UILabel = UILabel()
            lblTop.frame = CGRectMake(0, -1, tableView.frame.size.width, 1)
            lblTop.backgroundColor =  lineColor
            view.addSubview(lblTop)
            
            if arrSection.count > 0
            {
                let title: UILabel = UILabel()
                
                if Structures.Constant.appDelegate.isArabic == true
                {
                    title.frame = CGRectMake(5, 5, tableView.frame.size.width-25, 20)
                    title.textAlignment = NSTextAlignment.Right
                }
                else
                {
                    title.frame = CGRectMake(5, 5, tableView.frame.size.width-10, 20)
                    title.textAlignment = NSTextAlignment.Left
                }
                
                title.text = arrSection.objectAtIndex(section) as? String
                title.textColor =  textColor
                view.addSubview(title)
                
                let lblBottom: UILabel = UILabel()
                lblBottom.frame = CGRectMake(0, 28, tableView.frame.size.width, 1)
                
                lblBottom.backgroundColor =  lineColor
                view.addSubview(lblBottom)
                
            }
        }
        return view
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if isContactAvailable == true
        {
            if isSearchActive != true
            {
                return 46
            }
            else
            {
                return 46
            }
        }
        else
        {
            return 250
        }
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if isContactAvailable == true
        {
            if isSearchActive != true
            {
                if arrSection.objectAtIndex(section) as! String != ""
                {
                    return 30
                }
                return 0
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]
    {
        return (names as? [String])!
    }
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return self.arrSection.indexOfObject(title)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if isContactAvailable == true
        {
            selectedRow = indexPath.row
            selectedSection = indexPath.section
            self.performSegueWithIdentifier("viewContactDetailPush", sender: nil);
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        if textField.tag == 3
        {
            if  string != "\n"
            {
                arrSearchResult = [] as NSMutableArray
                var strSearch : String!
                if  textField.text!.characters.count == range.location
                {
                    strSearch = textField.text! + string
                }
                else
                {
                    let str : String = textField.text!
                    let index: String.Index = str.startIndex.advancedBy(range.location)
                    strSearch = str.substringToIndex(index) // "Stack"
                }
                
                if (strSearch.characters.count==0)
                {
                    self.isSearchActive = false
                }
                else
                {
                    self.isSearchActive = true
                    for (var i : Int = 0; i < arrSection.count ; i++)
                    {
                        let arrtemp1 : NSArray! = dictContactList.objectForKey(arrSection.objectAtIndex(i)) as! NSArray
                        for (var j=0; j < arrtemp1.count ; j++)
                        {
                            let strRangeText : NSString = (arrtemp1.objectAtIndex(j).valueForKey(Structures.User.User_LastName) as! NSString).lowercaseString + " " + (arrtemp1.objectAtIndex(j).valueForKey("firstname") as! NSString).lowercaseString
                            let range : NSRange = strRangeText.rangeOfString(strSearch.lowercaseString) as NSRange
                            if range.location != NSNotFound
                            {
                                arrSearchResult.addObject(arrtemp1.objectAtIndex(j))
                            }
                        }
                    }
                }
                tblList.reloadData()
            }
        }
        return true
    }
    //MARK :- WSDelgate
    func deleteContactWithData(deleteIndex: Int, deleteSection: Int)
    {
        let dic : NSMutableDictionary = NSMutableDictionary()
        if !isSearchActive
        {
            let strKey : NSString = arrSection.objectAtIndex(deleteSection) as! String
            dic ["contact_id"] = ((dictContactList.valueForKey(strKey as String) as! NSArray).objectAtIndex(deleteIndex).valueForKey("contact_id") as! NSString).integerValue
            
        }
        else
        {
            dic ["contact_id"] = (arrSearchResult.objectAtIndex(deleteIndex).valueForKey("contact_id") as! NSString).integerValue
        }
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.deleteContactWithData(dic);
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
                    if type == WSRequestType.CreateContactCircle
                    {
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
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
                            Utility.showAlertWithTitle(dic.objectForKey(Structures.Constant.Message) as! String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                            
                        }
                        
                    }
                    else if  type == WSRequestType.DeleteContactList
                    {
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            SVProgressHUD.dismiss()
                            if isFromCancel == true
                            {
                                let arrVcs : NSArray! = self.navigationController!.viewControllers as NSArray
                                var vc :ContactListViewController
                                var vc2 :CheckInViewController
                                var vc3 :AlertViewController
                                
                                
                                for var i : Int = 0 ; i < arrVcs.count ; i++
                                {
                                    if  arrVcs.objectAtIndex(i) .isKindOfClass(ContactListViewController)
                                    {
                                        vc  = arrVcs[i] as! ContactListViewController
                                        self.navigationController?.popToViewController(vc, animated: true)
                                        break;
                                    }
                                    else if arrVcs.objectAtIndex(i) .isKindOfClass(CheckInViewController)
                                    {
                                        vc2  = arrVcs[i] as! CheckInViewController
                                        self.navigationController?.popToViewController(vc2, animated: true)
                                        break;
                                    }
                                    else if arrVcs.objectAtIndex(i) .isKindOfClass(AlertViewController)
                                    {
                                        vc3  = arrVcs[i] as! AlertViewController
                                        self.navigationController?.popToViewController(vc3, animated: true)
                                        break;
                                    }
                                }
                            }
                            else
                            {
                                getContactListWithData()
                            }
                        }
                        else if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                            SVProgressHUD.dismiss()
                            if dic.valueForKey(Structures.Constant.Message) != nil
                            {
                                
                                
                                Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                                
                            }
                        }
                        else{
                            SVProgressHUD.dismiss()
                            Utility.showAlertWithTitle(dic.objectForKey(Structures.Constant.Message) as! String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                        }
                    }
                        
                    else  if type == WSRequestType.GetContactList
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            let arrCircle  = dic.valueForKey("data") as! NSArray
                            for (var i = 0 ; i < arrCircle.count ; i++)
                            {
                                if (arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue == (Structures.Constant.appDelegate.dictSelectToUpdate.valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
                                {
                                    dictContactList = CommonUnit.getSectionFromDictionary(arrCircle.objectAtIndex(i).valueForKey("Contacts") as! NSArray as [AnyObject], isAllConact: true)
                                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
                                    arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
                                    isSearchActive = false
                                    txtSearch.text = nil
                                    EntxtSearch.text = nil
                                    if arrSection.count > 0
                                    {
                                        isContactAvailable = true
                                        viewSearch.hidden = false
                                        tblList.scrollEnabled = true
                                        tblList.sectionIndexMinimumDisplayRowCount = NSInteger.min
                                        lblCount.text = "(" + String((arrCircle.objectAtIndex(i).valueForKey("Contacts") as! NSArray).count) + ")"
                                        ENlblCount.text = "(" + String((arrCircle.objectAtIndex(i).valueForKey("Contacts") as! NSArray).count) + ")"
                                    }else
                                    {
                                        isContactAvailable = false
                                        viewSearch.hidden = true
                                        tblList.scrollEnabled = false
                                        tblList.sectionIndexMinimumDisplayRowCount = NSInteger.max
                                        lblCount.hidden = true
                                        ENlblCount.hidden = true
                                    }
                                    break
                                }
                            }
                            dispatch_async(dispatch_get_main_queue())
                                {
                                    self.tblList.reloadData()
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
