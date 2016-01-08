//
//  CheckInFooterTableViewCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

protocol CheckInFooterButtonsProtocol{
    func startNowButtonPressed()
    func startLaterButtonPressed()
}
class CheckInFooterTableViewCell: UITableViewCell {    
    var delegate : CheckInFooterButtonsProtocol!
        @IBOutlet weak var btnStartNow: UIButton!
    @IBAction func btnStartNowClicked(sender: AnyObject) {
        delegate?.startNowButtonPressed()
    }    
    @IBOutlet weak var btnStartLater: UIButton!
    @IBAction func btnStartLaterClicked(sender: AnyObject) {
        delegate?.startLaterButtonPressed()
    }    
    override func awakeFromNib() {
        btnStartNow.setTitle(NSLocalizedString(Utility.getKey("start_now"),comment:""), forState: .Normal)
        btnStartLater.setTitle(NSLocalizedString(Utility.getKey("start_later"),comment:""), forState: .Normal)
       
        self.btnStartNow.titleLabel?.font = Utility.setFont()
        self.btnStartLater.titleLabel?.font = Utility.setFont()

        Utility.setBorderToView(btnStartLater, color:UIColor.darkGrayColor() , radius: 4, width: 0.5)
        Utility.setBorderToView(btnStartNow, color:UIColor.blackColor() , radius: 4, width: 0.5)
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
