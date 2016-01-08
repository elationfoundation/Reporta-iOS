//
//  AddContactCell.swift
//  IWMF
//
//
//
//

import UIKit

class AddContactCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var btnAddCircle: UIButton!
    @IBOutlet var txtTitle : UITextField!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var viewAdd : UIView!
    @IBOutlet var viewFriendUnblock: UIView!
    @IBOutlet var btnAddFriend: UIButton!
    @IBOutlet var viewBlank : UIView!
    @IBOutlet var btnAdd : UIButton!
    @IBOutlet var btnMoreInfo : UIButton!
    @IBOutlet var lblMoreInfo : UILabel!
    @IBOutlet var lblSep : UILabel!
    @IBOutlet var lblSepShort : UILabel!
    @IBOutlet weak var friendUnlockLabel: UILabel!
    
    @IBOutlet weak var textEmailPhone: UITextField!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var lblCircleText: UILabel!
    @IBOutlet weak var btnCircleMark: UIButton!
    @IBOutlet weak var lblCircleType: UILabel!
    @IBOutlet weak var btnAddEmailPhone: UIButton!
    @IBOutlet weak var viewContactIsPart: UIView!
    @IBOutlet weak var lblContactIsPartOf: UILabel!
        override func awakeFromNib()
    {
        super.awakeFromNib()
        txtTitle.autocapitalizationType = UITextAutocapitalizationType.Sentences
        self.lblTitle.font = Utility.setFont()
        self.lblMoreInfo.font = Utility.setFont()
        self.friendUnlockLabel.font = Utility.setFont()
        self.lblSep.font = Utility.setFont()
        self.txtTitle.font = Utility.setFont()
        self.btnAddFriend.titleLabel?.font = Utility.setFont()
        self.btnAdd.titleLabel?.font = Utility.setFont()
        self.btnMoreInfo.titleLabel?.font = Utility.setFont()
        self.lblCircleText.font = Utility.setFont()
        self.lblContactIsPartOf.font = Utility.setFont()
        self.textEmailPhone.font = Utility.setFont()
        self.lblCircleType.font = Utility.setDetailFont()
        if(CommonUnit.isIphone4())
        {
            btnAddCircle.titleLabel?.font = UIFont.systemFontOfSize(18)
        }
        if(CommonUnit.isIphone5())
        {
            btnAddCircle.titleLabel?.font = UIFont.systemFontOfSize(18)
        }
        if(CommonUnit.isIphone6())
        {
            btnAddCircle.titleLabel?.font = UIFont.systemFontOfSize(20)
        }
        if(CommonUnit.isIphone6plus())
        {
            btnAddCircle.titleLabel?.font = UIFont.systemFontOfSize(21)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
