//
//  AllContactsListVC.swift
//  IWMF
//
//  This class is used for display all contacts of user.
//
//

import UIKit

enum contactViewType : Int{
    case All = 1
    case FromCircle = 2
    case FromAddressBook = 3
}

class AllContactsListVC: UIViewController, WSClientDelegate, UIAlertViewDelegate, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var txtSearchBG: UIImageView!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    var selectedRow: Int!
    var selectedSection: Int!
    let addressBook = AddressBookFile()
    var objContactViewType : contactViewType!
    var dictContactList : NSDictionary!
    var arrSearchResult :NSMutableArray!
    var arrContactList : NSArray!
    var dictTemp: NSDictionary!
    var arrSection : NSArray!
    var textColor , lineColor : UIColor!
    var circle : Circle!
    var names : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Structures.Constant.appDelegate.isContactUpdated = false
        
        arrContactList = NSArray()
        tblList.sectionIndexColor = UIColor.blackColor()
        tblList.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        tblList.sectionIndexBackgroundColor = UIColor.clearColor()
        tblList.backgroundColor = Structures.Constant.appDelegate.tableBackground
        tblList.sectionIndexMinimumDisplayRowCount = NSInteger.max
        textColor = UIColor(red:87/255, green:87/255, blue:87/255, alpha:1.0)
        lineColor = Utility.UIColorFromHex(0xD7D7D7, alpha: 1)
        
        tblList.showsVerticalScrollIndicator = false
        lblTitle.font = Utility.setNavigationFont()
        
        txtSearch.placeholder =   NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        
        arrSearchResult = [] as NSMutableArray
        arrSection = NSArray()
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
            txtSearch.textAlignment =  NSTextAlignment.Right
            txtSearchBG.image = UIImage(named: "ARsearch-bg.png")
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            txtSearch.textAlignment =  NSTextAlignment.Left
            txtSearchBG.image = UIImage(named: "search-bg.png")
        }
        lblTitle.text =  NSLocalizedString(Utility.getKey("contacts"),comment:"")
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        
        
        if objContactViewType == .All
        {
            getAllContactListByUserId()
        }
        else if objContactViewType == .FromCircle
        {
            getContactList()
        }
        else if objContactViewType == .FromAddressBook
        {
            arrContactList = addressBook.getContacts()
            dictContactList  = CommonUnit.getSectionFromDictionary(arrContactList as [AnyObject], isAllConact: false)
            tblList.sectionIndexMinimumDisplayRowCount = NSInteger.min
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
            arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
            self.tblList.reloadData()
        }
    }
    override func viewWillAppear(animated: Bool) {
        
        if objContactViewType == .All
        {
            if Structures.Constant.appDelegate.isContactUpdated == true
            {
                getAllContactListByUserId()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
    }
    deinit
    {
        arrSection = nil
        arrSearchResult = nil
        dictTemp = nil
        dictContactList = nil
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func getAllContactListByUserId()
    {
        SVProgressHUD.show()
        let dic : NSMutableDictionary = NSMutableDictionary()
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.getAllContacts(dic);
    }
    func getContactList()
    {
        SVProgressHUD.show()
        dictContactList  = CommonUnit.getSectionFromDictionary(arrContactList as [AnyObject], isAllConact: false)
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
        arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
        dispatch_async(dispatch_get_main_queue()){
            self.tblList.reloadData()
        }
        SVProgressHUD.dismiss()
    }
    //old code
    // table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if arrSection.count > 0
        {
            return arrSection.count
        }
        else
        {
            return 1
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if arrSection.count > 0
        {
            let strKey : String = arrSection.objectAtIndex(section) as! String
            return (dictContactList.valueForKey(strKey) as! NSArray ).count
        }
        else
        {
            return 0
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.backgroundColor = tblList.backgroundColor
        cell.contentView.backgroundColor = cell.backgroundColor
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: AllContactCell? = tableView.dequeueReusableCellWithIdentifier("AllContactCell") as? AllContactCell
        if (cell == nil)
        {
            let arr : NSArray = NSBundle.mainBundle().loadNibNamed("AllContactCell", owner: self, options: nil)
            if Structures.Constant.appDelegate.isArabic == true{
                cell = arr[1] as? AllContactCell
            }
            else{
                cell = arr[0] as? AllContactCell
            }
        }
        
        let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
        if arrSection.count > 0
        {
            cell?.btnLock.hidden = true
            if objContactViewType == .FromCircle
            {
                if dictTemp.valueForKey(Structures.User.CircleType) as! String == "1"
                {
                    let strStatus : String = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.Constant.Status) as! String
                    cell?.btnLock.contentMode = UIViewContentMode.ScaleAspectFill
                    
                    if strStatus == "0"
                    {
                        cell?.btnLock.setImage(UIImage(named: "unlock.png") as UIImage?, forState: .Normal)
                    }
                    else if strStatus == "1"
                    {
                        cell?.btnLock.setImage(UIImage(named: "lock.png") as UIImage?, forState: .Normal)
                    }
                    else if strStatus == "2"
                    {
                        cell?.btnLock.setImage(UIImage(named: "pending.png") as UIImage?, forState: .Normal)
                    }
                    cell?.btnLock.hidden = false
                }
                cell?.lblName.text = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
            }
            
            cell?.lblName.textColor =  textColor
            cell?.lblBottomLineFull.hidden = true
            cell?.lblTopLineFull.hidden = true
            cell?.lblBottomLineShort.hidden = false
            
            if objContactViewType == .All
            {
                cell?.lblName.text = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
                
                let strStatus : String = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("sos_enabled") as! String
                cell?.btnLock.contentMode = UIViewContentMode.ScaleAspectFill
                
                cell?.btnLock.hidden = false
                
                if strStatus == "0"
                {
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
            }
            else if objContactViewType == .FromAddressBook
            {
                
                let contact = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row) as!  Contact
                cell?.lblName.text = contact.firstName + " " + contact.lastName
            }
        }
        cell?.lblBottomLineShort.backgroundColor =  lineColor
        return cell!
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = tblList.backgroundColor
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
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?
    {
        return names as? [String]
    }
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return self.arrSection.indexOfObject(title)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedRow = indexPath.row
        selectedSection = indexPath.section
        
        if arrSection.count > 0
        {
            let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
            if objContactViewType == .FromAddressBook
            {
                let contact = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row) as!  Contact
                contact.selected = "1"
                self.view.endEditing(true)
                self.performSegueWithIdentifier("AddContactMauallyPush", sender: nil);
            }
            else if objContactViewType == .All
            {
                self.performSegueWithIdentifier("AddContactMauallyPush", sender: nil);
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "AddContactMauallyPush"
        {
            let vc : AddContactViewController = segue.destinationViewController as! AddContactViewController;
            let strKey : String = arrSection.objectAtIndex(selectedSection) as! String
            if objContactViewType == .FromAddressBook
            {
                vc.contact = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(selectedRow) as!  Contact
                vc.objAddContactType = AddContactType.AddressBook
            }
            else if objContactViewType == .All
            {
                vc.dictDetailEdit = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(selectedRow) as!  NSMutableDictionary
                vc.objAddContactType = AddContactType.Edit
            }
            vc.circle = self.circle
        }
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
            arrSearchResult.removeAllObjects()
            var strSearch : NSString!
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
            
            if (strSearch.length == 0)
            {
                if objContactViewType == .All || objContactViewType == .FromCircle
                {
                    dictContactList  = CommonUnit.getSectionFromDictionary(arrContactList as [AnyObject], isAllConact: true)
                }
                else if objContactViewType == .FromAddressBook
                {
                    dictContactList  = CommonUnit.getSectionFromDictionary(arrContactList as [AnyObject], isAllConact: false)
                }
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
                arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
            }
            else
            {
                for (var i : Int = 0; i < arrContactList.count ; i++)
                {
                    var strRangeText : NSString!
                    if objContactViewType == .All
                    {
                        strRangeText  = (arrContactList.objectAtIndex(i).valueForKey(Structures.User.User_LastName) as! String) + " " + (arrContactList.objectAtIndex(i).valueForKey(Structures.User.User_FirstName) as! String)
                    }
                    else if objContactViewType == .FromCircle
                    {
                        strRangeText  = (arrContactList.objectAtIndex(i).valueForKey(Structures.User.User_LastName) as! String) + " " + (arrContactList.objectAtIndex(i).valueForKey(Structures.User.User_FirstName) as! String)
                    }
                    else if objContactViewType == .FromAddressBook
                    {
                        strRangeText  = (arrContactList.objectAtIndex(i).valueForKey(Structures.User.User_LastName) as! String).lowercaseString + " " + (arrContactList.objectAtIndex(i).valueForKey(Structures.User.User_FirstName) as! String)
                    }
                    
                    strRangeText = strRangeText.lowercaseString
                    
                    let range : NSRange = strRangeText.rangeOfString(strSearch.lowercaseString) as NSRange
                    if range.location != NSNotFound
                    {
                        arrSearchResult.addObject(arrContactList.objectAtIndex(i))
                    }
                }
                
                if objContactViewType == .All || objContactViewType == .FromCircle
                {
                    dictContactList  = CommonUnit.getSectionFromDictionary(arrSearchResult as [AnyObject], isAllConact: true)
                }
                else if objContactViewType == .FromAddressBook
                {
                    dictContactList  = CommonUnit.getSectionFromDictionary(arrSearchResult as [AnyObject], isAllConact: false)
                }
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
                arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
            }
            
            self.tblList.reloadData()
            
        }
        return true
    }
    func deleteContactWithData(deleteIndex: Int, deleteSection: Int)
    {
        let dic : NSMutableDictionary = NSMutableDictionary()
        let strKey : String = arrSection.objectAtIndex(deleteSection) as! String
        dic ["contact_id"] = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(deleteIndex).valueForKey("contact_id") as! NSString).integerValue
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.deleteContactWithData(dic);
    }
    
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
        
    {
        if (response is String)
        {
            SVProgressHUD.dismiss()
        }
        else
        {
            let data : NSData? = NSData(data: response as! NSData)
            if   (data != nil)
            {
                if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if  type == WSRequestType.GetAllContacts
                    {
                        arrSection = NSArray()
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            arrContactList = dic.objectForKey("data") as! NSArray
                            dictContactList  = CommonUnit.getSectionFromDictionary(arrContactList as [AnyObject], isAllConact: true)
                            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
                            arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
                            self.tblList.reloadData()
                            tblList.sectionIndexMinimumDisplayRowCount = NSInteger.min
                            SVProgressHUD.dismiss()
                            
                        }
                        else
                        {
                            
                            SVProgressHUD.dismiss()
                            if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                                if dic.valueForKey(Structures.Constant.Message) != nil
                                {
                                    
                                    
                                    Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                                    
                                    
                                }
                            }else{
                                if dic.valueForKey(Structures.Constant.Message) != nil
                                {
                                    
                                    Utility.showAlertWithTitle((dic.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                                    
                                }
                            }
                        }
                        self.tblList.reloadData()
                        
                        
                    }
                    else if  type == WSRequestType.DeleteContactList
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            if objContactViewType == .All
                            {
                                getAllContactListByUserId()
                            }
                            else if objContactViewType == .FromCircle
                            {
                                getContactList()
                            }
                            SVProgressHUD.dismiss()
                        }
                        else{
                            SVProgressHUD.dismiss()
                            if (dic.valueForKey(Structures.Constant.Status) as! NSString) .isEqualToString("3"){
                                if dic.valueForKey(Structures.Constant.Message) != nil
                                {
                                    
                                    
                                    Utility.showLogOutAlert((dic.valueForKey(Structures.Constant.Message) as? String)!, view: self)
                                    
                                    
                                }
                            }else{
                                if dic.valueForKey(Structures.Constant.Message) != nil
                                {
                                    
                                    Utility.showAlertWithTitle((dic.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                SVProgressHUD.dismiss()
                self.tblList.reloadData()
                
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
