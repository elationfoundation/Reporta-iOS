//
//  TitleTableViewCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

protocol infoBtnCProtocol{
    func infoBtnClicked()
}

class DetailTableViewCell: UITableViewCell {    
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivUpperCutLine: UIImageView!
    @IBOutlet weak var ivBelowLine: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblSubDetail: UILabel!
    @IBOutlet weak var ivRight: UIImageView!
 
    @IBOutlet var widthConstant: NSLayoutConstraint!
    typealias level = Level!
    var levelString : NSString = ""
    var isSelectedValue : Bool = false
    var type : Int = 0
    var delegate : infoBtnCProtocol!
    var identity : String = ""    
    @IBOutlet weak var btnArrow: UIButton!
    @IBAction func btnArrowClicked(sender: AnyObject) {
         self.delegate?.infoBtnClicked()
    }    
    @IBOutlet weak var btnAdd: UIButton!
    @IBAction func btnAddClicked(sender: AnyObject) {
    }    
    func intialize()
    {    
        self.lblDetail.font = Utility.setFont()
        self.lblSubDetail.font = Utility.setDetailFont()
        if type == 2
        {
            btnArrow.hidden = false
        }
        else
        {
            btnArrow.hidden = true
        }
        
        if isSelectedValue && type == 1
        {
            ivRight.image = UIImage(named: "right")
            ivRight.hidden = false
            if identity == "Male" || identity == "Female" || identity == "Other" || identity == "1" || identity == "2" || identity == "3"// 1 = Email, 2 = Notifications, 3 = SMS
            {
                ivRight.hidden = false
                ivRight.image = UIImage(named: "ok")
            }
        }
        else
        {
            ivRight.hidden = true
            if identity == "Male" || identity == "Female" || identity == "Other" || identity == "1" || identity == "2" || identity == "3"// 1 = Email, 2 = Notifications, 3 = SMS
            {
                ivRight.hidden = false
                ivRight.image = UIImage(named: "Uncheck")
            }
        }
        
        if type == 4 || type == 3{
            ivRight.hidden = false
            if isSelectedValue
            {
                ivRight.image = UIImage(named: "ok")
            }
            else
            {
                ivRight.image = UIImage(named: "Uncheck")
            }
        }
        
        if type == 3 {
                self.lblDetail.font = Utility.setDetailFont()
            
            let infoImage = UIImage(named: "info_gray")
            btnArrow.setImage(infoImage, forState: .Normal)
            btnArrow.hidden = false
        }
        
        if type ==  4{
            
            self.lblDetail.font = Utility.setDetailFont()
            
        }

        
        if type == 5{
            self.lblDetail.textColor = UIColor.blackColor()
        }else{
        }
        
       
        
        
        if self.identity == "UpdatedUsername"{
            let Contact = UIImage(named: "Contact")
            ivRight.image = Contact
            ivRight.hidden = false
        }else if self.identity == "Password"{
            let Password = UIImage(named: "Password")
            ivRight.image = Password
            ivRight.hidden = false
        }else if self.identity == "ProfessionalDetails"{
            let EditDetails = UIImage(named: "EditDetails")
            ivRight.image = EditDetails
            ivRight.hidden = false
        }else if self.identity == "SignOut"{
            let SignOut = UIImage(named: "SignOut")
            ivRight.image = SignOut
            ivRight.hidden = false
        }

        
        if levelString == Level.Single.rawValue{
            ivUpperCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = false
        }else if levelString == Level.Top.rawValue{
            ivUpperCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = true
        }else if levelString == Level.Middle.rawValue{
            ivUpperCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = true
        }else{
            ivUpperCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = false
        }
    }    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
