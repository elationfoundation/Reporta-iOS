 //
 //  SocialViewController.swift
 //  IWMF
 //
 // This class is used for Add social circle in Check in or Alert.
 //
 //
 
 import UIKit
 import Social
 import Accounts
 
 
 protocol CheckInSocialProtocol
 {
    func checkInSocial(strTwitterToken : NSString , strTwitterSecret: NSString , strFacebookToken: NSString)
 }
 enum socialViewFrom : Int{
    case CheckIn = 0
    case Alert = 1
 }
 
 class SocialViewController: UIViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var ARbtnBack: UIButton!
    @IBOutlet weak var tblList: UITableView!
        var delegate : CheckInSocialProtocol?
    var twitter : STTwitterAPI!
    var twitteroAuthToken : NSString!
    var twitteroAuthTokenSecret : NSString!
    var mySocialViewFrom : socialViewFrom!
    var facebookoAuthToken : NSString!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Structures.Constant.appDelegate.prefrence.isFacebookAvailable = false
        Structures.Constant.appDelegate.prefrence.isTwitterAvailable = false
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        
        lblTitle.text =  NSLocalizedString(Utility.getKey("contacts"),comment:"")
        tblList.separatorStyle = UITableViewCellSeparatorStyle.None
        lblTitle.font = Utility.setNavigationFont()
        
        if mySocialViewFrom != nil{
            if mySocialViewFrom == socialViewFrom.Alert{
            }else if mySocialViewFrom == socialViewFrom.CheckIn{
            }
        }
        else{
            
        }
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            twitterLogin()
        }
        
    }
    override func viewWillAppear(animated: Bool) {
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
    @IBAction func btnBackPressed(sender: AnyObject) {
        if Structures.Constant.appDelegate.prefrence.twitteroAuthTokenSecret.length != 0
        {
            twitteroAuthTokenSecret = Structures.Constant.appDelegate.prefrence.twitteroAuthTokenSecret
            twitteroAuthToken = Structures.Constant.appDelegate.prefrence.twitteroAuthTokenSecret
        }
        if Structures.Constant.appDelegate.prefrence.facebookoAuthToken.length != 0
        {
            facebookoAuthToken = Structures.Constant.appDelegate.prefrence.facebookoAuthToken
        }
        if  Structures.Constant.appDelegate.prefrence.isFacebookSelected == false
        {
            facebookoAuthToken = ""
        }
        if Structures.Constant.appDelegate.prefrence.isTwitterSelected == false
        {
            twitteroAuthToken = ""
            twitteroAuthTokenSecret = ""
        }
        delegate?.checkInSocial(twitteroAuthToken , strTwitterSecret: twitteroAuthTokenSecret , strFacebookToken: facebookoAuthToken)
        backToPreviousScreen()
    }
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK:- table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3{
            return 46
        }
        else{
            return 70
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellIdentifier : String = "cell"
        var cellTitle: TitleTableViewCell2? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TitleTableViewCell2
        if indexPath.row == 0
        {
            if (cellTitle == nil)
            {
                let arr : NSArray = NSBundle.mainBundle().loadNibNamed("TitleTableViewCell2", owner: self, options: nil)
                cellTitle = arr[0] as? TitleTableViewCell2
            }
            cellTitle?.selectionStyle = UITableViewCellSelectionStyle.None
            cellTitle?.levelString = "Top"
            cellTitle?.lblTitle.text =  NSLocalizedString(Utility.getKey("Social media"),comment:"")
            if Structures.Constant.appDelegate.isArabic == true
            {
                cellTitle?.lblTitle.textAlignment = NSTextAlignment.Right
            }
            else
            {
                cellTitle?.lblTitle.textAlignment = NSTextAlignment.Left
            }
            cellTitle?.intialize()
            return cellTitle!
        }
        else if indexPath.row == 1
        {
            if Structures.Constant.appDelegate.isArabic == true
            {
                var cellSearch: ARSearchCircleCell? = tableView.dequeueReusableCellWithIdentifier("ARSearchCircleCell") as? ARSearchCircleCell
                if (cellSearch == nil)
                {
                    let arr : NSArray = NSBundle.mainBundle().loadNibNamed("ARSearchCircleCell", owner: self, options: nil)
                    cellSearch = arr[0] as? ARSearchCircleCell
                }
                cellSearch?.selectionStyle = UITableViewCellSelectionStyle.None
                cellSearch?.userInteractionEnabled = false
                cellSearch?.btnEdit.userInteractionEnabled = false
                cellSearch?.btnEdit.hidden = true
                cellSearch?.btnEdit.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
                cellSearch!.lbSep.hidden = true
                cellSearch?.btnAddContact.hidden = true
                cellSearch?.lblTitle.text = (NSLocalizedString(Utility.getKey("Connect_to_your_social_media"),comment:"")) as String
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
                cellSearch?.selectionStyle = UITableViewCellSelectionStyle.None
                cellSearch?.btnEdit.userInteractionEnabled = false
                cellSearch?.btnEdit.hidden = true
                cellSearch?.btnEdit.setTitleColor((Utility.UIColorFromHex(0x8E8E8E, alpha: 1)), forState: UIControlState.Normal)
                cellSearch!.lbSep.hidden = true
                cellSearch?.btnAddContact.hidden = true
                cellSearch?.lblTitle.text = (NSLocalizedString(Utility.getKey("Connect_to_your_social_media"),comment:"")) as String
                return cellSearch!
            }
        }
        else if Structures.Constant.appDelegate.isArabic == true
        {
            if indexPath.row == 2 || indexPath.row == 3
            {
                var cell: ARSocialCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ARSocialCell
                if (cell == nil)
                {
                    let arr : NSArray = NSBundle.mainBundle().loadNibNamed("ARSocialCell", owner: self, options: nil)
                    cell = arr[0] as? ARSocialCell
                    cell?.btnMark.addTarget(self, action: "socialLogin:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell?.btnLogin.addTarget(self, action: "LoginAlert:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                cell?.btnLogin.tag = indexPath.row
                if mySocialViewFrom == nil
                {
                    cell?.positionX.constant  = 15
                    cell?.btnMark.hidden = true
                }
                if  indexPath.row == 2
                {
                    cell?.selectionStyle = UITableViewCellSelectionStyle.None
                    cell?.userInteractionEnabled = false
                    cell?.fullLine.hidden = true
                    cell?.fullLineTop.hidden = false
                    cell?.imgView.image = UIImage(named: "facebook.png")
                    cell?.lblTitle.text = "Facebook"
                    cell?.btnMark.tag = indexPath.row
                    if Structures.Constant.appDelegate.prefrence.isFacebookAvailable == true
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("logout"),comment:""), forState: UIControlState.Normal)
                    }
                    else
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("login"),comment:""), forState: UIControlState.Normal)
                    }
                    if Structures.Constant.appDelegate.prefrence.isFacebookSelected == true
                    {
                        cell?.btnMark.selected = true
                    }
                    else
                    {
                        cell?.btnMark.selected = false
                    }
                    
                }
                else if  indexPath.row == 3
                {
                    cell?.ShortLine.hidden = false
                    cell?.fullLineTop.hidden = true
                    cell?.fullLine.hidden = false
                    cell?.imgView.image = UIImage(named: "twitter.png")
                    cell?.lblTitle.text = "Twitter"
                    cell?.btnMark.tag = indexPath.row
                    if Structures.Constant.appDelegate.prefrence.isTwitterAvailable == true
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("logout"),comment:""), forState: UIControlState.Normal)
                    }
                    else
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("add"),comment:""), forState: UIControlState.Normal)
                    }
                    if Structures.Constant.appDelegate.prefrence.isTwitterSelected == true
                    {
                        cell?.btnMark.selected = true
                    }
                    else
                    {
                        cell?.btnMark.selected = false
                    }
                }
                return cell!
            }
        }
        else
        {
            if indexPath.row == 2 || indexPath.row == 3
            {
                var cell: SocialCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? SocialCell
                if (cell == nil)
                {
                    let arr : NSArray = NSBundle.mainBundle().loadNibNamed("SocialCell", owner: self, options: nil)
                    cell = arr[0] as? SocialCell
                    cell?.btnMark.addTarget(self, action: "socialLogin:", forControlEvents: UIControlEvents.TouchUpInside)
                    cell?.btnLogin.addTarget(self, action: "LoginAlert:", forControlEvents: UIControlEvents.TouchUpInside)
                }
                
                cell?.btnLogin.tag = indexPath.row
                if mySocialViewFrom == nil
                {
                    cell?.positionX.constant  = 15
                    cell?.btnMark.hidden = true
                }
                
                if  indexPath.row == 2
                {
                    cell?.selectionStyle = UITableViewCellSelectionStyle.None
                    cell?.userInteractionEnabled = false
                    cell?.ShortLine.hidden = false
                    cell?.fullLine.hidden = true
                    cell?.fullLineTop.hidden = false
                    cell?.imgView.image = UIImage(named: "facebook.png")
                    cell?.lblTitle.text = "Facebook"
                    cell?.btnMark.tag = indexPath.row
                    if Structures.Constant.appDelegate.prefrence.isFacebookAvailable == true
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("logout"),comment:""), forState: UIControlState.Normal)
                    }
                    else
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("add"),comment:""), forState: UIControlState.Normal)
                    }
                    if Structures.Constant.appDelegate.prefrence.isFacebookSelected == true
                    {
                        cell?.btnMark.selected = true
                    }
                    else
                    {
                        cell?.btnMark.selected = false
                    }
                    
                }
                else if  indexPath.row == 3
                {
                    cell?.ShortLine.hidden = false
                    cell?.fullLineTop.hidden = true
                    cell?.fullLine.hidden = false
                    cell?.imgView.image = UIImage(named: "twitter.png")
                    cell?.lblTitle.text = "Twitter"
                    cell?.btnMark.tag = indexPath.row
                    if Structures.Constant.appDelegate.prefrence.isTwitterAvailable == true
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("logout"),comment:""), forState: UIControlState.Normal)
                    }
                    else
                    {
                        cell?.btnLogin.setTitle(NSLocalizedString(Utility.getKey("add"),comment:""), forState: UIControlState.Normal)
                    }
                    if Structures.Constant.appDelegate.prefrence.isTwitterSelected == true
                    {
                        cell?.btnMark.selected = true
                    }
                    else
                    {
                        cell?.btnMark.selected = false
                    }
                }
                return cell!
            }
        }
        return cellTitle!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    //MARK:- Social Available or not
    func twitterLogin()
    {
        SVProgressHUD.show()
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil)
            {
                granted, error in
                if granted
                {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    if (twitterAccounts != nil)
                    {
                        if twitterAccounts.count == 0
                        {
                            SVProgressHUD.dismiss()
                        }
                        else
                        {
                            let twitterAccount = twitterAccounts[0] as! ACAccount
                            let twitter = STTwitterAPI(OAuthConsumerKey: Utility.getDecryptedString(Structures.AppKeys.TwitterConsumerKey) as String, consumerSecret: Utility.getDecryptedString(Structures.AppKeys.TwitterConsumerSecret) as String)
                            twitter.postReverseOAuthTokenRequest({ (authenticationHeader) -> Void in
                                let twitterAPIOS = STTwitterAPI.twitterAPIOSWithAccount(twitterAccount)
                                twitterAPIOS.verifyCredentialsWithSuccessBlock({ (username) -> Void in
                                    twitterAPIOS.postReverseAuthAccessTokenWithAuthenticationHeader(authenticationHeader, successBlock: { (oAuthToken, oAuthTokenSecret, userID, screenName) -> Void in
                                        self.twitteroAuthToken = oAuthToken
                                        self.twitteroAuthTokenSecret = oAuthTokenSecret
                                        Structures.Constant.appDelegate.prefrence.twitteroAuthTokenSecret = oAuthTokenSecret
                                        Structures.Constant.appDelegate.prefrence.twitteroAuthToken = oAuthToken
                                        Structures.Constant.appDelegate.prefrence.isTwitterAvailable = true
                                        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                                        
                                        SVProgressHUD.dismiss()
                                        self.tblList.reloadData()
                                        
                                        }, errorBlock: { (error) -> Void in
                                            SVProgressHUD.dismiss()
                                    })
                                    }, errorBlock: { (error) -> Void in
                                        SVProgressHUD.dismiss()
                                })
                                }, errorBlock: { (error) -> Void in
                                    SVProgressHUD.dismiss()
                            })
                        }
                    }
                    else
                    {
                        SVProgressHUD.dismiss()
                    }
                }
                else
                {
                    SVProgressHUD.dismiss()
                }
        }
    }
    func facebookLogin()
    {
        SVProgressHUD.show()
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        let optionsForPosting = [ACFacebookAppIdKey:Utility.getDecryptedString(Structures.AppKeys.FacebookAppId), ACFacebookPermissionsKey: [Structures.User.UserEmail], ACFacebookAudienceKey: ACFacebookAudienceFriends]
        accountStore.requestAccessToAccountsWithType(accountType, options: optionsForPosting as [NSObject : AnyObject]) {
            granted, error in
            if granted {
                let options = [ACFacebookAppIdKey: Utility.getDecryptedString(Structures.AppKeys.FacebookAppId) , ACFacebookPermissionsKey: ["publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceFriends]
                accountStore.requestAccessToAccountsWithType(accountType, options: options as [NSObject : AnyObject]) {
                    granted, error in
                    if granted {
                        var accountsArray = accountStore.accountsWithAccountType(accountType)
                        if accountsArray.count > 0
                        {
                            let facebookAccount = accountsArray[0] as!  ACAccount
                            self.facebookoAuthToken = facebookAccount.credential.oauthToken
                            Structures.Constant.appDelegate.prefrence.facebookoAuthToken = facebookAccount.credential.oauthToken
                            Structures.Constant.appDelegate.prefrence.isFacebookAvailable = true
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                SVProgressHUD.dismiss()
                                self.tblList.reloadData()
                            })
                        }
                    }
                    else
                    {
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
    //MARK:- Select Social
    func socialLogin(btn: UIButton) {
        
        if btn.tag == 2
        {
            if  Structures.Constant.appDelegate.prefrence.isFacebookAvailable == true
            {
                if Structures.Constant.appDelegate.prefrence.isFacebookSelected == false
                {
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.facebookLogin()
                            Structures.Constant.appDelegate.prefrence.isFacebookSelected = true
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                        })
                    }
                }
                else
                {
                    Structures.Constant.appDelegate.prefrence.isFacebookSelected = false
                    AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                }
            }
            else
            {
                if Structures.Constant.appDelegate.prefrence.isFacebookAvailable == false
                {
                    LoginAlert(btn)
                }
                else
                {
                    Structures.Constant.appDelegate.prefrence.isFacebookSelected = false
                    AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                }
            }
        }
        else if btn.tag == 3
        {
            if Structures.Constant.appDelegate.prefrence.isTwitterAvailable == true
            {
                if Structures.Constant.appDelegate.prefrence.isTwitterSelected == false
                {
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
                    {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.twitterLogin()
                            Structures.Constant.appDelegate.prefrence.isTwitterSelected = true
                            AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                            self.tblList.reloadData()
                        })
                    }
                }
                else
                {
                    Structures.Constant.appDelegate.prefrence.isTwitterSelected = false
                    AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                }
            }
            else
            {
                if Structures.Constant.appDelegate.prefrence.isTwitterAvailable == false
                {
                    LoginAlert(btn)
                }
                else
                {
                    Structures.Constant.appDelegate.prefrence.isTwitterAvailable = false
                    AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
                }
            }
        }
        tblList.reloadData()
    }
    //MARK:- Login / Logout Alert
    func LoginAlert(btn: UIButton)
    {
        var strMessage : NSString!
        if btn.tag == 2
        {
            if Structures.Constant.appDelegate.prefrence.isFacebookAvailable == true
            {
                strMessage = NSLocalizedString(Utility.getKey("facebook_account_logout"),comment:"")
            }
            else
            {
                strMessage = NSLocalizedString(Utility.getKey("no_facebook_account"),comment:"")
            }
        }
        else if btn.tag == 3
        {
            
            if Structures.Constant.appDelegate.prefrence.isTwitterAvailable == true
            {
                strMessage = NSLocalizedString(Utility.getKey("twitter_account_logout"),comment:"")
            }
            else
            {
                strMessage = NSLocalizedString(Utility.getKey("no_twitter_account"),comment:"")
            }
        }
        Utility.showAlertWithTitle(strMessage as String, strMessage: "", strButtonTitle: NSLocalizedString(Utility.getKey("Ok"),comment:""), view: self)
        
    }
 }
