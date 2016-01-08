//
//  TitleTableViewCell.swift
//  IWMF
//
//
//
//
import Foundation
import UIKit

protocol SituationCellDoneProtocol{
    func doneButtonPressed()
}

class SituationTitleCell: UITableViewCell {    
    var delegate : SituationCellDoneProtocol!
    @IBOutlet weak var ivBelowLine: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!    
    @IBOutlet weak var btnDone: UIButton!    
    @IBAction func btnArrowClicked(sender: AnyObject) {
        delegate?.doneButtonPressed()
    }    
    func intialize(){
        self.lblTitle.font = Utility.setFont()
        btnDone.titleLabel?.font = Structures.Constant.Roboto_Regular18
        btnDone.setTitle(NSLocalizedString(Utility.getKey("done"),comment:""), forState: .Normal)
        ivBelowLine.hidden = false
    }    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
