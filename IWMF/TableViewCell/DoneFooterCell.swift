//
//  DoneFooterCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

protocol FooterDoneButtonProtol{
    func doneButtonPressed()
}

class DoneFooterCell: UITableViewCell {
    var delegate : FooterDoneButtonProtol!
    @IBOutlet weak var btnDone: UIButton!
    @IBAction func btnStartNowClicked(sender: AnyObject) {
        delegate?.doneButtonPressed()
    }
    override func awakeFromNib() {
        btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        self.btnDone.titleLabel?.font = Utility.setFont()
        Utility.setBorderToView(btnDone, color:UIColor.darkGrayColor() , radius: 4, width: 0.5)
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }    
    
}