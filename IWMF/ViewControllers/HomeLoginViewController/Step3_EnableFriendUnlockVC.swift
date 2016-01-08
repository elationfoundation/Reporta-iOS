//
//  Step3_EnableFriendUnlockVC.swift
//  IWMF
//
//  This class is used for display Step-3 of Enable Friend Unlock in Create Account.
//
//

import UIKit

class Step3_EnableFriendUnlockVC: UIViewController {
    @IBOutlet var tbl : UITableView!
    @IBOutlet weak var ARbtnNavBack: UIButton!
    @IBOutlet weak var btnNavBack: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var lblCircleName: UILabel!
    @IBOutlet var btnDone: UIButton!
        var userDetail = User()
    @IBOutlet weak var txtSearchBG: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    var dictContactList : NSMutableDictionary!
    var arrSection : NSArray!
    var textColor , lineColor : UIColor!
    var arrSearchResult : NSMutableArray!
    var isSearchActive : Bool! = false
    var names : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()
        
        btnNavBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        ARbtnNavBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        titleLable.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
        textColor = UIColor(red:87/255, green:87/255, blue:87/255, alpha:1.0)
        lineColor = Utility.UIColorFromHex(0xD7D7D7, alpha: 1)
        
        self.titleLable.font = Utility.setNavigationFont()
        btnDone.titleLabel?.font = Utility.setFont()
        
        tbl.sectionIndexColor = UIColor.blackColor()
        tbl.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        tbl.sectionIndexBackgroundColor = UIColor.clearColor()
        tbl.backgroundColor = Structures.Constant.appDelegate.tableBackground
        txtSearch.placeholder = NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        lblCircleName.text = NSLocalizedString(Utility.getKey("private_circle_name"),comment:"")
        tbl.sectionIndexMinimumDisplayRowCount = NSInteger.min
        arrSearchResult = NSMutableArray()
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnNavBack.hidden = true
            ARbtnNavBack.hidden = false
            lblCircleName.textAlignment =  NSTextAlignment.Right
            txtSearch.textAlignment =  NSTextAlignment.Right
            txtSearchBG.image = UIImage(named: "ARsearch-bg.png")
            btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        }
        else
        {
            btnNavBack.hidden = false
            ARbtnNavBack.hidden = true
            txtSearch.textAlignment =  NSTextAlignment.Left
            lblCircleName.textAlignment =  NSTextAlignment.Left
            txtSearchBG.image = UIImage(named: "search-bg.png")
            btnDone.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        }
    }
    override func viewWillAppear(animated: Bool) {
        sortContacts(false)
    }
    override func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func btnInvitePressed(sender: AnyObject)
    {
        let btn: UIButton = sender as! UIButton
        let strKey : String = arrSection.objectAtIndex(Int((btn.accessibilityLabel)!)!) as! String
        let dicDetail : NSDictionary = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(btn.tag)) as! NSDictionary
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic ["contact_id"] = ""
        dic [Structures.User.User_FirstName] = dicDetail[Structures.User.User_FirstName] as! String
        dic [Structures.User.User_LastName] = dicDetail[Structures.User.User_LastName] as! String
        dic ["mobile"] = dicDetail["mobile"] as! String
        dic ["emails"] = dicDetail["emails"] as! String
        dic ["sos_enabled"] = "2"
        
        if arrSearchResult.count > 0
        {
            arrSearchResult.replaceObjectAtIndex((arrSearchResult.indexOfObject(dicDetail)), withObject: dic)
        }
        let myArr : NSMutableArray = (Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).mutableCopy() as! NSMutableArray
        myArr.replaceObjectAtIndex(((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).indexOfObject(dicDetail)), withObject: dic)
        
        Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] = myArr
        SVProgressHUD.show()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            self.sortContacts(self.isSearchActive)
        })
    }
    
    
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        backToPreviousScreen()
    }
    func backToPreviousScreen()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func sortContacts(isSearchActive : Bool)
    {
        SVProgressHUD.dismiss()
        
        if isSearchActive == true
        {
            self.dictContactList  = CommonUnit.getSectionFromDictionary(arrSearchResult as [AnyObject], isAllConact: true)
        }
        else
        {
            self.dictContactList  = CommonUnit.getSectionFromDictionary(Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray  as [AnyObject], isAllConact: true)
        }
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        self.arrSection = (self.dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
        self.tbl.reloadData()
    }
    //MARK:- UITableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return arrSection.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let strKey : String = arrSection.objectAtIndex(section) as! String
        return (dictContactList.valueForKey(strKey) as! NSArray ).count
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = tbl.backgroundColor
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
        return view
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 46
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if arrSection.count > 0
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: EnableFriendUnlockCell? = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.EnableFriendUnlockCellIdentifier) as? EnableFriendUnlockCell
        if (cell == nil)
        {
            let arr : NSArray = NSBundle.mainBundle().loadNibNamed(Structures.TableViewCellIdentifiers.EnableFriendUnlockCellIdentifier, owner: self, options: nil)
            if Structures.Constant.appDelegate.isArabic == true{
                cell = arr[1] as? EnableFriendUnlockCell
            }
            else{
                cell = arr[0] as? EnableFriendUnlockCell
            }
            cell!.btnInvite.addTarget(self, action: "btnInvitePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.btnInvite.tag = indexPath.row
        cell!.btnInvite.accessibilityLabel = String(indexPath.section)
        if arrSection.count > 0
        {
            let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
            if Structures.Constant.appDelegate.isArabic == true{
                cell?.lblContactName.text = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String)
            }
            else
            {
                cell?.lblContactName.text = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
            }
            let strStatus : NSString = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("sos_enabled") as! NSString
            if strStatus == "0"
            {
                cell!.btnInvite.setTitle(NSLocalizedString(Utility.getKey("invite"),comment:""), forState: .Normal)
                cell!.btnInvite.userInteractionEnabled = true
                cell!.btnInvite.backgroundColor = UIColor.orangeColor()
            }
            else if strStatus == "2"
            {
                cell!.btnInvite.setTitle(NSLocalizedString(Utility.getKey("invited"),comment:""), forState: .Normal)
                cell!.btnInvite.userInteractionEnabled = false
                cell!.btnInvite.backgroundColor = UIColor.grayColor()
            }
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]
    {
        return names as [AnyObject]
    }
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return self.arrSection.indexOfObject(title)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        if  string != "\n"
        {
            var strSearch : String!;
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
                isSearchActive = false
                sortContacts(isSearchActive)
            }
            else
            {
                isSearchActive = true
                arrSearchResult = NSMutableArray()
                for (var i=0; i < (Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).count ; i++)
                {
                    var strRangeText : NSString = ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i).valueForKey(Structures.User.User_LastName) as! String) + " " + ((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i).valueForKey(Structures.User.User_FirstName) as! String)
                    strRangeText = strRangeText.lowercaseString
                    let range : NSRange = strRangeText.rangeOfString(strSearch.lowercaseString) as NSRange
                    if range.location != NSNotFound
                    {
                        arrSearchResult.addObject((Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray).objectAtIndex(i))
                    }
                }
                sortContacts(isSearchActive)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tbl.reloadData()
            }
        }
        return true
    }    
    
}
