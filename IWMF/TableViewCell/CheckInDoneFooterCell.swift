//
//  DoneFooterCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

protocol CheckInFooterProtocol{
    func doneButtonPressed()
    func checkInSaveChangeAlert()
    func cancelCheckInPressed()
}

class CheckInDoneFooterCell: UITableViewCell {    
    var delegate : CheckInFooterProtocol!    
    @IBOutlet weak var btnDone: UIButton!
    @IBAction func btnStartNowClicked(sender: AnyObject) {
        delegate?.doneButtonPressed()
    }    
    @IBOutlet weak var btnConfirmCheckIN: UIButton!
    @IBAction func btnConfirmCheckInClicked(sender: AnyObject) {
        delegate?.checkInSaveChangeAlert()
    }    
    @IBOutlet weak var btnCancelCheckIN: UIButton!
    @IBAction func btnCancelCheckInClicked(sender: AnyObject) {
        delegate?.cancelCheckInPressed()
    }    
    override func awakeFromNib()
    {

        self.btnDone.titleLabel?.font = Utility.setFont()
        self.btnDone.titleLabel?.font = Utility.setFont()
        self.btnCancelCheckIN.titleLabel?.font = Utility.setFont()
        
        Utility.setBorderToView(btnDone, color:UIColor.darkGrayColor() , radius: 4, width: 0.5)
        Utility.setBorderToView(btnConfirmCheckIN, color:UIColor.darkGrayColor() , radius: 4, width: 0.5)
        Utility.setBorderToView(btnCancelCheckIN, color:UIColor.darkGrayColor() , radius: 4, width: 0.5)
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }    
    
}