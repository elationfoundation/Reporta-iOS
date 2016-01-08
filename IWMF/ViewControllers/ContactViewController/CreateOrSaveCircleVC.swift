//
//  CreateOrSaveCircleVC.swift
//  IWMF
//
//  This class is used for display, create, delete and update Public or Private circle.
//
//

import UIKit
import CoreLocation

enum NavigationTitle : Int{
    case CheckIn = 0
    case Alert = 1
    case Contact = 2
}

enum viewType : String{
    case Private = "PrivateContactsList"
    case Public = "PublicContactsList"
    case Social = "SocialMediaList"
}

protocol CheckInContactProtocol{
    func checkInContact(arr : NSMutableArray?, type: viewType!)
}

class CreateOrSaveCircleVC: UIViewController,WSClientDelegate, UIAlertViewDelegate , UITextFieldDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var tblList: UITableView!
        var isCircleAvailable : Bool!
    var circle : Circle!
    var arrCircle : NSArray!
    var circleNameTextField : UITextField!
    var AddAlertSaveAction: UIAlertAction?
    var isEdit: Bool!
    var strCircleId: NSString!
    var active_circle_text:UIColor!
    var defaultStatusAvailable : Bool!
    var delegate : CheckInContactProtocol?
    var defaultStatusIndex : Int!
    var arrSelected :NSMutableArray?
    var location : CLLocation!
    var myViewType: viewType!
    var changeTitle : Int = 0
    var userDetail = User()
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        
        if defaultStatusAvailable != nil
        {
            arrSelected = NSMutableArray()
            if defaultStatusAvailable == true
            {
                arrSelected?.addObject(arrCircle.objectAtIndex(defaultStatusIndex))
            }
            delegate?.checkInContact(arrSelected,type: myViewType)
        }
        else
        {
            arrSelected = NSMutableArray()
            if defaultStatusIndex != nil
            {
                arrSelected?.addObject(arrCircle.objectAtIndex(defaultStatusIndex))
            }
            delegate?.checkInContact(arrSelected,type: myViewType)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Structures.Constant.appDelegate.commonLocation.getUserCurrentLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationUpdate:", name:Structures.Constant.LocationUpdate, object: nil)
        
        active_circle_text = Utility.UIColorFromHex(0x0F89DC, alpha: 1)
        lblTitle.font = Utility.setNavigationFont()
        
        defaultStatusAvailable = false
        
        switch changeTitle
        {
        case NavigationTitle.Alert.rawValue :
            lblTitle.text = NSLocalizedString(Utility.getKey("alerts"),comment:"")
            
        case NavigationTitle.CheckIn.rawValue :
            lblTitle.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
            
        case NavigationTitle.Contact.rawValue :
            lblTitle.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
            
        default :
            lblTitle.text = NSLocalizedString(Utility.getKey("contacts"),comment:"")
        }
        
        tblList.backgroundColor = Structures.Constant.appDelegate.tableBackground
        tblList.sectionIndexColor = UIColor.blackColor()
        tblList.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        tblList.sectionIndexBackgroundColor = UIColor.clearColor()
        isCircleAvailable = false
        
    }
    override func viewWillAppear(animated: Bool)
    {
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
        {
        }
        else
        {
            getContactListWithData()
        }
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
        }
        if Structures.Constant.appDelegate.isContactUpdated == true
        {
            userLocationUpdate()
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Location Update
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Structures.Constant.LocationUpdate, object: nil)
    }
    func locationUpdate(notification: NSNotification){
        location = notification.object as! CLLocation
    }
    func userLocationUpdate()
    {
        //Update Location when user change circle
        if location != nil
        {
            Structures.Constant.appDelegate.prefrence.UserLocationUpdate[Structures.Constant.Latitude] = NSNumber(double: location.coordinate.latitude)
            Structures.Constant.appDelegate.prefrence.UserLocationUpdate[Structures.Constant.Longitude] = NSNumber(double: location.coordinate.longitude)
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        }
    }
    //MARK:- UItableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isCircleAvailable == true
        {
            return arrCircle.count + 3
        }
        else
        {
            return 4
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: TitleTableViewCell2? = tableView.dequeueReusableCellWithIdentifier("TitleTableViewCell2") as? TitleTableViewCell2
        
        if indexPath.row == 0
        {
            
            cell = nil
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("TitleTableViewCell2", owner: self, options: nil)
                cell = arr[0] as? TitleTableViewCell2
            }
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("create_private_circle"),comment:"")
                cell?.levelString = "Top"
            }
            else
            {
                if  circle.circleType == CircleType.Private
                {
                    cell?.lblTitle.text = NSLocalizedString(Utility.getKey("private_circle"),comment:"")
                }
                else if  circle.circleType == CircleType.Public
                {
                    cell?.lblTitle.text = NSLocalizedString(Utility.getKey("Public Circle"),comment:"")
                }
            }
            cell?.intialize()
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell?.lblTitle.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell?.lblTitle.textAlignment = NSTextAlignment.Left
            }
            return cell!
        }
        else if indexPath.row == 1 || indexPath.row == 2
        {
            if Structures.Constant.appDelegate.isArabic == true
            {
                var cellSearch: ARSearchCircleCell? = tableView.dequeueReusableCellWithIdentifier("ARSearchCircleCell") as? ARSearchCircleCell
                
                if (cellSearch == nil)
                {
                    let arr : NSArray = NSBundle.mainBundle().loadNibNamed("ARSearchCircleCell", owner: self, options: nil)
                    cellSearch = arr[0] as? ARSearchCircleCell
                }
                cellSearch?.btnEdit.userInteractionEnabled = false
                cellSearch?.btnEdit.hidden = false
                cellSearch?.btnEdit.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
                cellSearch!.lbSep.hidden = true
                cellSearch?.btnAddContact.hidden = true
                if  indexPath.row == 1
                {
                    
                    if isCircleAvailable == true  && arrCircle.count > 0
                    {
                        if  defaultStatusAvailable == true
                        {
                            cellSearch?.lblTitle.text = (arrCircle.objectAtIndex(defaultStatusIndex).valueForKey(Structures.Constant.ListName) as! String)
                            cellSearch?.lblTitle.textColor = UIColor(red: 18/255.0, green: 115/255.0, blue: 211/255.0, alpha: 1);
                            cellSearch?.btnEdit.setTitle(NSLocalizedString(Utility.getKey("Edit"),comment:""), forState: UIControlState.Normal)
                        }
                        else
                        {
                            cellSearch?.lblTitle.text = NSLocalizedString(Utility.getKey("create_a_circle"),comment:"")
                            cellSearch?.btnEdit.setTitle("+", forState: UIControlState.Normal)
                        }
                    }
                    else
                    {
                        cellSearch?.lblTitle.text =  NSLocalizedString(Utility.getKey("create_a_circle"),comment:"")
                        cellSearch?.btnEdit.setTitle("+", forState: UIControlState.Normal)
                    }
                }
                else
                {
                    cellSearch?.lblTitle.text = NSLocalizedString(Utility.getKey("saved_circles"),comment:"")
                    cellSearch?.btnEdit.setTitle("+", forState: UIControlState.Normal)
                }
                
                cellSearch?.selectionStyle = UITableViewCellSelectionStyle.None
                return cellSearch!
            }
            else
            {
                var cellSearch: SearchCircleCell? = tableView.dequeueReusableCellWithIdentifier("SearchCircleCell") as? SearchCircleCell
                
                if (cellSearch == nil)
                {
                    let arr : NSArray = NSBundle.mainBundle().loadNibNamed("SearchCircleCell", owner: self, options: nil)
                    cellSearch = arr[0] as? SearchCircleCell
                }
                cellSearch?.btnEdit.userInteractionEnabled = false
                cellSearch?.btnEdit.hidden = false
                cellSearch?.btnEdit.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
                cellSearch!.lbSep.hidden = true
                cellSearch?.btnAddContact.hidden = true
                if  indexPath.row == 1
                {
                    
                    if isCircleAvailable == true  && arrCircle.count > 0
                    {
                        if  defaultStatusAvailable == true
                        {
                            cellSearch?.lblTitle.text = arrCircle.objectAtIndex(defaultStatusIndex).valueForKey(Structures.Constant.ListName) as? String
                            cellSearch?.lblTitle.textColor = UIColor(red: 18/255.0, green: 115/255.0, blue: 211/255.0, alpha: 1);
                            cellSearch?.btnEdit.setTitle(NSLocalizedString(Utility.getKey("Edit"),comment:""), forState: UIControlState.Normal)
                        }
                        else
                        {
                            cellSearch?.lblTitle.text = NSLocalizedString(Utility.getKey("create_a_circle"),comment:"")
                            cellSearch?.btnEdit.setTitle("+", forState: UIControlState.Normal)
                        }
                    }
                    else
                    {
                        cellSearch?.lblTitle.text =  NSLocalizedString(Utility.getKey("create_a_circle"),comment:"")
                        cellSearch?.btnEdit.setTitle("+", forState: UIControlState.Normal)
                    }
                }
                else
                {
                    cellSearch?.lblTitle.text = NSLocalizedString(Utility.getKey("saved_circles"),comment:"")
                    cellSearch?.btnEdit.setTitle("+", forState: UIControlState.Normal)
                }
                cellSearch?.selectionStyle = UITableViewCellSelectionStyle.None
                return cellSearch!
            }
            
            
        }
        else if indexPath.row >= 3
        {
            var cell: AllContactCell? = tableView.dequeueReusableCellWithIdentifier("AllContactCell") as? AllContactCell
            cell = nil
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("AllContactCell", owner: self, options: nil)
                if Structures.Constant.appDelegate.isArabic == true{
                    cell = arr[1] as? AllContactCell
                }else{
                    cell = arr[0] as? AllContactCell
                }
            }
            if (arrCircle == nil)
            {
                cell?.viewNoSavedCircle.hidden = false
                cell?.contentView.backgroundColor = tblList.backgroundColor
                cell?.lblBottomLineFull.hidden = true
                cell?.lblBottomLineShort.hidden = true
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                if  circle.circleType == CircleType.Private
                {
                    cell?.lblTextNoCircle.text = NSLocalizedString(Utility.getKey("you_have_no_saved_private_circle"),comment:"")
                }
                else
                {
                    cell?.lblTextNoCircle.text = NSLocalizedString(Utility.getKey("you_have_no_saved_public_circle"),comment:"")
                }
                
                cell?.lblName.hidden = true
            }
            else if isCircleAvailable == true && arrCircle.count > 0
            {
                
                cell?.contentView.backgroundColor = UIColor.whiteColor()
                cell?.lblBottomLineShort.hidden = true
                cell?.lblName.hidden = false
                cell?.viewNoSavedCircle.hidden = true
                cell?.btnSwitch.on = false
                cell?.btnSwitch.tag = indexPath.row - 3
                cell?.btnSwitch.addTarget(self, action: Selector("switchIsChanged:"), forControlEvents: UIControlEvents.ValueChanged)
                if myViewType != nil
                {
                    if myViewType == viewType.Private || myViewType == viewType.Public
                    {
                        if defaultStatusIndex != nil
                        {
                            if (indexPath.row - 3) == defaultStatusIndex
                            {
                                cell?.btnSwitch.on = true
                            }
                            else
                            {
                                cell?.btnSwitch.on = false
                            }
                            
                        }
                        else
                        {
                            cell?.btnSwitch.on = false
                        }
                    }
                }
                else
                {
                    if arrCircle.objectAtIndex(indexPath.row - 3).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1"
                    {
                        cell?.btnSwitch.on = true
                    }
                    
                }
                cell?.lblBottomLineFull.hidden = true
                cell?.lblName.textColor = (Utility.UIColorFromHex(0x8E8E8E, alpha: 1))
                cell?.lblName.text = arrCircle.objectAtIndex(indexPath.row - 3).valueForKey(Structures.Constant.ListName) as? String
                cell?.btnSwitch.hidden = false
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                if indexPath.row - 3 == arrCircle .indexOfObject(arrCircle.lastObject!)
                {
                    cell?.lblBottomLineFull.hidden = false
                }
            }
            return cell!
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 46
        }
        else if indexPath.row == 1 || indexPath.row == 2
        {
            return 70
        }
        else if indexPath.row >= 3
        {
            
            if isCircleAvailable == true
            {
                return 46
            }
            else
            {
                return 100
            }
        }
        return 46
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String!{
        return String(NSLocalizedString(Utility.getKey("menu_delete"),comment:""))
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tblList.reloadData()
        if Structures.Constant.appDelegate.isArabic == true
        {
            let alert : UIAlertView! = UIAlertView(title: NSLocalizedString(Utility.getKey("delete_circle_msg"),comment:""), message: "" , delegate: self, cancelButtonTitle: nil, otherButtonTitles: NSLocalizedString(Utility.getKey("yes"),comment:"") ,  NSLocalizedString(Utility.getKey("no"),comment:""))
            alert.tag = 1
            alert.accessibilityLabel = String(indexPath.row - 3)
            alert.show()
        }
        else
        {
            let alert : UIAlertView! = UIAlertView(title: NSLocalizedString(Utility.getKey("delete_circle_msg"),comment:""), message: "" , delegate: self, cancelButtonTitle: NSLocalizedString(Utility.getKey("no"),comment:""), otherButtonTitles: NSLocalizedString(Utility.getKey("yes"),comment:""))
            alert.tag = 1
            alert.accessibilityLabel = String(indexPath.row - 3)
            alert.show()
        }
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        if isCircleAvailable == true && arrCircle.count > 0
        {
            if indexPath.row >= 3
            {
                if defaultStatusIndex != nil
                {
                    if indexPath.row - 3 == defaultStatusIndex
                    {
                        return UITableViewCellEditingStyle.None
                    }
                    else
                    {
                        return UITableViewCellEditingStyle.Delete
                    }
                    
                }
                else
                {
                    return UITableViewCellEditingStyle.Delete
                }
            }
            else
            {
                return UITableViewCellEditingStyle.None
            }
        }
        else
        {
            return UITableViewCellEditingStyle.None
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 1
        {
            if  defaultStatusAvailable == true
            {
                btnEditCircle()
            }
            else
            {
                btnAddCircle()
            }
        }
        if indexPath.row == 2
        {
            btnAddCircle()
        }
    }
    
    //MARK:- UIAlertDelegate
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int)
    {
        if  alertView.tag == 1
        {
            let strIndex : NSString = alertView.accessibilityLabel!
            if Structures.Constant.appDelegate.isArabic == true
            {
                if  buttonIndex == 0
                {
                    deleteContactCircleWithData(strIndex.integerValue)
                }
                else
                {
                    tblList.reloadData()
                }
            }
            else
            {
                if  buttonIndex == 1
                {
                    deleteContactCircleWithData(strIndex.integerValue)
                }
                else
                {
                    tblList.reloadData()
                }
            }
        }
    }
    //MARK:- Methods
    func switchIsChanged(mySwitch: UISwitch)
    {
        tblList.reloadData()
        if myViewType != nil
        {
            if myViewType == viewType.Private || myViewType == viewType.Public
            {
                if defaultStatusIndex != nil
                {
                    if defaultStatusIndex == mySwitch.tag
                    {
                        if  circle.circleType == CircleType.Private
                        {
                            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("select_create_private_to_change"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                        }
                        else
                        {
                            setDefaultContactAlert(mySwitch.tag)
                        }
                    }
                    else
                    {
                        setDefaultContactAlert(mySwitch.tag)
                    }
                }
                else
                {
                    setDefaultContactAlert(mySwitch.tag)
                }
                
                tblList.reloadData()
            }
        }
        else
        {
            setDefaultContactList(mySwitch.tag)
        }
    }
    func setDefaultContactList(index:Int)
    {
        
        if  arrCircle.objectAtIndex(index).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1"
        {
            if  circle.circleType == CircleType.Private
            {
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("select_create_private_to_change"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                
            }
            else
            {
                setDefaultContactAlert(index)
            }
            tblList.reloadData()
        }
        else
        {
            setDefaultContactAlert(index)
        }
    }
    func setDefaultContactAlert(index:Int)
    {
        isEdit = false
        var strTitile : NSString!
        if  circle.circleType == CircleType.Private
        {
            strTitile = NSLocalizedString(Utility.getKey("update_private_circle"),comment:"")
        }
        else
        {
            strTitile = NSLocalizedString(Utility.getKey("update_public_circle"),comment:"")
        }
        
        let alertController = UIAlertController(title: strTitile as String , message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel) { action in
            self.tblList.reloadData()
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("yes"),comment:""), style: .Default)  { action in
            if self.myViewType != nil
            {
                if self.myViewType == viewType.Private || self.myViewType == viewType.Public
                {
                    if self.defaultStatusIndex != nil
                    {
                        if self.defaultStatusIndex != index
                        {
                            self.defaultStatusIndex = index
                            self.defaultStatusAvailable = true
                        }
                    }
                    else
                    {
                        self.defaultStatusIndex = index
                        self.defaultStatusAvailable = true
                    }
                    self.tblList.reloadData()
                }
            }
            else
            {
                self.updateDefaultCircleWS(index)
            }
        }
        if Structures.Constant.appDelegate.isArabic == true
        {
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
        }
        else
        {
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
        }
        
        
        if  circle.circleType == CircleType.Private
        {
            presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            if self.myViewType != nil
            {
                if self.myViewType == viewType.Private || self.myViewType == viewType.Public
                {
                    if self.defaultStatusIndex != nil
                    {
                        if self.defaultStatusIndex != index
                        {
                            presentViewController(alertController, animated: true, completion: nil)
                        }
                        else if self.defaultStatusIndex == index
                        {
                            self.defaultStatusIndex = nil
                            self.defaultStatusAvailable = false
                        }
                    }
                    else
                    {
                        presentViewController(alertController, animated: true, completion: nil)
                    }
                    self.tblList.reloadData()
                    return
                }
            }
            else
            {
                if self.arrCircle.objectAtIndex(index).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "0"
                {
                    presentViewController(alertController, animated: true, completion: nil)
                }
                else
                {
                    self.updateDefaultCircleWS(index)
                }
            }
        }
    }
    func updateDefaultCircleWS(index:Int)
    {
        SVProgressHUD.show()
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic [Structures.Constant.ListID] = self.arrCircle.objectAtIndex(index).valueForKey(Structures.Constant.ContactListID)
        
        if  self.circle.circleType == CircleType.Private
        {
            dic [Structures.User.CircleType] = "1"
            dic [Structures.Constant.DefaultStatus] = "1"
        }
        else if  self.circle.circleType == CircleType.Public
        {
            dic [Structures.User.CircleType] = "2"
            if self.arrCircle.objectAtIndex(index).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1"
            {
                dic [Structures.Constant.DefaultStatus] = "0"
            }
            else
            {
                dic [Structures.Constant.DefaultStatus] = "1"
            }
        }
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.setDefaultContactList(dic);
    }
    func removeTextFieldObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: circleNameTextField )
    }
    func btnEditCircle()
    {
        if isCircleAvailable == true  && arrCircle.count > 0
        {
            if defaultStatusAvailable == true
            {
                isEdit = true
                self.performSegueWithIdentifier("EditCirclePush1", sender:nil );
            }
        }
    }
    func btnAddCircle()
    {
        isEdit = false
        var strTitile : NSString!
        if  circle.circleType == CircleType.Private
        {
            strTitile = NSLocalizedString(Utility.getKey("create_new_private_circle_title"),comment:"")
        }
        else
        {
            strTitile = NSLocalizedString(Utility.getKey("create_new_public_circle_title"),comment:"")
        }
        let alertController = UIAlertController(title: strTitile as String , message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            if Structures.Constant.appDelegate.isArabic == true
            {
                textField.textAlignment = NSTextAlignment.Right
            }
            else
            {
                textField.textAlignment = NSTextAlignment.Left
            }
            textField.placeholder = NSLocalizedString(Utility.getKey("new_circle"),comment:"")
            self.circleNameTextField = textField
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: self.circleNameTextField)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("Cancel"),comment:""), style: .Cancel) { action in
            self.removeTextFieldObserver()
        }
        
        let saveAction = UIAlertAction(title: NSLocalizedString(Utility.getKey("save"),comment:""), style: .Default)  { action in
            self.removeTextFieldObserver()
            if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
            {
                Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.ListName] = self.circleNameTextField.text
                Structures.Constant.appDelegate.dictSignUpCircle[Structures.User.CircleType] = "1"
                Structures.Constant.appDelegate.dictSignUpCircle[Structures.Constant.DefaultStatus] = "1"
                Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] = NSMutableArray()
                self.performSegueWithIdentifier("EditCirclePush1", sender:Structures.Constant.appDelegate.dictSignUpCircle );
            }
            else
            {
                self.createContactCircletWithData()
            }
            
        }
        saveAction.enabled = false
        AddAlertSaveAction = saveAction
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
        }
        else
        {
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        if (textField.text!.characters.count > 1)
        {
            AddAlertSaveAction!.enabled = true
        }
        else
        {
            AddAlertSaveAction!.enabled = false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if  segue.identifier == "EditCirclePush1"
        {
            if isEdit == true
            {
                let vc : EditCircleVC = segue.destinationViewController as! EditCircleVC
                vc.circle = self.circle!
                vc.objEditCircleType = EditCircleType.circleEdit
                vc.dictTemp = arrCircle.objectAtIndex(defaultStatusIndex) as! NSDictionary
                
                Structures.Constant.appDelegate.dictSelectToUpdate = arrCircle.objectAtIndex(defaultStatusIndex) as! NSDictionary
                
            }
            else
            {
                let vc : EditCircleVC = segue.destinationViewController as! EditCircleVC
                vc.circle = self.circle!
                vc.dictTemp = sender as! NSDictionary
                Structures.Constant.appDelegate.dictSelectToUpdate = sender as! NSDictionary
                vc.objEditCircleType = EditCircleType.circleNew
                if Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.CreateAccount
                {
                    vc.userDetail = self.userDetail
                }
            }
        }
    }
    //MARK:- Webservice Delegate
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
    func createContactCircletWithData()
    {
        SVProgressHUD.show()
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic [Structures.Constant.ListName] = circleNameTextField.text
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
    func deleteContactCircleWithData(deleteIndex: Int)
    {
        
        SVProgressHUD.show()
        
        let dic : NSMutableDictionary = NSMutableDictionary()
        dic[Structures.Constant.ContactListID] = (arrCircle.objectAtIndex(deleteIndex).valueForKey(Structures.Constant.ContactListID) as! NSString).integerValue
        let wsObj : WSClient = WSClient()
        wsObj.delegate = self
        wsObj.deleteContactCircleWithData(dic);
    }
    func circleIsEmpty(circleName : NSString)
    {
        
        let alert: UIAlertController = UIAlertController(title: NSString(format: NSLocalizedString(Utility.getKey("this_circle_has_no_contact"),comment:"") , circleName ) as String , message:  "", preferredStyle: .Alert)
        let Ok: UIAlertAction = UIAlertAction(title:NSLocalizedString(Utility.getKey("Ok"),comment:"") , style: .Default) { action -> Void in
            self.btnEditCircle()
        }
        alert.addAction(Ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func WSResponse(response:AnyObject?, ReqType type:WSRequestType)
    {
        if (response is NSString)
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
                    if  type == WSRequestType.GetContactList
                    {
                        defaultStatusAvailable = false
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            isCircleAvailable = true
                            arrCircle  = dic.valueForKey("data") as! NSArray
                            
                            if arrSelected != nil
                            {
                                if arrSelected?.count > 0
                                {
                                    for (var j = 0 ; j < arrCircle.count ; j++)
                                    {
                                        defaultStatusIndex = 0
                                        
                                        if (arrCircle.objectAtIndex(j).valueForKey(Structures.Constant.ContactListID) as! NSString).intValue == (arrSelected?.objectAtIndex(0).valueForKey(Structures.Constant.ContactListID) as! NSString).intValue
                                        {
                                            defaultStatusIndex = j
                                            defaultStatusAvailable = true
                                            break
                                        }
                                        else
                                        {
                                            defaultStatusAvailable = false
                                        }
                                    }
                                }
                                else
                                {
                                    
                                    if  circle.circleType == CircleType.Private
                                    {
                                        for (var i = 0; i < arrCircle.count; i++)
                                        {
                                            if arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1"
                                            {
                                                defaultStatusIndex = i
                                                defaultStatusAvailable = true
                                                break
                                            }
                                            else
                                            {
                                                defaultStatusAvailable = false
                                            }
                                        }
                                    }
                                    else if  circle.circleType == CircleType.Public
                                    {
                                        defaultStatusAvailable = false
                                        defaultStatusIndex = nil
                                    }
                                }
                            }
                            else
                            {
                                for (var i = 0 ; i < arrCircle.count ; i++)
                                {
                                    if arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.DefaultStatus) as! NSString == "1"
                                    {
                                        defaultStatusIndex = i
                                        defaultStatusAvailable = true
                                        break
                                    }
                                    else
                                    {
                                        defaultStatusAvailable = false
                                        defaultStatusIndex = nil
                                    }
                                }
                            }
                            
                            for (var i = 0 ; i < arrCircle.count ; i++)
                            {
                                if (arrCircle.objectAtIndex(i).valueForKey("Contacts") as! NSArray).count == 0
                                {
                                    defaultStatusIndex = i
                                    defaultStatusAvailable = true
                                    self.circleIsEmpty((arrCircle.objectAtIndex(i).valueForKey(Structures.Constant.ListName) as! NSString))
                                    break
                                }
                            }
                            dispatch_async(dispatch_get_main_queue()) {
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
                            
                            tblList.backgroundColor = Structures.Constant.appDelegate.tableBackground
                            tblList.sectionIndexColor = UIColor.blackColor()
                            tblList.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
                            tblList.sectionIndexBackgroundColor = UIColor.clearColor()
                            isCircleAvailable = false
                            defaultStatusAvailable = false
                            arrCircle = nil
                            self.tblList.reloadData()
                            SVProgressHUD.dismiss()
                        }
                    }
                    else if  type == WSRequestType.DeleteContactList
                    {
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            getContactListWithData()
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
                    else if  type == WSRequestType.SetDefaultContactList
                    {
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            getContactListWithData()
                            SVProgressHUD.dismiss()
                            userLocationUpdate()
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
                    else if type == WSRequestType.CreateContactCircle
                    {
                        
                        if  dic.objectForKey(Structures.Constant.Status)?.integerValue == 1
                        {
                            Utility.updateUserHeaderToken(dic.objectForKey(Structures.Constant.Headertoken) as! String)
                            userLocationUpdate()
                            strCircleId = String((dic.valueForKey("data")?.valueForKey("circle_id")) as! Int)
                            self.performSegueWithIdentifier("EditCirclePush1", sender:dic.objectForKey("data") );
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
