//
//  LearnReportaViewController.swift
//  IWMF
//
//  This class is used for display Details about Reporta in WebView.
//
//

import Foundation
import UIKit

class LearnReportaViewController : UIViewController, UIWebViewDelegate {
        @IBOutlet weak var webView: UIWebView!
    
    func backToPreviousScreen(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - Button Functions
    @IBAction func closeclicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        
        
        let urlstr : String! = String(format: "%@", Structures.WS.BaseURL + Structures.WS.AboutReporta)
        
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
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    func webViewDidStartLoad(webView: UIWebView)
    {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView)
    {
        SVProgressHUD.dismiss()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?)
    {
        SVProgressHUD.dismiss()
    }
}