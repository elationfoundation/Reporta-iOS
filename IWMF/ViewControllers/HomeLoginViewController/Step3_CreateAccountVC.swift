//
//  Step3_CreateAccountVC.swift
//  IWMF
//
//  This class is used for display Step-3 of Create Account.
//
//

import UIKit

class Step3_CreateAccountVC: UIViewController {
    @IBOutlet var tbl : UITableView!
    @IBOutlet weak var ARbtnNavBack: UIButton!
    @IBOutlet weak var btnNavBack: UIButton!
    @IBOutlet weak var contactlistLable: UILabel!
        var createAccntArr : NSMutableArray!
    var circle : Circle!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNavBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        ARbtnNavBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        contactlistLable.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
        
        createAccntArr = NSMutableArray()
        
        var cell: NextFooterTableViewCell? = tbl.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.nextFooterCellIdentifier) as? NextFooterTableViewCell
        let arr : NSArray = NSBundle.mainBundle().loadNibNamed("NextFooterTableViewCell", owner: self, options: nil)
        cell = arr[0] as?  NextFooterTableViewCell
        cell?.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 80)
        cell?.nextBtn.addTarget(self, action: "btnNextClicked:", forControlEvents: .TouchUpInside)
        cell?.nextBtn.setTitle(NSLocalizedString(Utility.getKey("Next"),comment:""), forState: .Normal)
        tbl.tableFooterView = cell
        
        tbl.reloadData()
        
        
        if let path = NSBundle.mainBundle().pathForResource("Step3_CreateAccount", ofType: "plist")
        {
            createAccntArr = NSMutableArray(contentsOfFile: path)
            let arrTemp : NSMutableArray = NSMutableArray(array: createAccntArr)
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        let strOptionTitle = innerDict["OptionTitle"] as! String!
                        if strOptionTitle != nil
                        {
                            if strOptionTitle == "Edit"
                            {
                                innerDict["OptionTitle"] = NSLocalizedString(Utility.getKey("Edit"),comment:"")
                            }
                        }
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        }
        
        //Arabic Alignment
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
        
        self.tbl.registerNib(UINib(nibName: "HelpTextViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier)
        self.tbl.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        self.tbl.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tbl.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
    }
    override func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool)
    {
        tbl.reloadData()
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
        let arrVcs : NSArray! = self.navigationController!.viewControllers as NSArray
        var vc :Step2_CreateAccountVC
        for var i : Int = 0 ; i < arrVcs.count ; i++
        {
            if  arrVcs.objectAtIndex(i) .isKindOfClass(Step2_CreateAccountVC)
            {
                vc  = arrVcs[i] as! Step2_CreateAccountVC
                self.navigationController?.popToViewController(vc, animated: true)
                break;
            }
        }
    }
    @IBAction func btnNextClicked(sender:AnyObject)
    {
        if (Structures.Constant.appDelegate.dictSignUpCircle?.valueForKey("Contacts") as! NSArray).count > 0
        {
            var sos_enabeled : Bool!
            sos_enabeled = false
            for (var i : Int = 0; i < (Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSArray).count ; i++ )
            {
                if ((Structures.Constant.appDelegate.dictSignUpCircle.valueForKey("Contacts") as! NSArray).objectAtIndex(i).valueForKey("sos_enabled") as! NSString) == "2"
                {
                    sos_enabeled = true
                }
            }
            if sos_enabeled == true
            {
                let vc : Step4_CreateAccountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step4_CreateAccountVC") as! Step4_CreateAccountVC
                vc.circle =  self.circle!
                showViewController(vc, sender: self.view)
            }
            else
            {
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("you_must_select"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            }
        }
        else
        {
            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("no_contact_added"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        }
    }
    
    //MARK:- UITableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.createAccntArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if  self.createAccntArr[indexPath.row]["CellIdentifier"] as? NSString == Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier
        {
            let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier) as! HelpTextViewCell!
            cell.txtHelpTextView.frame = CGRectMake(cell.txtHelpTextView.frame.origin.x, cell.txtHelpTextView.frame.origin.y, tableView.frame.size.width - 60, cell.txtHelpTextView.frame.size.height)
            cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("must_enable_app_unlock1"),comment:"") , string: NSLocalizedString(Utility.getKey("must_enable_app_unlock1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("must_enable_app_unlock2"),comment:""), fontName: cell.txtHelpTextView.font)
            cell.txtHelpTextView.sizeToFit()
            return cell.txtHelpTextView.frame.size.height + 60
        }
        let kRowHeight = self.createAccntArr[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let kCellIdentifier = self.createAccntArr[indexPath.row]["CellIdentifier"] as! String
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "TitleTableViewCellIdentifier"
        {
            if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARTitleTableViewCellIdentifier") as? ARTitleTableViewCell
            {
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.lblTitle.textColor = UIColor(red: 18/255.0, green: 115/255.0, blue: 211/255.0, alpha: 1);
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
                cell.lblTitle.textColor = UIColor(red: 18/255.0, green: 115/255.0, blue: 211/255.0, alpha: 1);
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
            cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("must_enable_app_unlock1"),comment:"") , string: NSLocalizedString(Utility.getKey("must_enable_app_unlock1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("must_enable_app_unlock2"),comment:""), fontName: cell.txtHelpTextView.font)
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if indexPath.row == 2
        {
            let vc : Step3_EnableFriendUnlockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Step3_EnableFriendUnlockVC") as! Step3_EnableFriendUnlockVC
            showViewController(vc, sender: self.view)
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
    }
}