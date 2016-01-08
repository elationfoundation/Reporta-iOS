//
//  CheckInDescriptionViewController.swift
//  IWMF
//
// This class is used for Add description in Check-In and Alert.
//
//

import Foundation
import UIKit

enum DescriptionNavigationTitle : Int{
    case CheckIn = 0
    case Alert = 1
}

protocol CheckInDescriptionProtocol{
    func checkInDescription(description : NSString)
}

class CheckInDescriptionViewController: UIViewController, UITextViewDelegate {
    var textViewText: NSString = ""
    @IBOutlet weak var textView: UITextView!
    var delegate : CheckInDescriptionProtocol?
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var descriptionTitle: UILabel!
    var changeTitle : Int!
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            selectDone()
        }
        else
        {
            textView.resignFirstResponder()
            backToPreviousScreen()
        }
    }
    @IBAction func btnDoneClicked(sender: AnyObject)
    {
        if Structures.Constant.appDelegate.isArabic == true
        {
            textView.resignFirstResponder()
            backToPreviousScreen()
        }
        else
        {
            selectDone()
        }
    }
    func selectDone()
    {
        if textView.text.characters.count > 0
        {
            textView.resignFirstResponder()
            delegate?.checkInDescription(textView.text)
            backToPreviousScreen()
        }
        
    }
    func backToPreviousScreen()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad()
    {
        textView.text = NSLocalizedString(Utility.getKey("Describe your situation"),comment:"")
        descriptionTitle.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
        self.descriptionTitle.font = Utility.setNavigationFont()
        
        switch changeTitle{
        case LocationNavigationTitle.Alert.rawValue :
            self.descriptionTitle.text = NSLocalizedString(Utility.getKey("alerts"),comment:"")
            
            
        case LocationNavigationTitle.CheckIn.rawValue :
            self.descriptionTitle.text = NSLocalizedString(Utility.getKey("check_in"),comment:"")
            
            
        default :
            print("")
        }
        
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        if Structures.Constant.appDelegate.isArabic == true
        {
            textView.textAlignment =  NSTextAlignment.Right
            btnBack.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
        }
        else
        {
            textView.textAlignment =  NSTextAlignment.Left
            btnBack.setTitle(NSLocalizedString(Utility.getKey("back"),comment:""), forState: .Normal)
            btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        }
        
        textView.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        textView.resignFirstResponder()
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textViewDidBeginEditing(textView: UITextView)
    {
        textView.text = textViewText as String
        textView.textColor = UIColor.blackColor()
        if textView.textColor == UIColor.lightGrayColor()
        {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        let newLength = textView.text.characters.count + text.characters.count - range.length
        return newLength <= 255
    }
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = NSLocalizedString(Utility.getKey("Describe your situation"),comment:"")
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
}