//
//  PersonalDetailsTableViewCell.swift
//  IWMF
//
//
//
//

import UIKit


protocol PersonalDetailTextProtocol{
    func textFieldStartEditing(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString)
    func textFieldEndEditing(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString)
    func textFieldShouldReturn(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString)
    func textFieldShouldChangeCharactersInRange(textField : UITextField, tableViewCell : PersonalDetailsTableViewCell, identity : NSString, level : NSString, range: NSRange, replacementString string: String)
}

class PersonalDetailsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var ivBelowLine: UIImageView!
    @IBOutlet weak var detailstextField: UITextField!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivUpperCutLine: UIImageView!
    typealias level = Level
    var identity : NSString = ""
    var levelString : NSString = ""
    var value : String = ""
    var delegate : PersonalDetailTextProtocol!
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
        if identity == "Password" || identity == "Re-enterPassword" || identity == "NewPassword" || identity == "ConfirmPassword" {
            detailstextField.secureTextEntry = true
        }else if identity == "Email"  || identity == "ReEnterEmail"{
            detailstextField.keyboardType = UIKeyboardType.EmailAddress
        }else if identity == "Phone"  {
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
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.delegate?.textFieldStartEditing(textField, tableViewCell:self, identity: self.identity, level: self.levelString)
        if detailstextField.accessibilityIdentifier == "Firstname" || detailstextField.accessibilityIdentifier == "Lastname"
        {
        }
    }    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String)  -> Bool
    {
        delegate?.textFieldShouldChangeCharactersInRange(textField, tableViewCell: self, identity: self.identity, level: self.levelString, range: range, replacementString: string)
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
        delegate?.textFieldEndEditing(textField, tableViewCell:self, identity: self.identity, level: self.levelString)
        if detailstextField.accessibilityIdentifier == "Firstname" || detailstextField.accessibilityIdentifier == "Lastname"
        {
        }
        else if textField.accessibilityIdentifier == "Email"  || textField.accessibilityIdentifier == "ReEnterEmail"
        {
          
        }
    }    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        delegate?.textFieldShouldReturn(textField, tableViewCell:self, identity: self.identity, level: self.levelString)
        if detailstextField.accessibilityIdentifier == "Firstname" || detailstextField.accessibilityIdentifier == "Lastname"
        {
        }
        return true;
    }    
    
}
