//
//  ContactListViewController.swift
//  IWMF
//
//  This class is used for display list of contact type like Private circle, Public circle, Social circle, My Contacts.
//
//

import Foundation
import UIKit

class ContactListViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate
{
    @IBOutlet var tbl : UITableView!
    
    @IBOutlet weak var contactlistLable: UILabel!
    @IBOutlet var btnInfo : UIButton!
    @IBOutlet var btnHome : UIButton!
    
    var arrPrivate :NSMutableArray!
    var arrPublic :NSMutableArray!
    var arrSocial :NSMutableArray!
    var selectedCircleType : Int!
    var showContactCircle : Bool!
    var sectionToshow : Int!
    var isIbuttonOpen : Bool!
    var dicCircle = [String: Any]()
    var circlePrivate : Circle!
    var circlePublic : Circle!
    var circleSocial : Circle!
    var textViewHeight : CGFloat!
    //MARK:- Constraint Property
    @IBOutlet weak var verticleSpaceView: NSLayoutConstraint!
    @IBOutlet weak var textViewHeigth: NSLayoutConstraint!
    var devide : CGFloat!
    //MARK:- View Property
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contactsView: UIView!
    
    override func viewDidLoad() {
        
        Structures.Constant.appDelegate.prefrence.isFacebookSelected = false
        Structures.Constant.appDelegate.prefrence.isTwitterSelected = false
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        
        devide = 1
        super.viewDidLoad()
        
        tbl.backgroundColor = Structures.Constant.appDelegate.tableBackground
        textView.selectable = false
        
        if  Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.Home
        {
            btnHome.hidden = false
            btnInfo .setTitle("", forState: UIControlState.Normal);
            btnInfo.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal);
            circlePrivate = Circle(name:"Private", type:.Private,contactList:[]);
            circlePublic = Circle(name:"Public", type:.Public,contactList:[]);
            circleSocial = Circle(name:"Social", type:.Social,contactList:[]);
            
        }
        
        self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
        self.contactsView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)

        contactlistLable.text=NSLocalizedString(Utility.getKey("contacts"),comment:"")
        self.contactlistLable.font = Utility.setNavigationFont()
        
        arrPrivate = []
        arrPublic = []
        arrSocial = []
        
        dicCircle["private"] = circlePrivate;
        dicCircle["public"] = circlePrivate;
        dicCircle["social"] = circleSocial;
        
        sectionToshow = 0
        showContactCircle = false
        
        self.setUpUpperInfoView()
    }
    
    
    @IBAction func btnHomePressed(sender: AnyObject) {
        if Structures.Constant.appDelegate.isArabic == true
        {
            setIBtnView()
        }
        else
        {
            backToPreviousScreen()
        }
        
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func btnInfoPressed(sender: AnyObject) {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            backToPreviousScreen()
        }
        else
        {
            setIBtnView()
        }
        
    }
    @IBAction func arrowButton(sender: AnyObject) {
        
        setIBtnView()
    }
    
    func setIBtnView(){
        if isIbuttonOpen == false
        {
            self.view.bringSubviewToFront(self.contactsView)
            isIbuttonOpen = true
            textView.scrollRangeToVisible(NSRange(location:0, length:0))
            self.contactsView.hidden = false
            UIView.animateWithDuration(0.80, delay: 0.1, options: .CurveEaseOut , animations: {
                self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                self.contactsView.frame.origin.y += (UIScreen.mainScreen().bounds.size.height)
                }, completion: nil)
            
        }
        else
        {
            isIbuttonOpen = false
            UIView.animateWithDuration(0.80, delay: 0.1, options:  .CurveEaseInOut , animations: {
                self.verticleSpaceView.constant = (UIScreen.mainScreen().bounds.size.height) % self.devide
                self.contactsView.frame.origin.y -=  (UIScreen.mainScreen().bounds.size.height)
                
                }, completion: {
                    finished in
                    self.setUpUpperInfoView()
                    self.contactsView.hidden = true
                    self.view.bringSubviewToFront(self.tbl)
                    
            })
        }
        
    }
    
    func setUpUpperInfoView(){
        self.textView.text =  NSLocalizedString(Utility.getKey("Contacts - i button"),comment:"")
    }
    override func viewDidLayoutSubviews()
    {
        var fr : CGRect = tbl.frame
        fr.origin.y = 64
        tbl.frame = fr
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        Structures.Constant.appDelegate.isContactUpdated = false
        self.contactsView.hidden = true
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnHome.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Right
        }
        else
        {
            btnHome.setImage(UIImage(named: "home.png"), forState: UIControlState.Normal)
            btnInfo.setImage(UIImage(named: "info.png"), forState: UIControlState.Normal)
            textView.textAlignment =  NSTextAlignment.Left
        }
        
        isIbuttonOpen = false
        
        let arr : NSArray =  circlePrivate.contactsList as NSArray
        arrPrivate = arr.mutableCopy() as! NSMutableArray;
        
        let arr1 : NSArray =  circlePublic.contactsList as NSArray
        arrPublic = arr1.mutableCopy() as! NSMutableArray;
        
        let arr2 : NSArray =  circleSocial.contactsList as NSArray
        arrSocial = arr2.mutableCopy() as! NSMutableArray;
        
        tbl.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 6
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cellIdentifier : String = "cell"
        if Structures.Constant.appDelegate.isArabic == true
        {
            
            var cell: ARTitleTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ARTitleTableViewCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("ARTitleTableViewCell", owner: self, options: nil)
                cell = arr[0] as? ARTitleTableViewCell
                
            }
            cell?.lblDetail.hidden = true
            cell?.btnArrow.hidden = false
            cell?.levelString = "Top"
            if  indexPath.row == 0
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("All_Circle"),comment:"")
                cell?.lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (cell?.lblTitle?.font.pointSize)!)
                cell?.backgroundColor = Structures.Constant.appDelegate.tableBackground
                cell?.type = 1
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
            else if  indexPath.row == 1
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("private_circle"),comment:"")
                cell?.type = 2
            }
            else if  indexPath.row == 2
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("Public Circle"),comment:"")
                cell?.type = 2
            }
            else if  indexPath.row == 3
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("Social media"),comment:"")
                cell?.type = 2
            }
            else if  indexPath.row == 4
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("All_Contacts"),comment:"")
                cell?.backgroundColor = Structures.Constant.appDelegate.tableBackground
                cell?.lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (cell?.lblTitle?.font.pointSize)!)
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                cell?.type = 1
            }
            else if  indexPath.row == 5
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("myContacts"),comment:"")
                cell?.type = 2
                cell?.levelString = "Single"
            }
            cell?.intialize()
            return cell!
        }
        else
        {
            var cell: TitleTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TitleTableViewCell
            if (cell == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("TitleTableViewCell", owner: self, options: nil)
                cell = arr[0] as? TitleTableViewCell
                
            }
            cell?.lblDetail.hidden = true
            cell?.btnArrow.hidden = false
            cell?.levelString = "Top"
            if  indexPath.row == 0
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("All_Circle"),comment:"")
                cell?.lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (cell?.lblTitle?.font.pointSize)!)
                cell?.backgroundColor = Structures.Constant.appDelegate.tableBackground
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
            }
            else if  indexPath.row == 1
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("private_circle"),comment:"")
                cell?.type = 2
            }
            else if  indexPath.row == 2
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("Public Circle"),comment:"")
                cell?.type = 2
            }
            else if  indexPath.row == 3
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("Social media"),comment:"")
                cell?.type = 2
            }
            else if  indexPath.row == 4
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("All_Contacts"),comment:"")
                cell?.backgroundColor = Structures.Constant.appDelegate.tableBackground
                cell?.lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (cell?.lblTitle?.font.pointSize)!)
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                cell?.type = 1
            }
            else if  indexPath.row == 5
            {
                cell?.lblTitle.text = NSLocalizedString(Utility.getKey("myContacts"),comment:"")
                cell?.type = 2
                cell?.levelString = "Single"
            }
            cell?.intialize()
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 46
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 1 || indexPath.row == 2
        {
            selectedCircleType = indexPath.row - 1
            if   (Structures.Constant.appDelegate.contactScreensFrom == ContactsFrom.Home)
            {
                self.performSegueWithIdentifier("CreateOrSaveCirclePush1", sender: nil);
            }
            
        }
        else if indexPath.row == 3
        {
            self.performSegueWithIdentifier("SocialPush", sender: nil);
        }
        else if indexPath.row == 5
        {
            self.performSegueWithIdentifier("allContactListPush", sender: nil);
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "CreateOrSaveCirclePush1"
        {
            let vc : CreateOrSaveCircleVC = segue.destinationViewController as! CreateOrSaveCircleVC;
            vc.changeTitle = 2
            if  selectedCircleType == 0
            {
                
                vc.circle = circlePrivate;
                
            }
            else if  selectedCircleType == 1
            {
                
                vc.circle = circlePublic;
                
            }
        }
        else if  segue.identifier == "allContactListPush"
        {
            
            let vc : AllContactsListVC = segue.destinationViewController as! AllContactsListVC;
            vc.objContactViewType =  contactViewType.All
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
            if  textField.tag == 0{
                arrPrivate.removeAllObjects()
            }
            else if  textField.tag == 1{
                arrPublic.removeAllObjects()
            }
            else  if  textField.tag == 2{
                arrSocial.removeAllObjects()
            }
            
            var strSearch : String!;
            if  textField.text!.characters.count == range.location
            {
                strSearch = textField.text! + string
                
            }
            else{
                let str : String = textField.text!
                let index: String.Index = str.startIndex.advancedBy(range.location)
                strSearch = str.substringToIndex(index)
            }
            
            if  textField.tag == 0{
                let arr : NSArray =  circlePrivate.contactsList as NSArray
                arrPrivate = arr.mutableCopy() as! NSMutableArray;
            }
            else if  textField.tag == 1{
                let arr1 : NSArray =  circlePublic.contactsList as NSArray
                arrPublic = arr1.mutableCopy() as! NSMutableArray;
            }
            else  if  textField.tag == 2{
                let arr2 : NSArray =  circleSocial.contactsList as NSArray
                arrSocial = arr2.mutableCopy() as! NSMutableArray;
            }
            
            if (strSearch.characters.count==0) {
            }
            else
            {
                let resultPredicate = NSPredicate(format: "contactListName contains[c] %@", strSearch)
                var searchResults : NSArray!;
                if  textField.tag == 0{
                    searchResults = arrPrivate.filteredArrayUsingPredicate(resultPredicate) as NSArray;
                    arrPrivate = searchResults.mutableCopy() as! NSMutableArray
                }
                else if  textField.tag == 1{
                    searchResults =  arrPublic.filteredArrayUsingPredicate(resultPredicate) as NSArray;
                    arrPublic = searchResults.mutableCopy() as! NSMutableArray
                }
                else  if  textField.tag == 2{
                    searchResults = arrSocial.filteredArrayUsingPredicate(resultPredicate) as NSArray;
                    arrSocial = searchResults.mutableCopy() as! NSMutableArray
                    
                }
                
            }
            tbl.reloadData()
        }
        
        return true
    }
    
}