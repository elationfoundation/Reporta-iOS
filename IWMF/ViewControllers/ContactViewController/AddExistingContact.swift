//
//  AddExistingContact.swift
//  IWMF
//
//  This class is used to diplay existing contacts for add in Public or Private circle.
//
//

import UIKit

class AddExistingContact: UIViewController , WSClientDelegate, UIAlertViewDelegate, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var txtSearchBG: UIImageView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnCancel: UIButton!
    var dictContactList : NSDictionary!
    var arrSearchResult :NSMutableArray!
    var arrSection : NSArray!
    var textColor , lineColor  : UIColor!
    var circle : Circle!
    var arrSelected :NSMutableArray!
    var contactlist_id : NSString!
    var isSearchActive : Bool!
    var names : NSArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tblList.backgroundColor = Structures.Constant.appDelegate.tableBackground
        tblList.sectionIndexColor = UIColor.blackColor()
        tblList.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        tblList.sectionIndexBackgroundColor = UIColor.clearColor()
        tblList.allowsMultipleSelection = true
        isSearchActive = false
        arrSearchResult = [] as NSMutableArray
        arrSection = NSArray()
        
        tblList.sectionIndexMinimumDisplayRowCount = NSInteger.max
        lineColor = Utility.UIColorFromHex(0xD7D7D7, alpha: 1)
        textColor = UIColor(red:87/255, green:87/255, blue:87/255, alpha:1.0)
        
        lblTitle.font = Utility.setNavigationFont()
        txtSearch.font = Utility.setFont()
        btnCancel.titleLabel?.font = Utility.setFont()
        btnSave.titleLabel?.font = Utility.setFont()
        
        txtSearch.placeholder=NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        lblTitle.text = NSLocalizedString(Utility.getKey(Structures.Constant.Contacts),comment:"")
        allExistingContacts()
    }
    override func viewWillAppear(animated: Bool)
    {
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
            txtSearch.textAlignment =  NSTextAlignment.Right
            txtSearchBG.image = UIImage(named: "ARsearch-bg.png")
            btnCancel.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            btnCancel.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            btnSave.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            txtSearch.textAlignment =  NSTextAlignment.Left
            txtSearchBG.image = UIImage(named: "search-bg.png")
            btnSave.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            btnSave.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            btnCancel.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
        }
    }
    override func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        backToPreviousScreen()
    }
    @IBAction func btnSaveOrCancelPressed(sender: AnyObject) {
        
        let btn : UIButton! = sender as! UIButton
        //Tag 1 = save
        //Tag 2 = cancel
        if Structures.Constant.appDelegate.isArabic == true{
            
            if btn.tag == 1{
                backToPreviousScreen()
            }else if btn.tag == 2{
                updateContactList()
            }
        }else{
            
            if btn.tag == 1{
                updateContactList()
            }else if btn.tag == 2{
                backToPreviousScreen()
            }
        }
        
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:- table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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
                return 0
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if !isSearchActive
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
        else
        {
            return 0
        }
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
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if !isSearchActive
        {
            return names as? [String]
        }
        else
        {
            return names as? [String]
        }
    }
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return self.arrSection.indexOfObject(title)
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.backgroundColor = tblList.backgroundColor
        cell.contentView.backgroundColor = tblList.backgroundColor
        cell.contentView.backgroundColor = UIColor.clearColor()
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?{
        return String(NSLocalizedString(Utility.getKey("menu_delete"),comment:""))
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            
            let cellIdentifier : String = "cell"
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
            cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
            cell?.viewCircle.backgroundColor = tblList.backgroundColor
            if !isSearchActive
            {
                let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
                if arrSection.count > 0
                {
                    cell?.viewCircle.hidden = false
                    cell?.lblCircleType.hidden = false
                    cell?.btnCircleMark.tag = indexPath.row
                    cell?.btnCircleMark.accessibilityLabel = String(indexPath.row)
                    
                    cell?.btnCircleMark.userInteractionEnabled = false
                    
                    let name : String = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String)
                    cell?.lblCircleText.text = name
                    
                    if (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("contact_type") as! String == "1"
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")//"Private"
                    }
                    else
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")//"Public"
                    }
                    cell?.lblSep.hidden = false
                }
                cell?.btnCircleMark.selected = false
                cell?.btnCircleMark.tag = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("contact_id") as! NSString).integerValue
                for (var i : Int = 0; i < arrSelected.count ; i++)
                {
                    if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey("contact_id") as! NSString).integerValue
                    {
                        cell?.btnCircleMark.selected = true
                    }
                }
            }
            else
            {
                if arrSearchResult.count > 0
                {
                    cell?.viewCircle.hidden = false
                    cell?.lblCircleType.hidden = false
                    cell?.btnCircleMark.tag = indexPath.row
                    cell?.btnCircleMark.accessibilityLabel = String(indexPath.row)
                    cell?.btnCircleMark.userInteractionEnabled = false
                    let name : String = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String) + " " + (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String)
                    
                    cell?.lblCircleText.text = name
                    
                    if arrSearchResult.objectAtIndex(indexPath.row).valueForKey("contact_type") as! NSString == "1"
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")//"Private"
                    }
                    else
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")//"Public"
                    }
                    cell?.lblSep.hidden = false
                    
                    cell?.btnCircleMark.selected = false
                    cell?.btnCircleMark.tag = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey("contact_id") as! NSString).integerValue
                    for (var i : Int = 0; i < arrSelected.count ; i++)
                    {
                        if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey("contact_id") as! NSString).integerValue
                        {
                            cell?.btnCircleMark.selected = true
                        }
                    }
                }
                
            }
            return cell!
        }
        else
        {
            let cellIdentifier : String = "cell"
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
            cell?.txtTitle.autocorrectionType = UITextAutocorrectionType.No
            cell?.viewCircle.backgroundColor = tblList.backgroundColor
            if !isSearchActive
            {
                let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
                if arrSection.count > 0
                {
                    cell?.viewCircle.hidden = false
                    cell?.lblCircleType.hidden = false
                    cell?.btnCircleMark.tag = indexPath.row
                    cell?.btnCircleMark.accessibilityLabel = String(indexPath.row)
                    cell?.btnCircleMark.userInteractionEnabled = false
                    
                    let name : String = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String) + " " + ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
                    
                    cell?.lblCircleText.text = name
                    if (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("contact_type") as! String == "1"
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")//"Private"
                    }
                    else
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")//"Public"
                    }
                    cell?.lblSep.hidden = false
                }
                cell?.btnCircleMark.selected = false
                cell?.btnCircleMark.tag = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey("contact_id") as! NSString).integerValue
                for (var i : Int = 0; i < arrSelected.count ; i++)
                {
                    if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey("contact_id") as! NSString).integerValue
                    {
                        cell?.btnCircleMark.selected = true
                    }
                }
            }
            else
            {
                if arrSearchResult.count > 0
                {
                    cell?.viewCircle.hidden = false
                    cell?.lblCircleType.hidden = false
                    cell?.btnCircleMark.tag = indexPath.row
                    cell?.btnCircleMark.accessibilityLabel = String(indexPath.row)
                    cell?.btnCircleMark.userInteractionEnabled = false
                    
                    
                    let name : String = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.User_FirstName) as! String) + " " + (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.User_LastName) as! String)
                    
                    cell?.lblCircleText.text = name
                    
                    if arrSearchResult.objectAtIndex(indexPath.row).valueForKey("contact_type") as! NSString == "1"
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")//"Private"
                    }
                    else
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")//"Public"
                    }
                    cell?.lblSep.hidden = false
                    
                    cell?.btnCircleMark.selected = false
                    cell?.btnCircleMark.tag = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey("contact_id") as! NSString).integerValue
                    for (var i : Int = 0; i < arrSelected.count ; i++)
                    {
                        if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey("contact_id") as! NSString).integerValue
                        {
                            cell?.btnCircleMark.selected = true
                        }
                    }
                }
                
            }
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if !isSearchActive
        {
            if arrSection.count > 0
            {
                let strKey : String = arrSection.objectAtIndex(indexPath.section) as! String
                
                if arrSelected.containsObject(((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row)))
                {
                    arrSelected.removeObject(((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row)))
                }
                else
                {
                    arrSelected.addObject(((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row)))
                }
            }
        }
        else
        {
            if arrSearchResult.count > 0
            {
                if arrSelected.containsObject(arrSearchResult.objectAtIndex(indexPath.row))
                {
                    arrSelected.removeObject(arrSearchResult.objectAtIndex(indexPath.row))
                }
                else
                {
                    arrSelected.addObject(arrSearchResult.objectAtIndex(indexPath.row))
                }
            }
        }
        tblList.reloadData()
    }
    //MARK: - Textview Delegate
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
                        let strRangeText : NSString = (arrtemp1.objectAtIndex(j).valueForKey(Structures.User.User_FirstName) as! NSString).lowercaseString + " " + (arrtemp1.objectAtIndex(j).valueForKey(Structures.User.User_LastName) as! NSString).lowercaseString
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
        return true
    }
    //MARK:- Webservice Delegate
    func updateContactList()
    {
        if arrSelected.count > 0{
            
            let strContactId : NSMutableString = NSMutableString()
            for(var i : Int = 0 ; i < self.arrSelected.count ; i++)
            {
                if self.arrSelected.count == 1{
                    strContactId.appendString(arrSelected.objectAtIndex(i).valueForKey("contact_id") as! String)
                }
                else if self.arrSelected.count - 1 == i{
                    strContactId.appendString(arrSelected.objectAtIndex(i).valueForKey("contact_id") as! String)
                }
                else{
                    strContactId.appendString(arrSelected.objectAtIndex(i).valueForKey("contact_id") as! String)
                    strContactId.appendString(",")
                }
            }
            
            SVProgressHUD.show()
            
            let dic : NSMutableDictionary = NSMutableDictionary()
            dic [Structures.Constant.ContactListID] = contactlist_id
            dic ["contact_id"] = strContactId
            let wsObj : WSClient = WSClient()
            wsObj.delegate = self
            wsObj.updateContactList(dic)
            
        }else{
            
        }
    }
    func allExistingContacts()
    {
        SVProgressHUD.show()
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic [Structures.Constant.ContactListID] = contactlist_id
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.allExistingContacts(dic)
    }
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if  (response is NSString)
        {
            SVProgressHUD.dismiss()
        }
        else
        {
            if let data : NSData? = NSData(data: response as! NSData)
            {
                if let dic: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary!
                {
                    if  type == WSRequestType.GetContactList
                    {
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            dictContactList  = CommonUnit.getSectionFromDictionary(dic.valueForKey("data") as! NSArray as [AnyObject], isAllConact: true)
                            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
                            arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
                            arrSelected = [] as NSMutableArray!
                            //Fetch contacts list
                            for (var i : Int = 0; i < arrSection.count ; i++)
                            {
                                var arrtemp1 : NSArray! = dictContactList.objectForKey(arrSection.objectAtIndex(i)) as! NSArray
                                for (var j=0; j < arrtemp1.count ; j++)
                                {
                                    if  (arrtemp1.objectAtIndex(j).valueForKey("contact_exist") as! NSString) == "1"
                                    {
                                        arrSelected.addObject(arrtemp1.objectAtIndex(j))
                                    }
                                }
                                arrtemp1 = nil
                            }
                            //Table Index Show/Hide
                            if arrSection.count > 0
                            {
                                tblList.sectionIndexMinimumDisplayRowCount = NSInteger.min
                            }
                            else
                            {
                                tblList.sectionIndexMinimumDisplayRowCount = NSInteger.max
                            }
                            tblList.reloadData()
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
                    else if type == WSRequestType.UpdateContactList{
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            Structures.Constant.appDelegate.isContactUpdated = true
                            let actionSheetController: UIAlertController = UIAlertController(title: dic.objectForKey(Structures.Constant.Message) as? String, message: nil , preferredStyle: .Alert)
                            let Ok: UIAlertAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Ok"),comment:"") , style: .Default) { action -> Void in
                                self.backToPreviousScreen()
                            }
                            actionSheetController.addAction(Ok)
                            self.presentViewController(actionSheetController, animated: true, completion: nil)
                        }else{
                            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                            
                        }
                        
                        SVProgressHUD.dismiss()
                    }
                }
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
