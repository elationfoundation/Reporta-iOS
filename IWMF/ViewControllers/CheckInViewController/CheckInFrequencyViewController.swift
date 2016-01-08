//
//  CheckInFrequencyViewController.swift
//  IWMF
//
// This class is used for allow user to select predefined frequency of check-in and Notifications.
//
//

import Foundation
import UIKit

protocol ChooseFrequencyProtocol{
    func chooseFrequencyAndPromts(frequency : NSNumber, promts : NSString, isCustom : Bool)
}

class CheckInFrequencyViewController: UIViewController, FooterDoneButtonProtol, CreateCustomFrequencyProtocol {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var checkInfrequencyLable: UILabel!
    var arrRawData: NSMutableArray!
    @IBOutlet weak var btnBack: UIButton!
    var frequency : NSNumber!
    var isCustom : Bool = false
    var promots : NSString!
    var delegate : ChooseFrequencyProtocol!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBAction func btnBackPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:- Done Button Footer Cell Protocol
    func doneButtonPressed(){
        
        let strMutable : NSMutableString = ""
        for(var i : Int = 0 ; i < arrRawData.count ; i++)
        {
            self.promots = ""
            
            let connectedID = self.arrRawData[i]["ConnectedID"] as! Int!
            if connectedID != nil
            {
                let identity = self.arrRawData[i]["Identity"] as! NSString!
                if connectedID == 2
                {
                    if self.arrRawData[i]["IsSelected"] as! Bool == true
                    {
                        strMutable.appendString("\(identity),")
                    }
                }
            }
        }
        self.promots = strMutable
        if self.promots.length == 0
        {
            
            Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("please_select_receive_promts"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            return
        }
        delegate?.chooseFrequencyAndPromts(self.frequency, promts: self.promots, isCustom : self.isCustom)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad()
    {
        
        checkInfrequencyLable.text = NSLocalizedString(Utility.getKey("Check In Frequency"),comment:"")
        
        self.arrRawData = NSMutableArray()
        self.checkInfrequencyLable.font =  Utility.setNavigationFont()
        
        var arrTemp : NSMutableArray!
        if let path = NSBundle.mainBundle().pathForResource("CheckInFrequency", ofType: "plist") {
            arrTemp = NSMutableArray(contentsOfFile: path)
            
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        arrTemp.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
            
        }
        let arrNumbers: NSArray = self.promots.componentsSeparatedByString(",")
        for (_, element) in arrTemp.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let connectedID = innerDict["ConnectedID"] as! Int!
                let iden = innerDict["Identity"] as! NSString!
                if iden == self.frequency.stringValue  && !isCustom
                {
                    innerDict["IsSelected"] = true
                }
                if connectedID != nil && connectedID == 2
                {
                    if arrNumbers.count > 0
                    {
                        for(var i : Int = 0; i < arrNumbers.count; i++)
                        {
                            if iden == arrNumbers[i] as! NSString
                            {
                                innerDict["IsSelected"] = true
                                break
                            }
                            else
                            {
                                innerDict["IsSelected"] = false
                            }
                        }
                    }
                }
                if iden == "Frequency" && isCustom
                {
                    innerDict["Title"] = Utility.convertFrequencyToHoursAndMinsFormatString(frequency)
                }
                self.arrRawData.addObject(innerDict)
            }
        }
        
        self.tblView.registerNib(UINib(nibName: "DoneFooterCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DoneFooterCellIdentifier)
        self.tblView.registerNib(UINib(nibName: "FrequencyTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        
        self.tblView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        
        self.tblView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        
        self.tblView.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        
        self.tblView.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
        
        
        self.tblView.rowHeight = UITableViewAutomaticDimension
        
        var cell : DoneFooterCell = tblView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.DoneFooterCellIdentifier) as! DoneFooterCell
        let arr : NSArray = NSBundle.mainBundle().loadNibNamed("DoneFooterCell", owner: self, options: nil)
        cell = arr[0] as!  DoneFooterCell
        cell.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 80)
        cell.btnDone.addTarget(self, action: "doneButtonPressed", forControlEvents: .TouchUpInside)
        cell.btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        tblView.tableFooterView = cell
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
        }
        else
        {
            btnBack.hidden = false
            ARbtnBack.hidden = true
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = self.arrRawData[indexPath.row]["CellIdentifier"] as! String
        
        if let cell: TitleTableViewCell2 = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell2 {
            cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.arrRawData[indexPath.row]["Title"] as! String!
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
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier
        {
            if let cell: ARTitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier) as? ARTitleTableViewCell {
                cell.lblDetail.text = ""
                cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.arrRawData[indexPath.row]["Title"] as! String!
                cell.type = self.arrRawData[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
            
        }
        else
        {
            if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell {
                cell.lblDetail.text = ""
                cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
                cell.lblTitle.text = self.arrRawData[indexPath.row]["Title"] as! String!
                cell.type = self.arrRawData[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier) as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = ""
                cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.arrRawData[indexPath.row]["Title"] as! String!
                cell.isSelectedValue = self.arrRawData[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.arrRawData[indexPath.row]["Type"] as! Int!
                cell.identity = self.arrRawData[indexPath.row]["Identity"] as! String!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell {
                cell.lblSubDetail.text = ""
                cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.arrRawData[indexPath.row]["Title"] as! String!
                cell.isSelectedValue = self.arrRawData[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.arrRawData[indexPath.row]["Type"] as! Int!
                cell.identity = self.arrRawData[indexPath.row]["Identity"] as! String!
                cell.intialize()
                return cell
            }
            
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let type = self.arrRawData[indexPath.row]["Type"] as! Int!
        if  type == 2{
            let createCustomController : CreateCustomCheckinViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateCustomCheckinViewController") as! CreateCustomCheckinViewController
            createCustomController.delegate = self
            if  isCustom{
                let hoursMins = Utility.convertFrequencyToHoursAndMinsFormat(frequency)
                createCustomController.hours = hoursMins.hours
                createCustomController.mins = hoursMins.mins
            }
            showViewController(createCustomController, sender: self.view)
        }else if  type == 1{
            let connectedID = self.arrRawData[indexPath.row]["ConnectedID"] as! Int!
            let identity = self.arrRawData[indexPath.row]["Identity"] as! NSString!
            
            for (index, element) in self.arrRawData.enumerate()
            {
                if var innerDict = element as? Dictionary<String, AnyObject>
                {
                    let innerType = innerDict["Type"] as! Int!
                    if innerType == 0
                    {
                        continue
                    }
                    let iden = innerDict["Identity"] as! NSString!
                    let cnID = innerDict["ConnectedID"] as! Int!
                    if iden == "Frequency" && connectedID == 1{
                        innerDict["Title"] = NSLocalizedString(Utility.getKey("Create custom"),comment:"")
                        self.isCustom = false
                        self.arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
                        continue
                    }
                    if cnID == connectedID && cnID == 1
                    {
                        if iden == identity
                        {
                            innerDict["IsSelected"] = true
                            if cnID == 1
                            {
                                self.frequency = NSNumber(integer: iden.integerValue)
                            }
                        }
                        else
                        {
                            innerDict["IsSelected"] = false
                        }
                        self.arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
            if connectedID == 2
            {
                var dictTemp : NSMutableDictionary = NSMutableDictionary()
                dictTemp = self.arrRawData.objectAtIndex(indexPath.row).mutableCopy() as! NSMutableDictionary
                if dictTemp["IsSelected"] as! Bool == false
                {
                    dictTemp["IsSelected"] = true
                }
                else
                {
                    dictTemp["IsSelected"] = false
                }
                self.arrRawData.replaceObjectAtIndex(indexPath.row, withObject: dictTemp)
            }
            self.tblView.reloadData()
        }
    }
    //MARK:- Custom Frequency Controll
    func customFrequencySelected(hours : Int, mins: Int){
        if hours > 0 || mins > 0{
            self.isCustom = true
            self.frequency = Utility.convertFrequencyToMins(hours, minz: mins)
            
            for (index, element) in self.arrRawData.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let innerType = innerDict["Type"] as! Int!
                    if innerType == 0{
                        continue
                    }
                    let iden = innerDict["Identity"] as! NSString!
                    let cnID = innerDict["ConnectedID"] as! Int!
                    if iden == "Frequency"{
                        innerDict["Title"] = Utility.convertFrequencyToHoursAndMinsFormatString(self.frequency)
                        self.arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
                        continue
                    }
                    if cnID == 1 && innerType == 1{
                        innerDict["IsSelected"] = false
                        self.arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                    
                }
            }
            self.tblView.reloadData()
        }
    }
}