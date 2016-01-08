//
//  AllContactCell.swift
//  IWMF
//
//
//
//

import UIKit

class AllContactCell: UITableViewCell {

    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblBottomLineShort: UILabel!
  
    @IBOutlet weak var viewNoSavedCircle: UIView!
    @IBOutlet weak var lblTopLineFull: UILabel!
    @IBOutlet weak var lblBottomLineFull: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLock: UIButton!    
    @IBOutlet weak var lblTextNoCircle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSwitch.hidden = true
        self.lblName.font = Utility.setFont()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
}
