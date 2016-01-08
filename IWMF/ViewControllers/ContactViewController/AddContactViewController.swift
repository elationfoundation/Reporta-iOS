//
//  AddContactViewController.swift
//  IWMF
//
//  This class is used for Adding contact in Private or Public circle.
//
//

import UIKit
enum AddContactType : Int{
    case Edit = 1
    case New = 2
    case AddressBook = 3
}
class AddContactViewController: UIViewController ,WSClientDelegate , UITextFieldDelegate , UIAlertViewDelegate ,UITableViewDataSource, circleListAddToContactProtocol , UITableViewDelegate{
    @IBOutlet var tbl : UITableView!
    @IBOutlet var toolbar : UIToolbar!
    @IBOutlet weak var contactlistLable: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var btnBarCancel: UIBarButtonItem!
    @IBOutlet weak var btnBarDone: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIButton!
    var isPrivate : Bool!
    var circle : Circle!
    var objAddContactType : AddContactType!
    var contact : Contact!
    var dicDetail = [String: Any]()
    var isMoreInfoSelected : Bool!
    var dictDetailEdit: NSMutableDictionary!
    var strAssociatedCircleId : NSString!
    var strSelectedContactIndex : Int = 0
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        backToPreviousScreen()
    }
    func circleListAddToContact(arr: NSMutableArray?) {
        dicDetail["associated_circles"] = NSMutableArray()
        dicDetail["associated_circles"] = arr
        let set: NSIndexSet = NSIndexSet(index: 4)
        tbl.beginUpdates()
        tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Fade)
        tbl.endUpdates()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Structures.Constant.appDelegate.isContactUpdated = false
        
        contactlistLable.text=NSLocalizedString(Utility.getKey("contacts"),comment:"")
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        tbl.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tagGestureRecogniser:")
        self.view.addGestureRecognizer(tapGesture)
        
        isMoreInfoSelected = false
        
        self.contactlistLable.font = Utility.setNavigationFont()
        btnSave.titleLabel?.font = Utility.setFont()
        
        
        
        btnCancel.titleLabel?.font = Utility.setFont()
        
        if objAddContactType == AddContactType.AddressBook
        {
            if (contact != nil)
            {
                if contact.firstName.characters.count > 0
                {
                    dicDetail["fname"] = contact.firstName
                }
                else
                {
                    dicDetail["fname"] = ""
                }
                
                if contact.lastName.characters.count > 0
                {
                    dicDetail["lname"] = contact.lastName
                }
                else
                {
                    dicDetail["lname"] = ""
                }
                if contact.email.characters.count > 0
                {
                    let arrEmail: NSArray = contact.email.componentsSeparatedByString(",")
                    dicDetail["emails"] = arrEmail.mutableCopy() as! NSMutableArray
                }
                else
                {
                    dicDetail["emails"] = NSMutableArray()
                }
                if contact.cellPhone.characters.count > 0
                {
                    let arrNumbers: NSArray = contact.cellPhone.componentsSeparatedByString(",")
                    dicDetail["numbers"] = arrNumbers.mutableCopy() as! NSMutableArray
                }
                else
                {
                    dicDetail["numbers"] = NSMutableArray()
                }
                dicDetail["associated_circles"] = NSMutableArray()
                (dicDetail["associated_circles"] as! NSMutableArray).addObject(Structures.Constant.appDelegate.dictSelectToUpdate)
                dicDetail ["sos_enabled"] = "0"
            }
            else
            {
                
                dicDetail["fname"] = ""
                dicDetail["lname"] = ""
                dicDetail["emails"] = NSMutableArray()
                dicDetail["numbers"] = NSMutableArray()
                dicDetail["emailsFriend"] = NSMutableArray()
                dicDetail["associated_circles"] = NSMutableArray()
                (dicDetail["associated_circles"] as! NSMutableArray).addObject(Structures.Constant.appDelegate.dictSelectToUpdate)
                dicDetail ["sos_enabled"] = "0"
                
            }
        }
        else if objAddContactType == AddContactType.Edit
        {
            if (dictDetailEdit != nil)
            {
                if (dictDetailEdit.valueForKey(Structures.User.User_FirstName) as! NSString).length != 0
                {
                    dicDetail["fname"] = dictDetailEdit.valueForKey(Structures.User.User_FirstName) as! NSString
                }
                else
                {
                    dicDetail["fname"] = ""
                }
                if (dictDetailEdit.valueForKey(Structures.User.User_LastName) as! NSString).length != 0
                {
                    dicDetail["lname"] = dictDetailEdit.valueForKey(Structures.User.User_LastName) as! NSString
                }
                else
                {
                    dicDetail["lname"] = ""
                }
                if (dictDetailEdit.valueForKey("emails") as! NSString).length != 0
                {
                    let arrEmail: NSArray = (dictDetailEdit.valueForKey("emails") as! NSString).componentsSeparatedByString(",")
                    dicDetail["emails"] = arrEmail.mutableCopy() as! NSMutableArray
                }
                else
                {
                    dicDetail["emails"] = NSMutableArray()
                }
                if (dictDetailEdit.valueForKey("mobile") as! NSString).length != 0
                {
                    let arrNumbers: NSArray = (dictDetailEdit.valueForKey("mobile") as! NSString).componentsSeparatedByString(",")
                    dicDetail["numbers"] = arrNumbers.mutableCopy() as! NSMutableArray
                }
                else
                {
                    dicDetail["numbers"] = NSMutableArray()
                }
                
                if (dictDetailEdit.valueForKey("sos_enabled")) != nil
                {
                    dicDetail ["sos_enabled"] = (dictDetailEdit.valueForKey("sos_enabled") as! NSString)
                    
                }
                else
                {
                    dicDetail ["sos_enabled"] = "0"
                    
                }
                if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                {
                    dicDetail["associated_circles"] = NSMutableArray()
                    (dicDetail["associated_circles"] as! NSMutableArray).addObject(Structures.Constant.appDelegate.dictSelectToUpdate)
                }
                else
                {
                    if (dictDetailEdit.valueForKey("associated_circles") as! NSArray).count > 0
                    {
                        let arrSOSemails: NSArray = (dictDetailEdit.valueForKey("associated_circles") as! NSArray)
                        dicDetail["associated_circles"] = arrSOSemails.mutableCopy() as! NSMutableArray
                    }
                    else
                    {
                        dicDetail["associated_circles"] = NSMutableArray()
                        
                    }
                }
                
            }
            else
            {
                dicDetail["fname"] = ""
                dicDetail["lname"] = ""
                dicDetail["emails"] = NSMutableArray()
                dicDetail["numbers"] = NSMutableArray()
                dicDetail ["sos_enabled"] = "0"
            }
        }
            
        else if objAddContactType == AddContactType.New
        {
            dicDetail["fname"] = ""
            dicDetail["lname"] = ""
            dicDetail["emails"] = NSMutableArray()
            dicDetail["numbers"] = NSMutableArray()
            dicDetail["emailsFriend"] = NSMutableArray()
            dicDetail["associated_circles"] = NSMutableArray()
            (dicDetail["associated_circles"] as! NSMutableArray).addObject(Structures.Constant.appDelegate.dictSelectToUpdate)
            dicDetail ["sos_enabled"] = "0"
            
        }
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        self.view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool)
    {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            
            btnBack.hidden = true
            ARbtnBack.hidden = false
            btnCancel.setTitle(NSLocalizedString(Utility.getKey("save"),comment:""), forState: .Normal)
            btnCancel.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            btnSave.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
            
            btnBarCancel.title = NSLocalizedString(Utility.getKey("done"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            btnSave.setTitle(NSLocalizedString(Utility.getKey("save"),comment:""), forState: .Normal)
            btnSave.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            btnCancel.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
            
            btnBarCancel.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("done"),comment:"")
        }
        tbl.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func tagGestureRecogniser(sender : UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    func keyboardWillShow(notification : NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: tbl.contentInset.top, left: tbl.contentInset.left, bottom: keyboardSize.height, right:tbl.contentInset.right)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tbl.contentInset = contentInsets
            })
        }
    }
    func keyboardWillChangeFrame(notification : NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: tbl.contentInset.top, left: tbl.contentInset.left, bottom: keyboardSize.height, right:tbl.contentInset.right)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tbl.contentInset = contentInsets
            })
            
        }
    }
    func keyboardWillHide(notification : NSNotification)
    {
        let contentInsets = UIEdgeInsets(top: tbl.contentInset.top, left: tbl.contentInset.left, bottom:0, right:tbl.contentInset.right)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tbl.contentInset = contentInsets
        })
    }
    @IBAction func btnCancelClicked(sender:AnyObject)
    {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            saveContactDetail()
        }
        else
        {
            backToPreviousScreen()
        }
        
    }
    @IBAction func btnDoneClicked(sender:AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            backToPreviousScreen()
        }
        else
        {
            saveContactDetail()
        }
        
    }
    @IBAction func btnToolbarDoneClicked(sender:AnyObject)
    {
        self.view.endEditing(true)
    }
    @IBAction func btnToolbarCancelClicked(sender:AnyObject)
    {
        self.view.endEditing(true)
    }
    
    //MARK:- UITableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return 5
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if  section == 0
        {
            return 2
        }
        else if  section == 1
        {
            if let emails : NSArray! = dicDetail["emails"] as! NSArray
            {
                return  emails.count + 1
            }else{
                return 1;
            }
        }
        else if  section == 2
        {
            if let numbers : NSArray! = dicDetail["numbers"] as! NSArray
            {
                return  numbers.count + 1
            }else{
                return 1;
            }
        }
            
        else if  section == 3
        {
            //Show Enable Friend Unlock Section if contact_type != 2 (2 = not a public contact)
            if objAddContactType == AddContactType.Edit
            {
                if (!(dictDetailEdit["contact_type"] as! NSString).isEqualToString("2")){
                    return  3
                }else{
                    return 1
                }
                
            }else{
                if circle.circleType == CircleType.Private
                {
                    return  3
                }else{
                    return  1
                }
            }
        }
        else if  section == 4
        {
            if let circles : NSArray! = dicDetail["associated_circles"] as! NSArray{
                return  circles.count + 1
            }
            else{
                return 1
            }
        }
        else
        {
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if  (indexPath.section == 0)
        {
            if  indexPath.row == 3
            {
                return 46
            }
            else
            {
                return 43
            }
        }
        else if  (indexPath.section == 3)
        {
            if  (indexPath.row == 1)
            {
                let strInfo : String! = NSLocalizedString(Utility.getKey("allows_contact_to_help"),comment:"")
                let rect = strInfo.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width-100, 999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName :  Utility.setFont()], context: nil)
                let H :CGFloat = rect.height + 40
                return H
                
            }
            else
            {
                return 18
            }
        }
        else
        {
            return 43
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier : String = "cell"
        if Structures.Constant.appDelegate.isArabic == true
        {
            var cell: ARAddContactCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ARAddContactCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("ARAddContactCell", owner: self, options: nil)
                cell = arr[0] as? ARAddContactCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.viewAdd.hidden = true
            cell?.viewBlank.hidden = true
            cell?.viewCircle.hidden = true
            cell?.viewFriendUnblock.hidden = true
            cell?.viewContactIsPart.hidden = true
            cell?.txtTitle.hidden = true
            cell?.lblSep.hidden = true
            cell?.lblSepShort.hidden = true
            cell?.txtTitle.delegate = self
            let arrEmails : NSArray! = dicDetail["emails"] as! NSArray
            let arrNumbers : NSArray! = dicDetail["numbers"] as! NSArray
            let circles : NSArray! = dicDetail["associated_circles"] as! NSArray
            cell?.txtTitle.textColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1)
            if  indexPath.section == 0
            {
                
                cell?.txtTitle.textColor = UIColor.blackColor()
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.Yes
                if  indexPath.row == 3
                {
                    cell?.viewBlank.hidden = false
                }
                else if  indexPath.row == 0 ||  indexPath.row == 1 ||  indexPath.row == 2
                {
                    cell?.txtTitle.hidden = false
                    
                    
                    if  indexPath.row == 0
                    {
                        
                        cell?.lblSepShort.hidden = false
                        cell?.txtTitle.placeholder = NSLocalizedString(Utility.getKey("First name"),comment:"")
                        cell?.txtTitle.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("First name"),comment:""))
                        cell!.txtTitle.text = dicDetail["fname"] as? String
                    }
                    else if  indexPath.row == 1
                    {
                        cell?.lblSepShort.hidden = false
                        cell?.txtTitle.placeholder = NSLocalizedString(Utility.getKey("Last name"),comment:"")
                        cell?.txtTitle.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("Last name"),comment:""))
                        cell!.txtTitle.text = dicDetail["lname"] as? String
                    }
                    cell?.txtTitle.tag = indexPath.row
                }
            }
            else  if  indexPath.section == 1
            {
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                cell?.viewAdd.hidden = false
                cell?.lblTitle.textColor = Utility.UIColorFromHex(0x0F89DC, alpha: 1)
                if arrEmails.count > 0 && indexPath.row < arrEmails.count
                {
                    
                    cell?.lblSep.hidden = false
                    cell?.txtTitle.hidden = true
                    
                    cell!.textEmailPhone.delegate = self
                    cell?.textEmailPhone.hidden = false
                    cell?.textEmailPhone.userInteractionEnabled = true
                    cell?.textEmailPhone.keyboardType = UIKeyboardType.EmailAddress
                    cell?.textEmailPhone.placeholder = (NSLocalizedString(Utility.getKey("Email"),comment:""))
                    cell?.textEmailPhone.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("Email"),comment:""))
                    cell!.textEmailPhone.text = arrEmails.objectAtIndex(indexPath.row ) as? String
                    cell?.textEmailPhone.tag = indexPath.row + 2
                    
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("Email"),comment:""))
                    
                    cell?.btnAdd.accessibilityLabel = String(indexPath.row)
                    cell?.btnAdd.accessibilityIdentifier = String(indexPath.section)
                    cell!.btnAdd.setImage(UIImage(named: "remove.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.addTarget(self, action: "deleteClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                }
                else
                {
                    
                    cell?.txtTitle.hidden = true
                    cell?.textEmailPhone.hidden = true
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("add_email"),comment:""))
                    cell!.btnAdd.setImage(UIImage(named: "add.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.tag = indexPath.section
                    cell!.btnAdd.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell!.btnAddEmailPhone.tag = indexPath.section
                    cell!.btnAddEmailPhone.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                
            }
            else  if  indexPath.section == 2
            {
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                
                cell?.viewAdd.hidden = false
                cell?.lblTitle.textColor = Utility.UIColorFromHex(0x0F89DC, alpha: 1)
                if arrNumbers.count > 0 && indexPath.row < arrNumbers.count
                {
                    cell?.lblSep.hidden = false
                    cell?.txtTitle.hidden = true
                    cell!.textEmailPhone.delegate = self
                    cell?.textEmailPhone.hidden = false
                    cell?.textEmailPhone.userInteractionEnabled = true
                    cell?.textEmailPhone.keyboardType = UIKeyboardType.PhonePad
                    cell?.textEmailPhone.placeholder = NSLocalizedString(Utility.getKey("Phone"),comment:"")
                    cell!.textEmailPhone.text = arrNumbers.objectAtIndex(indexPath.row) as? String
                    cell?.textEmailPhone.tag = indexPath.row + 2 + arrEmails.count
                    cell?.textEmailPhone.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("Phone"),comment:""))
                    
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("Phone"),comment:""))
                    cell?.btnAdd.accessibilityLabel = String(indexPath.row)
                    cell?.btnAdd.accessibilityIdentifier = String(indexPath.section)
                    cell!.btnAdd.setImage(UIImage(named: "remove.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.addTarget(self, action: "deleteClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                }
                else
                {
                    
                    cell?.txtTitle.hidden = true
                    cell?.textEmailPhone.hidden = true
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("add_mobile_for_sms"),comment:""))
                    cell!.btnAdd.setImage(UIImage(named: "add.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.tag = indexPath.section
                    cell!.btnAdd.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell!.btnAddEmailPhone.tag = indexPath.section
                    cell!.btnAddEmailPhone.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
                
            else  if  indexPath.section == 3
            {
                
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                
                if objAddContactType == AddContactType.Edit
                {
                    if (!(dictDetailEdit["contact_type"] as! NSString).isEqualToString("2")){
                        
                        if  indexPath.row == 1
                        {
                            cell?.viewFriendUnblock.hidden = false
                            cell?.txtTitle.hidden = true
                            
                            cell!.btnAddFriend.tag = indexPath.section
                            cell!.btnAddFriend.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            cell!.btnMoreInfo.tag = indexPath.section
                            cell!.btnMoreInfo.addTarget(self, action: "showInfoClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            if dicDetail ["sos_enabled"] as! String == "0"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "unlock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("enable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "1"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "lock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("disable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "2"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "pending.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("pending_friend_unlock"),comment:"")
                            }
                            cell?.lblMoreInfo.text = NSLocalizedString(Utility.getKey("allows_contact_to_help"),comment:"")
                            
                        }
                        else if  indexPath.row == 0 || indexPath.row == 2
                        {
                            cell?.viewBlank.hidden = false
                        }
                    }
                    else if  indexPath.row == 0 || indexPath.row == 2
                    {
                        cell?.viewBlank.hidden = false
                    }
                    
                }else{
                    if circle.circleType == CircleType.Private
                    {
                        
                        if  indexPath.row == 1
                        {
                            cell?.viewFriendUnblock.hidden = false
                            cell?.txtTitle.hidden = true
                            
                            cell!.btnAddFriend.tag = indexPath.section
                            cell!.btnAddFriend.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            cell!.btnMoreInfo.tag = indexPath.section
                            cell!.btnMoreInfo.addTarget(self, action: "showInfoClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            if dicDetail ["sos_enabled"] as! String == "0"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "unlock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("enable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "1"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "lock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("disable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "2"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "pending.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("pending_friend_unlock"),comment:"")
                            }
                            cell?.lblMoreInfo.text = NSLocalizedString(Utility.getKey("allows_contact_to_help"),comment:"")
                            
                        }
                        else if  indexPath.row == 0 || indexPath.row == 2
                        {
                            cell?.viewBlank.hidden = false
                        }
                    }
                    else if  indexPath.row == 0 || indexPath.row == 2
                    {
                        cell?.viewBlank.hidden = false
                    }
                }
                
            }
            else if indexPath.section == 4
            {
                
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                if  indexPath.row == 0
                {
                    cell?.viewContactIsPart.hidden = false
                    cell?.lblContactIsPartOf.text = NSLocalizedString(Utility.getKey("contact_is_part"),comment:"")
                    if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                    {
                        cell?.btnAddCircle.hidden = true
                    }
                    cell?.btnAddCircle.addTarget(self, action: "addCircleClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                else
                {
                    cell?.viewCircle.hidden = false
                    cell?.lblCircleType.hidden = false
                    cell?.btnCircleMark.tag = indexPath.row-1
                    cell?.btnCircleMark.accessibilityLabel = String(indexPath.row-1)
                    cell?.btnCircleMark.selected = true
                    
                    if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                    {
                        
                    }
                    else
                    {
                        cell?.btnCircleMark.addTarget(self, action: "cicleCheckMarkClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    }
                    cell?.lblCircleText.text = circles.objectAtIndex(indexPath.row-1).valueForKey(Structures.Constant.ListName) as? String
                    if circles.objectAtIndex(indexPath.row-1).valueForKey(Structures.User.CircleType) == nil
                    {
                        if circle.circleType == CircleType.Private
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")
                        }
                        else
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")
                        }
                    }
                    else
                    {
                        if circles.objectAtIndex(indexPath.row-1).valueForKey(Structures.User.CircleType) as! NSString == "1"
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")
                        }
                        else
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")
                        }
                    }
                    cell?.lblSepShort.hidden = false
                }
            }
            return cell!
        }
        else
        {
            var cell: AddContactCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? AddContactCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("AddContactCell", owner: self, options: nil)
                cell = arr[0] as? AddContactCell
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.viewAdd.hidden = true
            cell?.viewBlank.hidden = true
            cell?.viewCircle.hidden = true
            cell?.viewFriendUnblock.hidden = true
            cell?.viewContactIsPart.hidden = true
            cell?.txtTitle.hidden = true
            cell?.lblSep.hidden = true
            cell?.lblSepShort.hidden = true
            cell?.txtTitle.delegate = self
            let arrEmails : NSArray! = dicDetail["emails"] as! NSArray
            let arrNumbers : NSArray! = dicDetail["numbers"] as! NSArray
            let circles : NSArray! = dicDetail["associated_circles"] as! NSArray
            cell?.txtTitle.textColor = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1)
            if  indexPath.section == 0
            {
                
                cell?.txtTitle.textColor = UIColor.blackColor()
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.Yes
                if  indexPath.row == 3
                {
                    cell?.viewBlank.hidden = false
                }
                else if  indexPath.row == 0 ||  indexPath.row == 1 ||  indexPath.row == 2
                {
                    cell?.txtTitle.hidden = false
                    
                    
                    if  indexPath.row == 0
                    {
                        
                        cell?.lblSepShort.hidden = false
                        cell?.txtTitle.placeholder = NSLocalizedString(Utility.getKey("First name"),comment:"")
                        cell?.txtTitle.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("First name"),comment:""))
                        cell!.txtTitle.text = dicDetail["fname"] as? String
                    }
                    else if  indexPath.row == 1
                    {
                        cell?.lblSepShort.hidden = false
                        cell?.txtTitle.placeholder = NSLocalizedString(Utility.getKey("Last name"),comment:"")
                        cell?.txtTitle.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("Last name"),comment:""))
                        cell!.txtTitle.text = dicDetail["lname"] as? String
                    }
                    cell?.txtTitle.tag = indexPath.row
                }
            }
            else  if  indexPath.section == 1
            {
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                cell?.viewAdd.hidden = false
                cell?.lblTitle.textColor = Utility.UIColorFromHex(0x0F89DC, alpha: 1)
                if arrEmails.count > 0 && indexPath.row < arrEmails.count
                {
                    
                    cell?.lblSep.hidden = false
                    cell?.txtTitle.hidden = true
                    
                    cell!.textEmailPhone.delegate = self
                    cell?.textEmailPhone.hidden = false
                    cell?.textEmailPhone.userInteractionEnabled = true
                    cell?.textEmailPhone.keyboardType = UIKeyboardType.EmailAddress
                    cell?.textEmailPhone.placeholder = (NSLocalizedString(Utility.getKey("Email"),comment:""))
                    cell?.textEmailPhone.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("Email"),comment:""))
                    cell!.textEmailPhone.text = arrEmails.objectAtIndex(indexPath.row ) as? String
                    cell?.textEmailPhone.tag = indexPath.row + 2
                    
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("Email"),comment:""))
                    
                    cell?.btnAdd.accessibilityLabel = String(indexPath.row)
                    cell?.btnAdd.accessibilityIdentifier = String(indexPath.section)
                    cell!.btnAdd.setImage(UIImage(named: "remove.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.addTarget(self, action: "deleteClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                }
                else
                {
                    
                    cell?.txtTitle.hidden = true
                    cell?.textEmailPhone.hidden = true
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("add_email"),comment:""))
                    cell!.btnAdd.setImage(UIImage(named: "add.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.tag = indexPath.section
                    cell!.btnAdd.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell!.btnAddEmailPhone.tag = indexPath.section
                    cell!.btnAddEmailPhone.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                
            }
            else  if  indexPath.section == 2
            {
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                
                cell?.viewAdd.hidden = false
                cell?.lblTitle.textColor = Utility.UIColorFromHex(0x0F89DC, alpha: 1)
                if arrNumbers.count > 0 && indexPath.row < arrNumbers.count
                {
                    cell?.lblSep.hidden = false
                    cell?.txtTitle.hidden = true
                    cell!.textEmailPhone.delegate = self
                    cell?.textEmailPhone.hidden = false
                    cell?.textEmailPhone.userInteractionEnabled = true
                    cell?.textEmailPhone.keyboardType = UIKeyboardType.PhonePad
                    cell?.textEmailPhone.placeholder = NSLocalizedString(Utility.getKey("Phone"),comment:"")
                    cell!.textEmailPhone.text = arrNumbers.objectAtIndex(indexPath.row) as? String
                    cell?.textEmailPhone.tag = indexPath.row + 2 + arrEmails.count
                    cell?.textEmailPhone.accessibilityIdentifier = (NSLocalizedString(Utility.getKey("Phone"),comment:""))
                    
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("Phone"),comment:""))
                    cell?.btnAdd.accessibilityLabel = String(indexPath.row)
                    cell?.btnAdd.accessibilityIdentifier = String(indexPath.section)
                    cell!.btnAdd.setImage(UIImage(named: "remove.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.addTarget(self, action: "deleteClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                }
                else
                {
                    
                    cell?.txtTitle.hidden = true
                    cell?.textEmailPhone.hidden = true
                    cell?.lblTitle.text = (NSLocalizedString(Utility.getKey("add_mobile_for_sms"),comment:""))
                    cell!.btnAdd.setImage(UIImage(named: "add.png"), forState: UIControlState.Normal)
                    cell!.btnAdd.tag = indexPath.section
                    cell!.btnAdd.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell!.btnAddEmailPhone.tag = indexPath.section
                    cell!.btnAddEmailPhone.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
                
            else  if  indexPath.section == 3
            {
                
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                
                if objAddContactType == AddContactType.Edit
                {
                    if (!(dictDetailEdit["contact_type"] as! NSString).isEqualToString("2")){
                        
                        if  indexPath.row == 1
                        {
                            cell?.viewFriendUnblock.hidden = false
                            cell?.txtTitle.hidden = true
                            
                            cell!.btnAddFriend.tag = indexPath.section
                            cell!.btnAddFriend.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            cell!.btnMoreInfo.tag = indexPath.section
                            cell!.btnMoreInfo.addTarget(self, action: "showInfoClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            if dicDetail ["sos_enabled"] as! String == "0"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "unlock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("enable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "1"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "lock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("disable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "2"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "pending.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("pending_friend_unlock"),comment:"")
                            }
                            cell?.lblMoreInfo.text = NSLocalizedString(Utility.getKey("allows_contact_to_help"),comment:"")
                            
                        }
                        else if  indexPath.row == 0 || indexPath.row == 2
                        {
                            cell?.viewBlank.hidden = false
                        }
                    }
                    else if  indexPath.row == 0 || indexPath.row == 2
                    {
                        cell?.viewBlank.hidden = false
                    }
                    
                }else{
                    if circle.circleType == CircleType.Private
                    {
                        
                        if  indexPath.row == 1
                        {
                            cell?.viewFriendUnblock.hidden = false
                            cell?.txtTitle.hidden = true
                            
                            cell!.btnAddFriend.tag = indexPath.section
                            cell!.btnAddFriend.addTarget(self, action: "addDetailClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            cell!.btnMoreInfo.tag = indexPath.section
                            cell!.btnMoreInfo.addTarget(self, action: "showInfoClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                            
                            if dicDetail ["sos_enabled"] as! String == "0"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "unlock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("enable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "1"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "lock.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("disable_friend_unlock"),comment:"")
                            }
                            else if dicDetail ["sos_enabled"] as! String == "2"
                            {
                                cell?.btnAddFriend.setImage(UIImage(named: "pending.png"), forState: UIControlState.Normal)
                                cell?.friendUnlockLabel.text = NSLocalizedString(Utility.getKey("pending_friend_unlock"),comment:"")
                            }
                            cell?.lblMoreInfo.text = NSLocalizedString(Utility.getKey("allows_contact_to_help"),comment:"")
                            
                        }
                        else if  indexPath.row == 0 || indexPath.row == 2
                        {
                            cell?.viewBlank.hidden = false
                        }
                    }
                    else if  indexPath.row == 0 || indexPath.row == 2
                    {
                        cell?.viewBlank.hidden = false
                    }
                }
                
            }
            else if indexPath.section == 4
            {
                
                cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
                if  indexPath.row == 0
                {
                    cell?.viewContactIsPart.hidden = false
                    cell?.lblContactIsPartOf.text = NSLocalizedString(Utility.getKey("contact_is_part"),comment:"")
                    if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                    {
                        cell?.btnAddCircle.hidden = true
                    }
                    cell?.btnAddCircle.addTarget(self, action: "addCircleClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                else
                {
                    cell?.viewCircle.hidden = false
                    cell?.lblCircleType.hidden = false
                    cell?.btnCircleMark.tag = indexPath.row-1
                    cell?.btnCircleMark.accessibilityLabel = String(indexPath.row-1)
                    cell?.btnCircleMark.selected = true
                    
                    if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                    {
                        
                    }
                    else
                    {
                        cell?.btnCircleMark.addTarget(self, action: "cicleCheckMarkClicked:", forControlEvents: UIControlEvents.TouchUpInside)
                    }
                    cell?.lblCircleText.text = circles.objectAtIndex(indexPath.row-1).valueForKey(Structures.Constant.ListName) as? String
                    if circles.objectAtIndex(indexPath.row-1).valueForKey(Structures.User.CircleType) == nil
                    {
                        if circle.circleType == CircleType.Private
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")
                        }
                        else
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")
                        }
                    }
                    else
                    {
                        if circles.objectAtIndex(indexPath.row-1).valueForKey(Structures.User.CircleType) as! NSString == "1"
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")
                        }
                        else
                        {
                            cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")
                        }
                    }
                    cell?.lblSepShort.hidden = false
                }
            }
            return cell!
        }
        
    }
    
    func backToPreviousScreen()
    {
        if objAddContactType == .Edit
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
            {
                let arrVcs : NSArray! = self.navigationController!.viewControllers as NSArray
                var vc :Step2_CreateAccountVC
                for var i : Int = 0 ; i < arrVcs.count ; i++
                {
                    if  arrVcs.objectAtIndex(i) .isKindOfClass(Step2_CreateAccountVC)
                    {
                        vc  = arrVcs[i] as! Step2_CreateAccountVC
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
            else
            {
                let arrVcs : NSArray! = self.navigationController!.viewControllers as NSArray
                var vc :EditCircleVC
                for var i : Int = 0 ; i < arrVcs.count ; i++
                {
                    if  arrVcs.objectAtIndex(i) .isKindOfClass(EditCircleVC)
                    {
                        vc  = arrVcs[i] as! EditCircleVC
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if  segue.identifier == "addCircleToContactPush"
        {
            let vc : CircleListVC = segue.destinationViewController as! CircleListVC
            vc.delegate = self
            
            if objAddContactType == .Edit
            {
                vc.contact_Id = dictDetailEdit.valueForKey("contact_id") as! NSString
                vc.arrSelected = dicDetail["associated_circles"] as! NSMutableArray
            }
            else
            {
                vc.contact_Id = ""
                vc.arrSelected = dicDetail["associated_circles"] as! NSMutableArray
            }
            vc.circle = self.circle
        }
    }
    //MARK:- Commont Method For Contact
    func showInfoClicked(sender:AnyObject)
    {
        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("about_friend_unlock_title"),comment:""), strMessage: NSLocalizedString(Utility.getKey("must_enable_app_unlock1"),comment:"") + "\n\n" + NSLocalizedString(Utility.getKey("must_enable_app_unlock2"),comment:""), strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
    }
    func cicleCheckMarkClicked(sender:AnyObject)
    {
        let btn : UIButton = sender as! UIButton
        if let strIndex : NSString = btn.accessibilityLabel!{
            let arr : NSMutableArray! =  dicDetail["associated_circles"] as! NSMutableArray
            arr.removeObjectAtIndex(strIndex.integerValue)
            dicDetail["associated_circles"] = arr
            let set: NSIndexSet = NSIndexSet(index: 4)
            tbl.beginUpdates()
            tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Fade)
            tbl.endUpdates()
        }
    }
    func addCircleClicked(sender:AnyObject)
    {
        
        [self.performSegueWithIdentifier("addCircleToContactPush", sender: nil)]
    }
    func moreInfoClicked(sender:AnyObject)
    {
        isMoreInfoSelected = !isMoreInfoSelected
        let set: NSIndexSet = NSIndexSet(index: 3)
        tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.None)
    }
    
    func deleteClicked(sender:AnyObject)
    {
        let btn : UIButton = sender as! UIButton
        if let strSection : NSString = btn.accessibilityIdentifier{
            if let strIndex : NSString = btn.accessibilityLabel!{
                if strSection == "1"
                {
                    let arr : NSMutableArray! =  dicDetail["emails"] as! NSMutableArray
                    arr.removeObjectAtIndex(strIndex.integerValue)
                    let set: NSIndexSet = NSIndexSet(index: 1)
                    tbl.beginUpdates()
                    tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Fade)
                    tbl.endUpdates()
                }
                else if strSection == "2"
                {
                    let arr : NSMutableArray! = dicDetail["numbers"] as! NSMutableArray
                    arr.removeObjectAtIndex(strIndex.integerValue)
                    let set: NSIndexSet = NSIndexSet(index: 2)
                    tbl.beginUpdates()
                    tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Fade)
                    tbl.endUpdates()
                }
            }
        }
    }
    func addDetailClicked(sender:AnyObject)
    {
        let btn : UIButton! = sender as! UIButton
        if  btn.tag == 2
        {
            let arr : NSMutableArray! =  dicDetail["numbers"] as! NSMutableArray
            arr.insertObject("", atIndex: 0)
            let set: NSIndexSet = NSIndexSet(index: 2)
            tbl.beginUpdates()
            tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Fade)
            tbl.endUpdates()
        }
            
        else if  btn.tag == 1
        {
            let arr : NSMutableArray! =  dicDetail["emails"] as! NSMutableArray
            arr.insertObject("", atIndex: 0)
            let set: NSIndexSet = NSIndexSet(index: 1)
            tbl.beginUpdates()
            tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.Fade)
            tbl.endUpdates()
        }
        else if  btn.tag == 3
        {
            if dicDetail ["sos_enabled"] as! String == "0"
            {
                dicDetail ["sos_enabled"] = "2"
                loadFriendUnlock()
            }
            else if dicDetail ["sos_enabled"] as! String == "2"
            {
                dicDetail ["sos_enabled"] = "0"
                loadFriendUnlock()
            }
            else if  dicDetail ["sos_enabled"] as! String == "1"
            {
                
                let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString(Utility.getKey("are_you_sure"),comment:"") , message: nil , preferredStyle: .Alert)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel)
                    { action -> Void in
                }
                let Ok: UIAlertAction = UIAlertAction(title:NSLocalizedString(Utility.getKey("yes"),comment:"") , style: .Default) { action -> Void in
                    self.dicDetail ["sos_enabled"] = "0"
                    self.loadFriendUnlock()
                }
                
                if Structures.Constant.appDelegate.isArabic == true
                {
                    actionSheetController.addAction(Ok)
                    actionSheetController.addAction(cancelAction)
                }
                else
                {
                    actionSheetController.addAction(cancelAction)
                    actionSheetController.addAction(Ok)
                }
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
        }
    }
    func loadFriendUnlock()
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let set: NSIndexSet = NSIndexSet(index: 3)
            self.tbl.reloadSections(set, withRowAnimation: UITableViewRowAnimation.None)
        })
    }
    //MARK: Save Contact
    func saveContactDetail()
    {
        
        var  fname : String!  = dicDetail["fname"] as! String
        var  lname : String!  = dicDetail["lname"] as! String
        fname = fname.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        lname = lname.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let emails : NSMutableArray! = dicDetail["emails"] as! NSMutableArray
        let numbers : NSMutableArray! = dicDetail["numbers"] as! NSMutableArray
        
        let arrEmail  : NSMutableArray! = emails.mutableCopy() as! NSMutableArray
        let arrNumbers  : NSMutableArray! = numbers.mutableCopy() as! NSMutableArray
        
        arrEmail.removeObject("")
        arrNumbers.removeObject("")
        
        for (var i : Int = 0 ; i < arrEmail.count ; i++)
        {
            let strEmail = arrEmail.objectAtIndex(i) as! String
            
            if  (Utility.isValidEmail(strEmail) == false)
            {
                let strMsg : NSString = NSString(format: NSLocalizedString(Utility.getKey("email_is_wrong"),comment:"") , strEmail)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    Utility.showAlertWithTitle(strMsg as String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                })
                return
            }
            
        }
        if fname.characters.count == 0
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("first_name_mandatory"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                
            })
        }
        else if lname.characters.count == 0
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("last_name_mandatory"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            })
        }
        else if arrEmail.count <= 0
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("please_enter_email1"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            })
        }
        else if arrNumbers.count <= 0
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("please_enter_phone"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            })
        }
        else
        {
            if  (contact == nil)
            {
                contact = Contact()
            }
            contact.firstName = dicDetail["fname"] as! String
            contact.lastName = dicDetail["lname"] as! String
            contact.email = CommonUnit.getStingFromArray(arrEmail, join: ",")
            contact.cellPhone = CommonUnit.getStingFromArray(arrNumbers, join: ",")
            
            let arrSOSemails: NSArray = dicDetail["associated_circles"] as! NSArray
            
            
            if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount || objAddContactType == .AddressBook ||  objAddContactType == .New
            {
                SVProgressHUD.show()
                
                let dic : NSMutableDictionary = NSMutableDictionary()
                dic ["contact_id"] = ""
                dic [Structures.User.User_FirstName] = dicDetail["fname"] as! String
                dic [Structures.User.User_LastName] = dicDetail["lname"] as! String
                dic ["mobile"] = CommonUnit.getStingFromArray(arrNumbers, join: ",")
                dic ["emails"] = CommonUnit.getStingFromArray(arrEmail, join: ",")
                dic ["sos_enabled"] = dicDetail ["sos_enabled"] as! String
                dic ["contact_type"] = "1"
                
                if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                {
                    
                    let name1 : String = (dicDetail["fname"] as! NSString as String) + " " + (dicDetail["lname"] as! String)
                    let name2 : String = (dicDetail["lname"] as! String) + " " + (dicDetail["fname"] as! String)
                    
                    var name11 : String  = ""
                    var name22 : String = ""
                    
                    var strMessage : String!
                    var isContactExist : Bool = false
                    
                    
                    for (var i : Int = 0; i < (Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).count; i++) {
                        if i != strSelectedContactIndex
                        {
                            name11 = ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i)[Structures.User.User_FirstName] as! String) + " " + ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i)[Structures.User.User_LastName] as! String)
                            
                            name22 = ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i)[Structures.User.User_LastName] as! String) + " " + ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i)[Structures.User.User_FirstName] as! String)
                            
                            
                            if (name1 == name11 || name1 == name22 || name2 == name11 || name2 == name22) {
                                strMessage = NSLocalizedString(Utility.getKey("duplicate_name"),comment:"")
                                isContactExist = true
                                break
                            } else if  ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i)["emails"] as! String) == CommonUnit.getStingFromArray(arrEmail, join: ",") {
                                strMessage = NSLocalizedString(Utility.getKey("duplicate_email"),comment:"")
                                isContactExist = true
                                break
                            } else if ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i)["mobile"] as! NSString).containsString(CommonUnit.getStingFromArray(arrNumbers, join: ","))
                            {
                                strMessage = NSLocalizedString(Utility.getKey("duplicate_number"),comment:"")
                                isContactExist = true
                                break
                            }
                        }
                    }
                    
                    if isContactExist == true {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            Utility.showAlertWithTitle(strMessage, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                        })
                    }
                    else{
                        if objAddContactType == .Edit{
                            let myArr : NSMutableArray = (Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).mutableCopy() as! NSMutableArray
                            myArr.replaceObjectAtIndex(strSelectedContactIndex, withObject: dic)
                            Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] = myArr
                        }
                        else{
                            Structures.Constant.appDelegate.dictSignUpCircle["Contacts"]?.addObject(dic)
                        }
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                            SVProgressHUD.dismiss()
                            
                            let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString(Utility.getKey("contact_added"),comment:"") , message: NSLocalizedString(Utility.getKey("add_another"),comment:"") , preferredStyle: .Alert)
                            let no: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("no"),comment:""), style: .Cancel)
                                { action -> Void in
                                    
                                    let vc : Step3_CreateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step3_CreateAccountVC") as! Step3_CreateAccountVC
                                    vc.circle =  self.circle!
                                    self.showViewController(vc, sender: self.view)
                            }
                            let add: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("add"),comment:"") , style: .Default) { action -> Void in
                                self.backToPreviousScreen()
                            }
                            if Structures.Constant.appDelegate.isArabic == true
                            {
                                actionSheetController.addAction(add)
                                actionSheetController.addAction(no)
                            }
                            else
                            {
                                actionSheetController.addAction(no)
                                actionSheetController.addAction(add)
                            }
                            self.presentViewController(actionSheetController, animated: true, completion: nil)
                        })
                    }
                }
                else
                {
                    
                    let contactlist_id: NSMutableArray! = NSMutableArray()
                    for (var i : Int = 0 ; i < arrSOSemails.count ; i++ )
                    {
                        var str : NSString!
                        if (arrSOSemails.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID)) != nil
                        {
                            str  = (arrSOSemails.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID)) as! NSString
                        }
                        else if (arrSOSemails.objectAtIndex(i).valueForKey(Structures.AppKeys.ID)) != nil
                        {
                            str = (arrSOSemails.objectAtIndex(i).valueForKey(Structures.AppKeys.ID)) as! NSString
                        }
                        contactlist_id.insertObject(str, atIndex: i)
                    }
                    
                    dic ["associated_id"] = CommonUnit.getStingFromArray(contactlist_id, join: ",")
                    
                    let wsObj : WSClient = WSClient()
                    wsObj.delegate = self
                    wsObj.createSingleContact(dic)
                }
            }
            else if objAddContactType == .Edit
            {
                
                SVProgressHUD.show()
                
                
                let contactlist_id: NSMutableArray! = NSMutableArray()
                for (var i : Int = 0 ; i < arrSOSemails.count ; i++ )
                {
                    var str : NSString!
                    if (arrSOSemails.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID)) != nil
                    {
                        str  = (arrSOSemails.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID)) as! NSString
                    }
                    else if (arrSOSemails.objectAtIndex(i).valueForKey(Structures.AppKeys.ID)) != nil
                    {
                        str = (arrSOSemails.objectAtIndex(i).valueForKey(Structures.AppKeys.ID)) as! NSString
                    }
                    contactlist_id.insertObject(str, atIndex: i)
                }
                
                if contactlist_id.count == 0
                {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("add_associate_circle"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                    })
                    return
                }
                let dic : NSMutableDictionary = NSMutableDictionary()
                dic ["contact_id"] = dictDetailEdit.valueForKey("contact_id") as! NSString
                dic [Structures.User.User_FirstName] = dicDetail["fname"] as! String
                dic [Structures.User.User_LastName] = dicDetail["lname"] as! String
                dic ["mobile"] = CommonUnit.getStingFromArray(arrNumbers, join: ",")
                dic ["emails"] = CommonUnit.getStingFromArray(arrEmail, join: ",")
                dic ["sos_enabled"] = dicDetail ["sos_enabled"] as! String
                dic ["associated_id"] = CommonUnit.getStingFromArray(contactlist_id, join: ",")
                let wsObj : WSClient = WSClient()
                wsObj.delegate = self
                wsObj.createSingleContact(dic)
            }
            
        }
    }
    //MARK:- UItextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField)
    {
        textField.inputAccessoryView = toolbar
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        if textField.accessibilityIdentifier != nil
        {
            if textField.accessibilityIdentifier == (NSLocalizedString(Utility.getKey("Email"),comment:""))
            {
                let newLength = textField.text!.characters.count + string.characters.count - range.length
                return newLength <= 100
            }
            else if textField.accessibilityIdentifier == (NSLocalizedString(Utility.getKey("First name"),comment:"")) ||  textField.accessibilityIdentifier == (NSLocalizedString(Utility.getKey("Last name"),comment:""))
            {
                let newLength = textField.text!.characters.count + string.characters.count - range.length
                if newLength > 25
                {
                    textField.resignFirstResponder()
                    
                    Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("Could_not_More_Than_25_Character"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                    
                    return newLength <= 25
                }
                else
                {
                    return newLength <= 25
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        if textField.accessibilityIdentifier != nil
        {
            if textField.accessibilityIdentifier == (NSLocalizedString(Utility.getKey("Email"),comment:""))
            {
                if  !Utility.isValidEmail(textField.text!){
                    Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("please_enter_valid_email"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                    
                    textField.text = nil
                }
            }
            else if textField.accessibilityIdentifier == (NSLocalizedString(Utility.getKey("First name"),comment:"")) ||  textField.accessibilityIdentifier == (NSLocalizedString(Utility.getKey("Last name"),comment:""))
            {
            }
        }
        
        let arrEmails : NSMutableArray! = dicDetail["emails"] as! NSMutableArray
        let arrNumbers : NSMutableArray! = dicDetail["numbers"] as! NSMutableArray
        
        if  textField.tag == 0
        {
            dicDetail["fname"] = textField.text
        }
        else if  textField.tag == 1
        {
            dicDetail["lname"] = textField.text
        }
            
        else if textField.tag < arrEmails.count + 2
        {
            // email
            let index : Int = textField.tag - 2
            arrEmails.replaceObjectAtIndex(index, withObject: textField.text!)
        }
            
        else if textField.tag < arrNumbers.count +  arrEmails.count  + 2
        {
            // number
            let index : Int = textField.tag - arrEmails.count - 2
            arrNumbers.replaceObjectAtIndex(index, withObject: textField.text!)
        }
        tbl.reloadData()
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
                if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    //AddContact response
                    if type == WSRequestType.GetContactList
                    {
                        SVProgressHUD.dismiss()
                        
                        Structures.Constant.appDelegate.isContactUpdated = true
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            let alertControl: UIAlertController = UIAlertController(title: dic.objectForKey(Structures.Constant.Message) as? String , message: nil , preferredStyle: .Alert)
                            let Ok: UIAlertAction = UIAlertAction(title:NSLocalizedString(Utility.getKey("yes"),comment:"") , style: .Default) { action -> Void in
                                self.backToPreviousScreen()
                            }
                            alertControl.addAction(Ok)
                            self.presentViewController(alertControl, animated: true, completion: nil)
                        }
                        else if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 2
                        {
                            let actionSheetController: UIAlertController = UIAlertController(title: dic.objectForKey(Structures.Constant.Message) as? String, message: nil , preferredStyle: .Alert)
                            let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel)
                                { action -> Void in
                                    
                                    self.backToPreviousScreen()
                            }
                            let Ok: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("addnow"),comment:"") , style: .Default) { action -> Void in
                            }
                            if Structures.Constant.appDelegate.isArabic == true
                            {
                                actionSheetController.addAction(cancelAction)
                                actionSheetController.addAction(Ok)
                            }
                            else
                            {
                                actionSheetController.addAction(Ok)
                                actionSheetController.addAction(cancelAction)
                            }
                            self.presentViewController(actionSheetController, animated: true, completion: nil)
                        }
                        else if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3")
                        {
                            if dic.valueForKey(Structures.Constant.Message) != nil
                            {
                                Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                            }
                        }
                        else
                        {
                            Utility.showAlertWithTitle(dic.objectForKey(Structures.Constant.Message) as! String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
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
        
        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        
        
    }
}
