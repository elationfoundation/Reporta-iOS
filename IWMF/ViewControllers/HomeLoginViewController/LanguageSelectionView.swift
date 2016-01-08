//
//  LanguageSelectionView.swift
//  IWMF
//
//  This class is used for select language for user.
//
//

import UIKit

class LanguageSelectionView: UIViewController,UITextFieldDelegate , UIAlertViewDelegate {
    @IBOutlet weak var lblPoweredBy: UILabel!
    @IBOutlet weak var lblIWMF: UILabel!
    @IBOutlet weak var txtLanguage: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    var selectedIndex : Int!
    @IBOutlet weak var btnArrow: UIButton!
    var seletLang: NSMutableArray!
        var selectedIndexes :  NSMutableIndexSet!
    let isDeviceJailbroken : Bool = CommonUnit.isDeviceJailbroken()
    override func viewDidLoad()
    {
        if isDeviceJailbroken{
            self.view.userInteractionEnabled = false
        }
        super.viewDidLoad()
        selectedIndex = 1
        
        
        Structures.Constant.appDelegate.isArabic = false
        Structures.Constant.appDelegate.strLanguage = Structures.Constant.English
        
        Structures.Constant.appDelegate.prefrence.LanguageSelected = false
        if let path = NSBundle.mainBundle().pathForResource("SelectLanguage", ofType: "plist")
        {
            seletLang = NSMutableArray(contentsOfFile: path)
        }
        
        txtLanguage.text = seletLang[selectedIndex]["Title"] as! String!
        Structures.Constant.appDelegate.prefrence.SelectedLanguage = self.seletLang[selectedIndex]["Identity"] as! String
        Structures.Constant.appDelegate.prefrence.LanguageCode = self.seletLang[selectedIndex]["Level"] as! String
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
    @IBAction func btnNextClick(sender: AnyObject)
    {
        Structures.Constant.appDelegate.prefrence.LanguageSelected = true
        // Language String In Enlish
        Structures.Constant.appDelegate.prefrence.SelectedLanguage = self.seletLang[selectedIndex]["Title"] as! String
        
        // Language Code for Web
        Structures.Constant.appDelegate.prefrence.LanguageCode = self.seletLang[selectedIndex]["Level"] as! String
        AppPrefrences.saveAppPrefrences(Structures.Constant.appDelegate.prefrence)
        
        Structures.Constant.appDelegate.strLanguage = self.seletLang[selectedIndex]["Level"] as! String! // Language Code For App
        if selectedIndex == 0 || selectedIndex == 3
        {
            Structures.Constant.appDelegate.isArabic = true
        }
        Structures.Constant.languageBundle = CommonUnit.setLanguage(Structures.Constant.appDelegate.prefrence.LanguageCode as String)

        
        self.performSegueWithIdentifier("languagePush", sender: nil)
        
    }
    @IBAction func btnArrowClick(sender: AnyObject)
    {
        alertForLanguage()
    }
    //Mark: TxtField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        alertForLanguage()
        return false
    }
    func alertForLanguage()
    {
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString(Utility.getKey("selectlanguage"),comment:"") , message: nil, preferredStyle: .Alert)
        actionSheetController.view.tintColor = UIColor.blackColor()
        
        let one: UIAlertAction = UIAlertAction(title: seletLang[0]["Title"] as! String!, style: .Default) { action -> Void in
            self.txtLanguage.text = self.seletLang[0]["Title"] as! String!
            self.selectedIndex = 0
        }
        actionSheetController.addAction(one)
        
        let two: UIAlertAction = UIAlertAction(title:self.seletLang[1]["Title"] as! String!, style: .Default) { action -> Void in
            self.txtLanguage.text = self.seletLang[1]["Title"] as! String!
            self.selectedIndex = 1
        }
        actionSheetController.addAction(two)
        
        let three: UIAlertAction = UIAlertAction(title:self.seletLang[2]["Title"] as! String!, style: .Default) { action -> Void in
            self.txtLanguage.text = self.seletLang[2]["Title"] as! String!
            self.selectedIndex = 2
        }
        actionSheetController.addAction(three)
        
        let four: UIAlertAction = UIAlertAction(title:self.seletLang[3]["Title"] as! String!, style: .Default) { action -> Void in
            self.txtLanguage.text = self.seletLang[3]["Title"] as! String!
            self.selectedIndex = 3
        }
        actionSheetController.addAction(four)
        
        let five: UIAlertAction = UIAlertAction(title:self.seletLang[4]["Title"] as! String!, style: .Default) { action -> Void in
            self.txtLanguage.text = self.seletLang[4]["Title"] as! String!
            self.selectedIndex = 4
        }
        actionSheetController.addAction(five)
        let six: UIAlertAction = UIAlertAction(title:self.seletLang[5]["Title"] as! String!, style: .Default) { action -> Void in
            self.txtLanguage.text = self.seletLang[5]["Title"] as! String!
            self.selectedIndex = 5
        }
        actionSheetController.addAction(six)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel)
            { action -> Void in
        }
        
        actionSheetController.addAction(cancelAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}

