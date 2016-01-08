//
//  ARPersonalDetailsTableViewCell.swift
//  IWMF
//
//
//
//

import UIKit

protocol ARPersonalDetailsTableView  {
    func textFieldStartEditing1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    func textFieldEndEditing1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    func textFieldShouldReturn1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString)
    func textFieldShouldChangeCharactersInRange1(textField : UITextField, tableViewCell : ARPersonalDetailsTableViewCell, identity : NSString, level : NSString, range: NSRange, replacementString string: String)
}

class ARPersonalDetailsTableViewCell: UITableViewCell,UITextFieldDelegate{
    @IBOutlet weak var detailstextField: UITextField!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivUpperCutLine: UIImageView!
    @IBOutlet var ivBelowLine: UIImageView!
    typealias level = Level
    var identity : NSString = ""
    var levelString : NSString = ""
    var value : String = ""
    var delegate : ARPersonalDetailsTableView!
    var indexPath : NSIndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func initialize(){
        self.detailstextField.delegate = self
        detailstextField.text = value
        detailstextField.font = Utility.setFont()
        self.lblDetail.font = Utility.setFont()
        self.lblDetail.font = Structures.Constant.Roboto_Regular16
        
        detailstextField.keyboardType = UIKeyboardType.Default
        detailstextField.secureTextEntry = false
        if identity == "Password" || identity == "Re-enterPassword" || identity == "NewPassword" || identity == "ConfirmPassword"{
            detailstextField.secureTextEntry = true
        }else if identity == "Email"  || identity == "ReEnterEmail"{
            detailstextField.keyboardType = UIKeyboardType.EmailAddress
        }else if identity == "Phone"{
            detailstextField.keyboardType = UIKeyboardType.PhonePad
        }
        else if identity != "Username"  {
            detailstextField.autocapitalizationType = UITextAutocapitalizationType.Sentences
        }
        
        
        if levelString == Level.Single.rawValue{
            ivUpperCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = false
            
        }else if levelString == Level.Top.rawValue{
            detailstextField.returnKeyType = UIReturnKeyType.Next
            ivUpperCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = true
        }else if levelString == Level.Middle.rawValue{
            detailstextField.returnKeyType = UIReturnKeyType.Next
            ivUpperCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = true
        }else{
            detailstextField.returnKeyType = UIReturnKeyType.Done
            ivUpperCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = false
        }
        
    }
    func textFieldDidBeginEditing(textField: UITextField){
        self.delegate?.textFieldStartEditing1(textField, tableViewCell:self, identity: self.identity, level: self.levelString)
        if detailstextField.accessibilityIdentifier == "Firstname"
        {
        }
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        
        delegate?.textFieldShouldChangeCharactersInRange1(textField, tableViewCell: self, identity: self.identity, level: self.levelString, range: range, replacementString: string)
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        if detailstextField.accessibilityIdentifier != nil
        {
            if detailstextField.accessibilityIdentifier == "Username"
            {
                detailstextField.text = Utility.trimWhitespace(detailstextField.text!)
                return newLength <= 25
            }
            else if textField.accessibilityIdentifier == "Email"  || textField.accessibilityIdentifier == "ReEnterEmail" || textField.accessibilityIdentifier == "Affiliation"
            {
                return newLength <= 100
            }
            else if textField.accessibilityIdentifier == "Phone" || textField.accessibilityIdentifier == "Firstname" || textField.accessibilityIdentifier == "Lastname"
            {
                return newLength <= 25
            }
            
            
        }
        return true
    }
    func textFieldDidEndEditing(textField: UITextField)
    {
        delegate?.textFieldEndEditing1(textField, tableViewCell:self, identity: self.identity, level: self.levelString)
        if detailstextField.accessibilityIdentifier != nil
        {
            if detailstextField.accessibilityIdentifier == "Firstname" || detailstextField.accessibilityIdentifier == "Lastname"
            {
            }
            else if textField.accessibilityIdentifier == "Email"  || textField.accessibilityIdentifier == "ReEnterEmail"
            {
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        delegate?.textFieldShouldReturn1(textField, tableViewCell:self, identity: self.identity, level: self.levelString)
        if detailstextField.accessibilityIdentifier == "Firstname" || detailstextField.accessibilityIdentifier == "Lastname"
        {
        }
        return true;
    }
}
