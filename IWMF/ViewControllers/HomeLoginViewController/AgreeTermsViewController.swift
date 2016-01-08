//
//  AgreeTermsViewController.swift
//  IWMF
//
// This class is used for display Terms and Conditions in webview.
//
//

import UIKit



protocol TextViewTextChanged{
    func textChanged(changedText : NSString)
}

class AgreeTermsViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    var type : Int!
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // type 0 = display from create Account screen, 1 = display from Profile Screen
        if type == 0{
            lblTitle.text=NSLocalizedString(Utility.getKey("create_account_header"),comment:"")
        }else{
            lblTitle.text=NSLocalizedString(Utility.getKey("profile"),comment:"")
        }
        lblTitle.font = Utility.setNavigationFont()
        if Structures.Constant.appDelegate.isArabic == true
        {
            self.btnDone.hidden = false
            btnBack.hidden = true
            btnBack.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        }
        else
        {
            self.btnDone.hidden = true
            btnBack.hidden = false
            btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        }
        
        let urlstr : String! = String(format: "%@", Structures.WS.BaseURL + Structures.WS.TermsAndConditions)
        
        if Structures.Constant.appDelegate.strLanguage == Structures.Constant.Spanish
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlstr + Structures.AppKeys.Spanish)!))
        }
        else if Structures.Constant.appDelegate.strLanguage == Structures.Constant.French
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlstr + Structures.AppKeys.French)!))
        }
        else if Structures.Constant.appDelegate.strLanguage == Structures.Constant.Turkish
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlstr + Structures.AppKeys.Turkish)!))
        }
        else if Structures.Constant.appDelegate.strLanguage == Structures.Constant.Arabic
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlstr + Structures.AppKeys.Arabic)!))
        }
        else if Structures.Constant.appDelegate.strLanguage == Structures.Constant.Hebrew
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlstr + Structures.AppKeys.Hebrew)!))
        }
        else
        {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: urlstr + Structures.AppKeys.English)!))
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
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
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        SVProgressHUD.dismiss()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError)
    {
        SVProgressHUD.dismiss()
    }
    
}
