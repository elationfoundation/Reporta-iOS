//
//  NewDetailTableViewCell.swift
//  CustomIOS7AlertView
//
//
//
//

import UIKit

class NewDetailTableViewCell: UITableViewCell
{
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivUpperCutLine: UIImageView!
    @IBOutlet weak var ivBelowLine: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var ivRight: UIImageView!
    typealias level = Level!
    var levelString : NSString = ""
    var isSelectedValue : Bool = false
    var type : Int = 0
    var identity : String = ""
    func intialize(){
        
        self.lblDetail.font = Utility.setFont()
        
        if isSelectedValue && type == 1
        {
            ivRight.hidden = false
        }
        else
        {
            ivRight.hidden = true
        }
        
        if type == 3
        {
            self.lblDetail.font = Utility.setDetailFont()
        }
        
        if type ==  4
        {
            self.lblDetail.font = Utility.setDetailFont()
        }
        
        if type == 5
        {
            self.lblDetail.textColor = UIColor.blackColor()
        }
        else
        {
        }
        
        if isSelectedValue && type == 3
        {
            ivRight.hidden = false
        }
        
        if isSelectedValue && type == 4
        {
            ivRight.hidden = false
        }
        
        if self.identity == "UpdatedUsername"
        {
            let Contact = UIImage(named: "Contact")
            ivRight.image = Contact
            ivRight.hidden = false
        }
        else if self.identity == "Password"
        {
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
        }
        else
        {
            ivUpperCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
}
