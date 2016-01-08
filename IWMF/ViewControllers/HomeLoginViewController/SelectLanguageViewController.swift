//
//  SelectLanguageViewController.swift
//  IWMF
//
//  This class is used for display and select Job Title.
//
//

import UIKit

protocol SelctedLanguageProtocol{
    func jobTitleSelcted(selectedText : String)
    func countryOfOrigin(selectedText : String, selectedCode : String)
    func countryWhereWorking(selectedText : String, selectedCode : String)
}

enum TypeOfCell: Int{
    case JobTitle = 1
    case CountryOfOring = 2
    case CountryWhereWorking = 3
}

class SelectLanguageViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,PersonalDetailTextProtocol,ARPersonalDetailsTableView{
    
    @IBOutlet weak var textSearchBG: UIImageView!
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var verticalSpaceTable: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selectLang : NSMutableArray!
    var delegate : SelctedLanguageProtocol?
    var selectedText : String!
    var selectedCode : String!
    var selectType : Int = 0
    var activeTextField : UITextField!
        var isSearchActive : Bool!
    var arrSearchResult :NSMutableArray!
    var isFromProfile : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if isFromProfile == 0{
            labelTitle.text=NSLocalizedString(Utility.getKey("create_account_header"),comment:"")
        }else{
            labelTitle.text=NSLocalizedString(Utility.getKey("profile"),comment:"")
        }
        labelTitle.font = Utility.setNavigationFont()
        textSearch.placeholder =   NSLocalizedString(Utility.getKey("search_contacts"),comment:"")
        self.tableView.registerNib(UINib(nibName: "FrequencyTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "FrequencyDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "PersonalDetailsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.PersonalDetailCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARPersonalDetailsTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARPersonalDetailsTableViewCellIndetifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        isSearchActive = false
        arrSearchResult = [] as NSMutableArray
        
        switch selectType{
            
        case TypeOfCell.JobTitle.rawValue :
            viewSearch.hidden = true
            verticalSpaceTable.constant = 0
            if let path = NSBundle.mainBundle().pathForResource("JobTitle", ofType: "plist")
            {
                selectLang = NSMutableArray(contentsOfFile: path)
                
                let arrTemp : NSMutableArray = NSMutableArray(array: selectLang)
                
                for (index, element) in arrTemp.enumerate() {
                    if var innerDict = element as? Dictionary<String, AnyObject> {
                        let strTitle = innerDict["Title"] as! String!
                        if strTitle.characters.count != 0
                        {
                            let strPlaceholder = innerDict["Placeholder"] as! NSString!
                            if strPlaceholder != nil
                            {
                                innerDict["Placeholder"] = NSLocalizedString(Utility.getKey("Please describe"),comment:"")
                            }
                            innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                            selectLang.replaceObjectAtIndex(index, withObject: innerDict)
                        }
                    }
                }
                
            }
        case TypeOfCell.CountryOfOring.rawValue :
            selectLang = Structures.Constant.appDelegate.arrCountryList.mutableCopy() as! NSMutableArray
        case TypeOfCell.CountryWhereWorking.rawValue :
            selectLang = Structures.Constant.appDelegate.arrCountryList.mutableCopy() as! NSMutableArray
        default :
            print("")
        }
        arrSearchResult = Utility.setSelected(selectLang, selectedText: selectedText)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnBack.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            textSearch.textAlignment =  NSTextAlignment.Right
            textSearchBG.image = UIImage(named: "ARsearch-bg.png")
        }
        else
        {
            btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            textSearch.textAlignment =  NSTextAlignment.Left
            textSearchBG.image = UIImage(named: "search-bg.png")
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        self.view.endEditing(true)
        if Structures.Constant.appDelegate.isArabic == true
        {
            btnDoneEvent()
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    @IBAction func doneBtnPressed(sender: AnyObject)
    {
        self.view.endEditing(true)
        if Structures.Constant.appDelegate.isArabic == true
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            btnDoneEvent()
        }
    }
    func btnDoneEvent()
    {
        
        if (selectType == 1){
            if self.activeTextField != nil{
                self.activeTextField.resignFirstResponder()
            }
            self.delegate?.jobTitleSelcted(self.selectedText)
        }
        if (selectType == 2){
            self.delegate?.countryOfOrigin(selectedText, selectedCode: selectedCode)
        }
        if (selectType == 3){
            self.delegate?.countryWhereWorking(selectedText, selectedCode: selectedCode)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:- PersonalDetailsTableview
    func textFieldStartEditing(textField: UITextField, tableViewCell: PersonalDetailsTableViewCell, identity: NSString, level: NSString) {
        self.activeTextField = textField
        let point : CGPoint = textField.convertPoint(textField.frame.origin, toView:self.tableView)
        let newContentOffset : CGPoint = CGPointMake(0, (point.y-40))
        self.tableView.setContentOffset(newContentOffset, animated: true)
        
    }
    func textFieldEndEditing(textField: UITextField, tableViewCell: PersonalDetailsTableViewCell, identity: NSString, level: NSString) {
        if identity == "OtherSelected" {
            self.selectedText = textField.text
            if selectedText.characters.count == 0 {
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("please_select_job_title"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField, tableViewCell: PersonalDetailsTableViewCell, identity: NSString, level: NSString) {
        if (identity as String == "OtherSelected")
        {
            let newContentOffset : CGPoint = CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.height)
            self.tableView.setContentOffset(newContentOffset, animated: true)
        }
        textField.resignFirstResponder()
        
    }
    func textFieldShouldChangeCharactersInRange(textField: UITextField, tableViewCell: PersonalDetailsTableViewCell, identity: NSString, level: NSString, range: NSRange, replacementString string: String) {
        
    }
    //MARK:- ARPersonalDetailsTableview
    func textFieldShouldChangeCharactersInRange1(textField: UITextField, tableViewCell: ARPersonalDetailsTableViewCell, identity: NSString, level: NSString, range: NSRange, replacementString string: String) {
        
    }
    func textFieldStartEditing1(textField: UITextField, tableViewCell: ARPersonalDetailsTableViewCell, identity: NSString, level: NSString)
    {
        self.activeTextField = textField
        let point : CGPoint = textField.convertPoint(textField.frame.origin, toView:self.tableView)
        let newContentOffset : CGPoint = CGPointMake(0, (point.y-40))
        self.tableView.setContentOffset(newContentOffset, animated: true)
    }
    func textFieldEndEditing1(textField: UITextField, tableViewCell: ARPersonalDetailsTableViewCell, identity: NSString, level: NSString) {
        if identity == "OtherSelected" {
            self.selectedText = textField.text
            if selectedText.characters.count == 0 {
                
                Utility.showAlertWithTitle(NSLocalizedString(Utility.getKey("please_select_job_title"),comment:""), strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            }
        }
    }
    func textFieldShouldReturn1(textField: UITextField, tableViewCell: ARPersonalDetailsTableViewCell, identity: NSString, level: NSString) {
        if (identity as String == "OtherSelected")
        {
            let newContentOffset : CGPoint = CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.height)
            self.tableView.setContentOffset(newContentOffset, animated: true)
        }
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        if textField == textSearch
        {
            if  string != "\n"
            {
                arrSearchResult = NSMutableArray()
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
                    arrSearchResult = selectLang
                }
                else
                {
                    self.isSearchActive = true
                    for (var i : Int = 0; i < selectLang.count ; i++)
                    {
                        let strRangeText : NSString  = (selectLang.objectAtIndex(i).valueForKey("Title") as! NSString).lowercaseString + (selectLang.objectAtIndex(i).valueForKey("Identity") as! NSString).lowercaseString
                        let range : NSRange = strRangeText.rangeOfString(strSearch.lowercaseString) as NSRange
                        if range.location != NSNotFound
                        {
                            arrSearchResult.addObject(selectLang.objectAtIndex(i))
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
        return true
    }
    //MARK: - TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSearchResult.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kRowHeight = self.arrSearchResult[indexPath.row]["RowHeight"] as! CGFloat
        return kRowHeight;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kCellIdentifier = self.arrSearchResult[indexPath.row]["CellIdentifier"] as! String
        
        if let cell: TitleTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell {
            cell.lblDetail.text = ""
            cell.levelString = self.arrSearchResult[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.arrSearchResult[indexPath.row]["Title"] as! String!
            cell.type = self.arrSearchResult[indexPath.row]["Type"] as! Int!
            cell.intialize()
            return cell
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier) as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = ""
                cell.levelString = self.arrSearchResult[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.arrSearchResult[indexPath.row]["Title"] as! String!
                cell.isSelectedValue = self.arrSearchResult[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.arrSearchResult[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        else
        {
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell {
                cell.lblSubDetail.text = ""
                cell.levelString = self.arrSearchResult[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.arrSearchResult[indexPath.row]["Title"] as! String!
                cell.isSelectedValue = self.arrSearchResult[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.arrSearchResult[indexPath.row]["Type"] as! Int!
                cell.intialize()
                return cell
            }
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == "PersonalDetailCellIdentifier"
        {
            if let cell: ARPersonalDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier("ARPersonalDetailsTableViewCellIndetifier") as? ARPersonalDetailsTableViewCell
            {
                cell.detailstextField.placeholder = self.arrSearchResult[indexPath.row]["Placeholder"] as! String!
                cell.detailstextField.accessibilityIdentifier = self.arrSearchResult[indexPath.row]["Identity"] as! String!
                cell.identity = self.arrSearchResult[indexPath.row]["Identity"] as! NSString!
                cell.levelString = self.arrSearchResult[indexPath.row]["Level"] as! NSString!
                cell.delegate = self
                cell.indexPath = indexPath
                cell.initialize()
                return cell
            }
        }
        else
        {
            if let cell: PersonalDetailsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? PersonalDetailsTableViewCell
            {
                cell.detailstextField.placeholder = self.arrSearchResult[indexPath.row]["Placeholder"] as! String!
                cell.detailstextField.accessibilityIdentifier = self.arrSearchResult[indexPath.row]["Identity"] as! String!
                cell.identity = self.arrSearchResult[indexPath.row]["Identity"] as! NSString!
                cell.levelString = self.arrSearchResult[indexPath.row]["Level"] as! NSString!
                cell.delegate = self
                cell.indexPath = indexPath
                cell.initialize()
                return cell
            }
        }
        
        //assert(false, "The dequeued table view cell was of an unknown type!");
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let connectedID = self.arrSearchResult[indexPath.row]["ConnectedID"] as! Int!
        let identity = arrSearchResult[indexPath.row]["Identity"] as! NSString!
        for (index, element) in self.arrSearchResult.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                let cnID = innerDict["ConnectedID"] as! Int!
                if cnID == connectedID{
                    if iden == identity{
                        innerDict["IsSelected"] = true
                        self.selectedText = innerDict["Title"] as! String
                        self.selectedCode = innerDict["Identity"] as! String
                    }else{
                        innerDict["IsSelected"] = false
                    }
                    self.arrSearchResult.replaceObjectAtIndex(index, withObject: innerDict)
                }
            }
        }
        self.tableView.reloadData()
        
    }
}
