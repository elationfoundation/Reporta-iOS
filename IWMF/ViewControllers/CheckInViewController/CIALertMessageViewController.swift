//
//  CIALertMessageViewController.swift
//  IWMF
//
//  This class is used for add custom message while create Check-in.
//
//

import Foundation
import UIKit

protocol CIAlertMessageProtocol{
    func alertMessageModified(email : NSString, sms : NSString, social : NSString)
}


class CIALertMessageViewController: UIViewController, FooterDoneButtonProtol, CheckInAlertMessageProtocol,ARCheckInAlertMessageProtocol {
    var arrRawData : NSMutableArray!
    var delegate : CIAlertMessageProtocol!
    @IBOutlet weak var btnBarDone: UIBarButtonItem!
    @IBOutlet weak var btnBarCancel: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    var isKeyboardEnable : Bool = false
    var activeTextView : UITextView!
    @IBOutlet weak var checkInLAble: UILabel!
    @IBOutlet var toolbar : UIToolbar!
    @IBOutlet weak var tblView: UITableView!
    var emailMSG : String = ""
    var smsMSG : String = ""
    var socialMSG : String = ""
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        backToPreviousScreen()
    }
    @IBAction func btnToolbarDoneClicked(sender:AnyObject)
    {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            self.view.endEditing(true);
            self.tblView.setContentOffset(CGPointZero, animated: true)
        }
        else
        {
            self.view.endEditing(true);
            self.tblView.setContentOffset(CGPointZero, animated: true)
        }
        
    }
    @IBAction func btnToolbarCancelClicked(sender:AnyObject)
    {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            self.view.endEditing(true);
            self.tblView.setContentOffset(CGPointZero, animated: true)
            
        }
        else
        {
            self.view.endEditing(true);
            self.tblView.setContentOffset(CGPointZero, animated: true)
        }
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:- Done Button Footer Cell Protocol
    func doneButtonPressed(){
        self.isKeyboardEnable = false
        if self.activeTextView != nil{
            self.activeTextView.resignFirstResponder()
            self.activeTextView = nil
        }
        self.tblView.setContentOffset(CGPointZero, animated: true)
        delegate?.alertMessageModified(self.emailMSG, sms: self.smsMSG, social : self.socialMSG)
        backToPreviousScreen()
    }
    //MARK: - View Contorller Life Cycle Methods
    
    override func viewDidLoad() {
        
        checkInLAble.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
        self.checkInLAble.font = Utility.setNavigationFont()
        
        self.arrRawData = NSMutableArray()
        var arrTemp : NSMutableArray!
        if let path = NSBundle.mainBundle().pathForResource("CheckInAlert", ofType: "plist") {
            arrTemp = NSMutableArray(contentsOfFile: path)
            
            
            let arrTempTwo : NSMutableArray = NSMutableArray(array: arrTemp)
            
            for (index, element) in arrTempTwo.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle as String),comment:"")
                        arrTemp.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        }
        
        for (_, element) in arrTemp.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == "Email"{
                    innerDict["Value"] = self.emailMSG
                }
                if iden == "SMS"{
                    innerDict["Value"] = self.smsMSG
                }
                if iden == "SocialMedia"{
                    innerDict["Value"] = self.socialMSG
                }
                self.arrRawData.addObject(innerDict)
            }
        }
        
        self.tblView.registerNib(UINib(nibName: "DoneFooterCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DoneFooterCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "CheckInAlertMessageCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.AlertMessageCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "ARCheckInAlertMessageCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ARCheckInAlertMessageCellIdentifier")
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: UIControlState.Normal)
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.hidden = true
            ARbtnBack.hidden = false
            
            btnBarCancel.title = NSLocalizedString(Utility.getKey("done"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
            
            btnBarCancel.title = NSLocalizedString(Utility.getKey("Cancel"),comment:"")
            btnBarDone.title = NSLocalizedString(Utility.getKey("done"),comment:"")
        }
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    //MARK: - Table View Datasource Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRawData.count
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let kRowHeight = self.arrRawData[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight;
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let kRowHeight = self.arrRawData[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = self.arrRawData[indexPath.row]["CellIdentifier"] as! NSString
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.AlertMessageCellIdentifier
        {
            
            let alertMsgCell : ARCheckInAlertMessageCell = tableView.dequeueReusableCellWithIdentifier("ARCheckInAlertMessageCellIdentifier") as! ARCheckInAlertMessageCell
            alertMsgCell.title = self.arrRawData[indexPath.row]["Title"] as! String!
            if indexPath.row == 0
            {
                alertMsgCell.value = self.emailMSG
            }else if indexPath.row == 1 {
                alertMsgCell.value = self.smsMSG
            }else{
                alertMsgCell.value = self.socialMSG
            }
            alertMsgCell.delegate = self
            alertMsgCell.indexPath = indexPath
            alertMsgCell.initializeTheLabelValues()
            return alertMsgCell
        }
        else
        {
            let kCellIdentifier = self.arrRawData[indexPath.row]["CellIdentifier"] as! String
            let alertMsgCell : CheckInAlertMessageCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! CheckInAlertMessageCell
            alertMsgCell.title = self.arrRawData[indexPath.row]["Title"] as! String!
            if indexPath.row == 0
            {
                alertMsgCell.value = self.emailMSG
            }else if indexPath.row == 1 {
                alertMsgCell.value = self.smsMSG
            }else{
                alertMsgCell.value = self.socialMSG
            }
            alertMsgCell.delegate = self
            alertMsgCell.indexPath = indexPath
            alertMsgCell.initializeTheLabelValues()
            return alertMsgCell
        }
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell : DoneFooterCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.DoneFooterCellIdentifier) as! DoneFooterCell
        footerCell.delegate = self
        return footerCell
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 74
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    //MARK:- CheckInAlertMessageProtocol
    func alertTextViewStartEditing(textView : UITextView, tableViewCell : CheckInAlertMessageCell){
        self.isKeyboardEnable = true
        self.activeTextView = textView
        self.activeTextView.inputAccessoryView = toolbar;
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let point : CGPoint = self.tblView.convertPoint(tableViewCell.frame.origin, fromView: self.tblView)
            self.tblView.setContentOffset(point, animated: true)
        })
    }
    func removeKeyBoard(){
        self.activeTextView.resignFirstResponder()
    }
    func alertTextViewEndEditing(textView : UITextView, tableViewCell : CheckInAlertMessageCell){
        if tableViewCell.indexPath.row == 0 {
            self.emailMSG = Utility.condenseWhitespace(textView.text)
        }else if tableViewCell.indexPath.row == 1 {
            self.smsMSG = Utility.condenseWhitespace(textView.text)
        }else{
            self.socialMSG = Utility.condenseWhitespace(textView.text)
        }
    }
    //MARK:- ARCheckInAlertMessageProtocol
    func alertTextViewStartEditing1(textView : UITextView, tableViewCell : ARCheckInAlertMessageCell){
        self.isKeyboardEnable = true
        self.activeTextView = textView
        self.activeTextView.inputAccessoryView = toolbar;
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let point : CGPoint = self.tblView.convertPoint(tableViewCell.frame.origin, fromView: self.tblView)
            self.tblView.setContentOffset(point, animated: true)
        })
    }
    func alertTextViewEndEditing1(textView : UITextView, tableViewCell : ARCheckInAlertMessageCell){
        if tableViewCell.indexPath.row == 0 {
            self.emailMSG = Utility.condenseWhitespace(textView.text)
        }else if tableViewCell.indexPath.row == 1 {
            self.smsMSG = Utility.condenseWhitespace(textView.text)
        }else{
            self.socialMSG = Utility.condenseWhitespace(textView.text)
        }
    }    
}