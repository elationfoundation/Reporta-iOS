//
//  SituationViewController.swift
//  IWMF
//
//  This class is used for display and select situations for Alert.
//
//

import UIKit

protocol AlertSituationProtocol{
    func alertSituation(situation : NSString)
}


class SituationViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, SituationCellDoneProtocol,ARSituationCellDoneProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    var arrRawData: NSMutableArray!
    var delegat : AlertSituationProtocol!
    var situationTitle : NSString!
    var arrSelected : NSMutableArray!
        @IBOutlet weak var alertLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        alertLable.text=NSLocalizedString(Utility.getKey("alerts"),comment:"")
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        
        self.alertLable.font = Utility.setNavigationFont()
        
        self.arrRawData = NSMutableArray()
        if let path = NSBundle.mainBundle().pathForResource("IAmFacing", ofType: "plist") {
            arrRawData = NSMutableArray(contentsOfFile: path)
            
            let arrTemp : NSMutableArray = NSMutableArray(array: arrRawData)
            
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        }
        updateRawData()
        
        self.tableView.registerNib(UINib(nibName: "FrequencyTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "FrequencyDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "SituationTitleCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.SituationTitleCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARSituationTitleCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARSituationTitleCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "NewDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "NewDetailTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    func updateRawData(){
        if self.situationTitle.length > 0{
            arrSelected = NSMutableArray(array: self.situationTitle.componentsSeparatedByString(",, "))
            for (index, element) in self.arrRawData.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let mainTitle = innerDict["Title"] as! NSString!
                    
                    var isFound : Bool = false
                    for selTitle in self.arrSelected{
                        let tempTitle : NSString = selTitle as! NSString
                        if mainTitle == tempTitle{
                            isFound = true
                        }
                    }
                    if isFound
                    {
                        innerDict["IsSelected"] = true
                        
                        
                    }else{
                        innerDict["IsSelected"] = false
                    }
                    self.arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
                }
            }
        }else{
            arrSelected = NSMutableArray()
        }
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool)
    {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnBackPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func doneBtnPressed(sender: AnyObject) {
        delegat?.alertSituation(self.situationTitle)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func doneButtonPressed()
    {
        if situationTitle.length != 0
        {
            delegat?.alertSituation(self.situationTitle)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    //MARK : - TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRawData.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kRowHeight = self.arrRawData[indexPath.row]["RowHeight"] as! CGFloat
        
        if Structures.Constant.appDelegate.isArabic == false
        {
            let strInfo : String! = self.arrRawData[indexPath.row]["Title"] as! String
            let rect = strInfo.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width-50, 999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName :  Utility.setFont()], context: nil)
            let H :CGFloat = rect.height + 25
            if kRowHeight > H{
                return kRowHeight
            }
            return H
        }
        return kRowHeight;
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            let cell: ARSituationTitleCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARSituationTitleCellIdentifier) as! ARSituationTitleCell
            cell.lblTitle.text = NSLocalizedString(Utility.getKey("I am facing"),comment:"")
            cell.btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            cell.delegate = self
            cell.intialize()
            return cell
        }
        else
        {
            let cell: SituationTitleCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.SituationTitleCellIdentifier) as! SituationTitleCell
            cell.lblTitle.text = NSLocalizedString(Utility.getKey("I am facing"),comment:"")
            cell.btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            cell.delegate = self
            cell.intialize()
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = self.arrRawData[indexPath.row]["CellIdentifier"] as! String
        
        if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell
        {
            cell.lblDetail.text = ""
            cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.arrRawData[indexPath.row]["Title"] as! String!
            cell.type = self.arrRawData[indexPath.row]["Type"] as! Int!
            cell.intialize()
            return cell
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
                cell.intialize()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.lblDetail.translatesAutoresizingMaskIntoConstraints = true
                    
                    cell.lblDetail.numberOfLines = 0
                    cell.lblDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
                })
                cell.lblWidth.constant = UIScreen.mainScreen().bounds.size.width - 34
                cell.widthChooseOption.constant = 0
                
                return cell
            }
        }
        else
        {
            if kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
            {
                if let cell: NewDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewDetailTableViewCell") as? NewDetailTableViewCell
                {
                    cell.levelString = self.arrRawData[indexPath.row]["Level"] as! NSString!
                    cell.lblDetail.text = self.arrRawData[indexPath.row]["Title"] as! String!
                    cell.isSelectedValue = self.arrRawData[indexPath.row]["IsSelected"] as! Bool!
                    cell.type = self.arrRawData[indexPath.row]["Type"] as! Int!
                    cell.intialize()
                    return cell
                }
            }
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let title : NSString = self.arrRawData[indexPath.row]["Title"] as! NSString!
        
        if self.arrSelected.containsObject(title){
            self.arrSelected.removeObject(title)
        }else{
            self.arrSelected.addObject(title)
        }
        
        let strMutable : NSMutableString = NSMutableString()
        for(var i : Int = 0 ; i < self.arrSelected.count ; i++)
        {
            if self.arrSelected.count == 1{
                strMutable.appendString((self.arrSelected.objectAtIndex(i) as! String))
            }
            else if self.arrSelected.count - 1 == i{
                strMutable.appendString((self.arrSelected.objectAtIndex(i) as! String))
            }
            else{
                strMutable.appendString((self.arrSelected.objectAtIndex(i) as! String))
                strMutable.appendString(",, ")
            }
        }
        self.situationTitle = strMutable
        for (index, element) in self.arrRawData.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let mainTitle = innerDict["Title"] as! NSString!
                var isFound : Bool = false
                for selTitle in self.arrSelected{
                    let tempTitle : NSString = selTitle as! NSString
                    if mainTitle == tempTitle{
                        isFound = true
                    }
                }
                if isFound{
                    innerDict["IsSelected"] = true
                    
                }else{
                    innerDict["IsSelected"] = false
                }
                self.arrRawData.replaceObjectAtIndex(index, withObject: innerDict)
            }
        }
        self.tableView.reloadData()
    }
}
