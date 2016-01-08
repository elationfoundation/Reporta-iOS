//
//  Step2_CreateAccountVC.swift
//  IWMF
//
//  This class is used for display Step-2 of Create Account.
//
//

import UIKit

class Step2_CreateAccountVC: UIViewController, UIAlertViewDelegate{
    @IBOutlet var tbl : UITableView!
    @IBOutlet weak var ARbtnNavBack: UIButton!
    @IBOutlet weak var btnNavBack: UIButton!
    @IBOutlet weak var contactlistLable: UILabel!
        var createAccntArr : NSMutableArray!
    var isEditContactList : Bool!
    var isEditContactClicked : Bool!
    var circle : Circle!
    var contactList : ContactList!
    var dicCircleOriginal = [String: Any]()
    var selectedIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNavBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        ARbtnNavBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        contactlistLable.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
        isEditContactClicked = true
        createAccntArr = NSMutableArray()
        
        var cell: NextFooterTableViewCell? = tbl.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.nextFooterCellIdentifier) as? NextFooterTableViewCell
        let arr : NSArray = NSBundle.mainBundle().loadNibNamed("NextFooterTableViewCell", owner: self, options: nil)
        cell = arr[0] as?  NextFooterTableViewCell
        cell?.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 80)
        cell?.nextBtn.addTarget(self, action: "btnAddCircleClicked:", forControlEvents: .TouchUpInside)
        cell?.nextBtn.setTitle(NSLocalizedString(Utility.getKey("Next"),comment:""), forState: .Normal)
        tbl.tableFooterView = cell
        self.tbl.reloadData()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadDataFromPlist()
        })
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnNavBack.hidden = true
        }
        else
        {
            ARbtnNavBack.hidden = true
        }
        
        self.contactlistLable.font = Utility.setNavigationFont()
        
        if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
        {
            self.contactlistLable.text = NSLocalizedString(Utility.getKey("create_account_header"),comment:"")
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tbl.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
        self.tbl.registerNib(UINib(nibName: "HelpTextViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier)
        self.tbl.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        self.tbl.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
    }
    
    
    override func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tbl.reloadData()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        backToPreviousScreen()
    }
    
    func backToPreviousScreen()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func loadDataFromPlist()
    {
        if let path = NSBundle.mainBundle().pathForResource("Step2_CreateAccount", ofType: "plist")
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
                        }
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
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
    }
    @IBAction func btnAddContactClicked(sender:AnyObject)
    {
        let indexpath = sender as! NSIndexPath;
        // tag - 1 manually , 2- address book
        
        if  indexpath.row == 4
        {
            self.performSegueWithIdentifier("AddFromAddressBookPush", sender: nil);
        }
        else
        {
            isEditContactClicked = false
            self.performSegueWithIdentifier("AddManuallyPush", sender: nil);
        }
    }
    
    @IBAction func btnCancelCircleClicked(sender:AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func btnAddCircleClicked(sender:AnyObject)
    {
        if (Structures.Constant.appDelegate.dictSignUpCircle?.valueForKey("Contacts") as! NSArray).count > 0
        {
            let vc : Step3_CreateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step3_CreateAccountVC") as! Step3_CreateAccountVC
            vc.circle =  self.circle!
            showViewController(vc, sender: self.view)
        }
        else
        {
            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("no_contact_added"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.createAccntArr.count > 0{
            return (Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSArray).count + self.createAccntArr.count
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if self.createAccntArr.count > 0{
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4
            {
                if  (self.createAccntArr[indexPath.row]["CellIdentifier"] as! NSString) == Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier
                {
                    let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier) as! HelpTextViewCell!
                    
                    cell.txtHelpTextView.frame = CGRectMake(cell.txtHelpTextView.frame.origin.x, cell.txtHelpTextView.frame.origin.y, tableView.frame.size.width - 60, cell.txtHelpTextView.frame.size.height)
                    
                    cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("a_private_circle1"),comment:"") , string: NSLocalizedString(Utility.getKey("a_private_circle1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("a_private_circle2"),comment:""), fontName: cell.txtHelpTextView.font)
                    
                    cell.txtHelpTextView.sizeToFit()
                    
                    return cell.txtHelpTextView.frame.size.height + 60
                }
                
                let kRowHeight = self.createAccntArr[indexPath.row]["RowHeight"] as! CGFloat
                return kRowHeight
            }
            else
            {
                return 46
            }
        }
        return 46
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4
        {
            let kCellIdentifier = self.createAccntArr[indexPath.row]["CellIdentifier"] as! String
            if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "TitleTableViewCellIdentifier"
            {
                if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARTitleTableViewCellIdentifier") as? ARTitleTableViewCell
                {
                    cell.lblDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                    cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
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
                    cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
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
            
            if let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? HelpTextViewCell
            {
                cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("a_private_circle1"),comment:"") , string: NSLocalizedString(Utility.getKey("a_private_circle1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("a_private_circle2"),comment:""), fontName: cell.txtHelpTextView.font)
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
        else
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
            cell?.btnLock.hidden = true
            if circle.circleType == CircleType.Private
            {
                let strStatus : NSString = ((Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSArray).objectAtIndex(indexPath.row - self.createAccntArr.count).valueForKey("sos_enabled") as! NSString)
                cell?.btnLock.contentMode = UIViewContentMode.ScaleAspectFill
                if strStatus == "2"
                {
                    cell?.btnLock.setImage(UIImage(named: "pending.png") as UIImage?, forState: .Normal)
                    cell?.btnLock.hidden = false
                }
            }
            cell?.lblTopLineFull.hidden = true
            cell?.lblName.textColor =  UIColor(red:87/255, green:87/255, blue:87/255, alpha:1.0)
            cell?.lblName.text = ((Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSArray).objectAtIndex(indexPath.row - self.createAccntArr.count).valueForKey("firstname") as! String) + " " + ((Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSArray).objectAtIndex(indexPath.row - self.createAccntArr.count).valueForKey(Structures.User.User_LastName) as! String)
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4
        {
            if indexPath.row == 2 || indexPath.row == 4
            {
                btnAddContactClicked(indexPath)
            }
        }
        else
        {
            selectedIndex = indexPath.row - self.createAccntArr.count;
            isEditContactClicked = true;
            self.performSegueWithIdentifier("AddManuallyPush", sender: nil);
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        if indexPath.row > 5
        {
            return UITableViewCellEditingStyle.Delete;
        }
        return UITableViewCellEditingStyle.None;
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath : NSIndexPath)
    {
        
        self.tbl.reloadData()
        selectedIndex = (forRowAtIndexPath.row - self.createAccntArr.count)
        let alert : UIAlertView! = UIAlertView(title: NSLocalizedString(Utility.getKey("delete_contact_msg"),comment:""), message: "" , delegate: self,cancelButtonTitle: NSLocalizedString(Utility.getKey("no"),comment:""), otherButtonTitles: NSLocalizedString(Utility.getKey("yes"),comment:""));
        alert.tag = 1;
        alert.show()
    }
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int)
    {
        if  alertView.tag == 1
        {
            if  buttonIndex == 1
            {
                let arr : NSMutableArray = Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSMutableArray
                arr.removeObjectAtIndex(selectedIndex)
                Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] = arr
                tbl.reloadData()
            }
        }
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "AddFromAddressBookPush"
        {
            let vc : AllContactsListVC = segue.destinationViewController as! AllContactsListVC
            vc.objContactViewType =  contactViewType.FromAddressBook
            vc.circle  = self.circle
        }
        else if segue.identifier == "AddManuallyPush"
        {
            
            if isEditContactClicked == true
            {
                let vc : AddContactViewController = segue.destinationViewController as! AddContactViewController;
                vc.dictDetailEdit =  (Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSMutableArray).objectAtIndex(selectedIndex) as! NSMutableDictionary
                vc.strSelectedContactIndex = selectedIndex
                vc.circle = self.circle
                vc.objAddContactType = AddContactType.Edit
            }
            else
            {
                let vc : AddContactViewController = segue.destinationViewController as! AddContactViewController;
                vc.circle = self.circle
                vc.objAddContactType = AddContactType.New
            }
        }
    }
}


