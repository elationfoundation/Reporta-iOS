//
//  CircleListVC.swift
//  IWMF
//
//  This class is used for display and select multiple circle list in "Contact is part of:".
//
//

import UIKit

protocol circleListAddToContactProtocol
{
    func circleListAddToContact(arr : NSMutableArray?)
}

class CircleListVC: UIViewController, WSClientDelegate, UIAlertViewDelegate, UITableViewDataSource,UITableViewDelegate {
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
    var contact_Id : NSString!
    var isSearchActive : Bool!
    var delegate : circleListAddToContactProtocol? = nil
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
        btnSave.titleLabel?.font = Utility.setFont()
        btnCancel.titleLabel?.font = Utility.setFont()
        
        txtSearch.placeholder=NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        lblTitle.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
        
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
        
        
        allcirclewithstatusWithData()
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
        delegate?.circleListAddToContact(arrSelected)
        backToPreviousScreen()
    }
    @IBAction func btnSaveOrCancelPressed(sender: AnyObject) {
        delegate?.circleListAddToContact(arrSelected)
        backToPreviousScreen()
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
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?{
        if !isSearchActive{
            return names as? [String]
        }
        else{
            return names as? [String]
        }
    }
    func tableView(tableView: UITableView,sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return self.arrSection.indexOfObject(title)
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.backgroundColor = tblList.backgroundColor
        cell.contentView.backgroundColor = tblList.backgroundColor
        cell.contentView.backgroundColor = UIColor.clearColor()
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?{
        return String(NSLocalizedString(Utility.getKey("menu_delete"),comment:""))
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
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
                    
                    cell?.lblCircleText.text = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ListName) as? String
                    if (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.CircleType) as! String == "1"
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
                cell?.btnCircleMark.tag = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
                for (var i : Int = 0; i < arrSelected.count ; i++)
                {
                    if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
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
                    cell?.lblCircleText.text = arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ListName) as? String
                    if arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.CircleType) as! NSString == "1"
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")//"Private"
                    }
                    else
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")//"Public"
                    }
                    cell?.lblSep.hidden = false
                    
                    cell?.btnCircleMark.selected = false
                    cell?.btnCircleMark.tag = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
                    for (var i : Int = 0; i < arrSelected.count ; i++)
                    {
                        if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
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
                    cell?.lblCircleText.text = (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ListName) as? String
                    if (dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.User.CircleType) as! String == "1"
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
                cell?.btnCircleMark.tag = ((dictContactList.valueForKey(strKey) as! NSArray).objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
                for (var i : Int = 0; i < arrSelected.count ; i++)
                {
                    if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
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
                    cell?.lblCircleText.text = arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ListName) as? String
                    if arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.User.CircleType) as! NSString == "1"
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Private"),comment:"")//"Private"
                    }
                    else
                    {
                        cell?.lblCircleType.text = NSLocalizedString(Utility.getKey("Public"),comment:"")//"Public"
                    }
                    cell?.lblSep.hidden = false
                    
                    cell?.btnCircleMark.selected = false
                    cell?.btnCircleMark.tag = (arrSearchResult.objectAtIndex(indexPath.row).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
                    for (var i : Int = 0; i < arrSelected.count ; i++)
                    {
                        if cell?.btnCircleMark.tag == (arrSelected.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
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
        arrSelected.removeAllObjects()
        
        for (var i : Int = 0; i < arrSection.count ; i++)
        {
            let arrtemp1 : NSArray! = dictContactList.objectForKey(arrSection.objectAtIndex(i)) as! NSArray
            for (var j=0; j < arrtemp1.count ; j++)
            {
                if  (arrtemp1.objectAtIndex(j).valueForKey("is_associated") as! NSString) == "1"
                {
                    arrSelected.addObject(arrtemp1.objectAtIndex(j))
                }
            }
        }
        
        if  string != "\n"
        {
            arrSearchResult.removeAllObjects()
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
                self.isSearchActive = false
            }
            else
            {
                self.isSearchActive = true
                arrSelected.removeAllObjects()
                for (var i : Int = 0; i < arrSection.count ; i++)
                {
                    let arrtemp1 : NSArray! = dictContactList.objectForKey(arrSection.objectAtIndex(i)) as! NSArray
                    for (var j=0; j < arrtemp1.count ; j++)
                    {
                        let strRangeText : NSString = (arrtemp1.objectAtIndex(j).valueForKey(Structures.Constant.ListName) as! NSString).lowercaseString
                        let range : NSRange = strRangeText.rangeOfString(strSearch.lowercaseString) as NSRange
                        if range.location != NSNotFound
                        {
                            arrSearchResult.addObject(arrtemp1.objectAtIndex(j))
                        }
                        if  (arrtemp1.objectAtIndex(j).valueForKey("is_associated") as! NSString) == "1"
                        {
                            arrSelected.addObject(arrtemp1.objectAtIndex(j))
                        }
                    }
                }
            }
            tblList.reloadData()
        }
        return true
    }
    //MARK:- Webservice Delegate
    func getContactList()
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
    func allcirclewithstatusWithData()
    {
        SVProgressHUD.show()
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic ["contact_id"] = contact_Id
        
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.allcirclewithstatusWithData(dic);
        
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
                            dictContactList  = CommonUnit.getSectionForCircleList(dic.valueForKey("data") as! NSArray as [AnyObject])
                            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "", ascending: true)
                            arrSection = (dictContactList.allKeys as NSArray).sortedArrayUsingDescriptors([descriptor])
                            
                            //Fetch Circle list
                            for (var i : Int = 0; i < arrSection.count ; i++)
                            {
                                var arrtemp1 : NSArray! = dictContactList.objectForKey(arrSection.objectAtIndex(i)) as! NSArray
                                for (var j=0; j < arrtemp1.count ; j++)
                                {
                                    if  (arrtemp1.objectAtIndex(j).valueForKey("is_associated") as! NSString) == "1"
                                    {
                                        arrSelected.addObject(arrtemp1.objectAtIndex(j))
                                    }
                                }
                                arrtemp1 = nil
                            }
                            
                            
                            //Remove Duplication
                            let arrTemp1 : NSMutableArray = arrSelected!
                            arrSelected = [] as NSMutableArray!
                            for (var i : Int = 0; i < arrTemp1.count ; i++)
                            {
                                
                                if arrSelected.count > 0
                                {
                                    var isAdded : Bool!
                                    for (var j : Int = 0; j < arrSelected.count ; j++)
                                    {
                                        
                                        let str1 = arrTemp1.objectAtIndex(i).valueForKey(Structures.Constant.ContactListID) as! NSString
                                        let str2 = arrSelected.objectAtIndex(j).valueForKey(Structures.Constant.ContactListID) as! NSString
                                        
                                        if str1.integerValue == str2.integerValue
                                        {
                                            isAdded = true
                                            arrSelected.replaceObjectAtIndex(j, withObject: (arrTemp1.objectAtIndex(i)))
                                            break
                                        }
                                        else
                                        {
                                            isAdded = false
                                            
                                        }
                                    }
                                    if isAdded == false
                                    {
                                        arrSelected.addObject(arrTemp1.objectAtIndex(i))
                                    }
                                }
                                else
                                {
                                    arrSelected.addObject(arrTemp1.objectAtIndex(i))
                                }
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
                    else
                    {
                        SVProgressHUD.dismiss()
                    }
                }
                SVProgressHUD.dismiss()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func WSResponseEoor(error:NSError, ReqType type:WSRequestType)
    {
        SVProgressHUD.dismiss()
        Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("try_later"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
    }
}