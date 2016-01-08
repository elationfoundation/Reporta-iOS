//
//  CreateAccountStep3ViewController.swift
//  IWMF
//
//  This class is used for display Step-4 of Create Account.
//
//

import UIKit


class Step4_CreateAccountVC: UIViewController,UITableViewDataSource,UITableViewDelegate,infoBtnCProtocol,TextViewTextChanged,CreateUserProtocol, ARinfoBtnCProtocol,UserModalProtocol{
    var createAccntArr : NSMutableArray!
    var contactList : ContactList!
    var circle : Circle!
    var arr = NSMutableArray()
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        labelTitle.text=NSLocalizedString(Utility.getKey("create_account_header"),comment:"")
        btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        
        ARbtnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            ARbtnBack.hidden = false
            btnBack.hidden = true
        }
        else
        {
            ARbtnBack.hidden = true
            btnBack.hidden = false
        }
        createAccntArr = NSMutableArray()
        
        var cell: CreateNewUserTableViewCell? = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.CreateNewUserTableViewCellIdentifer) as? CreateNewUserTableViewCell
        let arr : NSArray = NSBundle.mainBundle().loadNibNamed("CreateNewUserTableViewCell", owner: self, options: nil)
        cell = (arr[0] as?  CreateNewUserTableViewCell)!
        cell!.delegate = self
        cell!.btnCancel.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
        cell!.btnConfirm.setTitle(NSLocalizedString(Utility.getKey("accept"),comment:""), forState: .Normal)
        cell!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 142)
        tableView.tableFooterView = cell
        tableView.reloadData()
        
        if let path = NSBundle.mainBundle().pathForResource("Step4_CreateAccount", ofType: "plist")
        {
            createAccntArr = NSMutableArray(contentsOfFile: path)
            
            let arrTemp : NSMutableArray = NSMutableArray(array: createAccntArr)
            
            for (index, element) in arrTemp.enumerate() {
                if var innerDict = element as? Dictionary<String, AnyObject> {
                    let strTitle = innerDict["Title"] as! String!
                    if strTitle.characters.count != 0
                    {
                        innerDict["Title"] = NSLocalizedString(Utility.getKey(strTitle),comment:"")
                        self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    }
                }
            }
        }
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "TitleTableViewCell2", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.TitleTableViewCellIdentifier2)
        self.tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "NextFooterTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.nextFooterCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "CreateNewUserTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.CreateNewUserTableViewCellIdentifer)
        self.tableView.registerNib(UINib(nibName: "ARDetailTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "ARTitleTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.ARTitleTableViewCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "HelpTextViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
        
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Navigation Button Methods
    @IBAction func btnBackClicked(sender: AnyObject) {
        backToPreviousScreen()
    }
    @IBAction func btnDoneClicked(sender: AnyObject) {
        backToPreviousScreen()
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func infoBtnClicked() {
        let agreetermsScreen : AgreeTermsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AgreeTermsViewController") as! AgreeTermsViewController
        agreetermsScreen.type = 0;
        showViewController(agreetermsScreen, sender: self.view)
    }
    
    //Register New User
    func btnCompleteAccountCreationClicked(){
        
        SVProgressHUD.showWithStatus(NSLocalizedString(Utility.getKey("registering_user"),comment:"") , maskType: 4)
        
        User.registerUser(NSMutableDictionary(dictionary:User.dictToRegister(Structures.Constant.appDelegate.prefrence.DeviceToken, user: Structures.Constant.appDelegate.userSignUpDetail, contact : Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray)),isNewUser : true)
        User.sharedInstance.delegate = self
        
       /* User.registerUser(User.dictToRegister(Structures.Constant.appDelegate.prefrence.DeviceToken, user: Structures.Constant.appDelegate.userSignUpDetail, contact : Structures.Constant.appDelegate.dictSignUpCircle["Contacts"] as! NSArray),isNewUser : true, completionClosure: { (isSuccess) -> Void in
            if isSuccess{
                Structures.Constant.appDelegate.userSignUpDetail.password = ""
                var userDetail = User()
                userDetail = userDetail.getLoggedInUser()!
                Structures.Constant.appDelegate.prefrence.LanguageCode = userDetail.languageCode
                Structures.Constant.appDelegate.prefrence.SelectedLanguage = userDetail.selectedLanguage
                AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        
                        let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                        Structures.Constant.appDelegate.window?.rootViewController? = homeNavController
                    })
                })
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
                if Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) != nil
                {
                    Utility.showAlertWithTitle((Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
                }
            }
        })*/
    }
    
    
    func commonUserResponse(wsType : WSRequestType ,dict : NSDictionary, isSuccess : Bool)
    {
        if isSuccess{
            Structures.Constant.appDelegate.userSignUpDetail.password = ""
            var userDetail = User()
            userDetail = userDetail.getLoggedInUser()!
            Structures.Constant.appDelegate.prefrence.LanguageCode = userDetail.languageCode
            Structures.Constant.appDelegate.prefrence.SelectedLanguage = userDetail.selectedLanguage
            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    
                    let homeNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyContainerVC")
                    Structures.Constant.appDelegate.window?.rootViewController? = homeNavController
                })
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
            if Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) != nil
            {
                Utility.showAlertWithTitle((Structures.Constant.appDelegate.dictCommonResult.valueForKey(Structures.Constant.Message) as? String)!, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
            }
        }
    }
    
    func btnCancelClicked()
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                Structures.Constant.appDelegate.dictSignUpCircle = NSMutableDictionary()
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let rootViewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("LanguageSelectionView")
                navigationController.viewControllers = [rootViewController]
                Structures.Constant.appDelegate.window?.rootViewController = navigationController
                
            })
        })
    }
    func textChanged(changedText : NSString){
        for (index, element) in self.createAccntArr.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == changedText{
                    innerDict["IsSelected"] = true
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    self.tableView.reloadData()
                    break
                }
            }
        }
    }
    //MARK : - TableView Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.createAccntArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let kRowHeight = self.createAccntArr[indexPath.row]["RowHeight"] as! CGFloat
        
        if  self.createAccntArr[indexPath.row]["CellIdentifier"] as? NSString == Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier
        {
            let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.HelpTextViewCellIdentifier) as! HelpTextViewCell!
            cell.txtHelpTextView.frame = CGRectMake(cell.txtHelpTextView.frame.origin.x, cell.txtHelpTextView.frame.origin.y, tableView.frame.size.width - 60, cell.txtHelpTextView.frame.size.height)
            cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("terms_of_use_help1"),comment:"") , string: NSLocalizedString(Utility.getKey("terms_of_use_help1"),comment:"")  + "\n\n" + NSLocalizedString(Utility.getKey("terms_of_use_help2"),comment:""), fontName: cell.txtHelpTextView.font)
            cell.txtHelpTextView.sizeToFit()
            return cell.txtHelpTextView.frame.size.height + 110
        }
        if  self.createAccntArr[indexPath.row]["CellIdentifier"] as? NSString == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            var strInfo : String! = ""
            
            strInfo = self.createAccntArr[indexPath.row]["Title"] as! String!
            let rect = strInfo.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width - (180), 999), options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading], attributes: [NSFontAttributeName : Utility.setFont()], context: nil)
            let H : CGFloat = rect.height
            if H < kRowHeight
            {
                return kRowHeight
            }
            return H
        }
        return kRowHeight
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let kCellIdentifier = self.createAccntArr[indexPath.row]["CellIdentifier"] as! String
        if let cell: HelpTextViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? HelpTextViewCell
        {
            cell.txtHelpTextView.attributedText = CommonUnit.boldSubstring(NSLocalizedString(Utility.getKey("terms_of_use_help1"),comment:"") , string: NSLocalizedString(Utility.getKey("terms_of_use_help1"),comment:"") + "\n\n" + NSLocalizedString(Utility.getKey("terms_of_use_help2"),comment:""), fontName: cell.txtHelpTextView.font)
            cell.btnSeeTermsofUSe.hidden = false
            cell.txtHelpTextView.sizeToFit()
            cell.btnSeeTermsofUSe.addTarget(self, action: "infoBtnClicked", forControlEvents: .TouchUpInside)
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.txtHelpTextView.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.txtHelpTextView.textAlignment = NSTextAlignment.Left
            }
            return cell
        }
        
        if let cell: TitleTableViewCell2 = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? TitleTableViewCell2 {
            cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
            cell.lblTitle.text = self.createAccntArr[indexPath.row]["Title"] as! String!
            cell.intialize()
            if Structures.Constant.appDelegate.isArabic == true
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cell.lblTitle.textAlignment = NSTextAlignment.Left
            }
            return cell
        }
        
        if Structures.Constant.appDelegate.isArabic == true && kCellIdentifier == Structures.TableViewCellIdentifiers.DetailTableViewCellIdentifier
        {
            if let cell: ARDetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(Structures.TableViewCellIdentifiers.ARDetailTableViewCellIdentifier) as? ARDetailTableViewCell
            {
                cell.lblSubDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.createAccntArr[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.createAccntArr[indexPath.row]["Type"] as! Int!
                cell.delegate = self
                cell.intialize()
                cell.widthConstant.constant = tableView.frame.size.width - 50
                return cell
            }
        }
        else
        {
            if let cell: DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as? DetailTableViewCell {
                cell.lblSubDetail.text = self.createAccntArr[indexPath.row]["OptionTitle"] as! String!
                cell.levelString = self.createAccntArr[indexPath.row]["Level"] as! NSString!
                cell.lblDetail.text = self.createAccntArr[indexPath.row]["Title"] as! String!
                cell.isSelectedValue =  self.createAccntArr[indexPath.row]["IsSelected"] as! Bool!
                cell.type = self.createAccntArr[indexPath.row]["Type"] as! Int!
                cell.delegate = self
                cell.intialize()
                cell.widthConstant.constant = tableView.frame.size.width - 50
                return cell
            }
        }
        
        let blankCell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier)!
        return blankCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let identity = createAccntArr[indexPath.row]["Identity"] as! NSString!
        for (index, element) in self.createAccntArr.enumerate() {
            if var innerDict = element as? Dictionary<String, AnyObject> {
                let iden = innerDict["Identity"] as! NSString!
                if iden == identity{
                    if iden == "sendConfirmationMail"{
                        if innerDict["IsSelected"] as! Bool{
                            Structures.Constant.appDelegate.userSignUpDetail.sendConfirmationMail = 0
                            innerDict["IsSelected"] = false
                        }else{
                            Structures.Constant.appDelegate.userSignUpDetail.sendConfirmationMail = 1
                            innerDict["IsSelected"] = true
                        }
                    }else if iden == "sendMeUpdate"{
                        if innerDict["IsSelected"] as! Bool{
                            Structures.Constant.appDelegate.userSignUpDetail.sendMail = 0
                            innerDict["IsSelected"] = false
                        }else{
                            Structures.Constant.appDelegate.userSignUpDetail.sendMail = 1
                            innerDict["IsSelected"] = true
                        }
                    }
                    self.createAccntArr.replaceObjectAtIndex(index, withObject: innerDict)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
