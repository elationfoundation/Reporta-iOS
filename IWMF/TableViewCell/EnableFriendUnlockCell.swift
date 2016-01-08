//
//  EnableFriendUnlockCell.swift
//  IWMF
//
//
//
//

import UIKit

class EnableFriendUnlockCell: UITableViewCell {
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var btnInvite: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblContactName.font =  Utility.setFont()
        self.btnInvite.titleLabel!.font = Utility.setDetailFont()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
}
