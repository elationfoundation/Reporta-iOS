//
//  ContactListCell.swift
//  IWMF
//
//
//
//

import UIKit

class ContactListCell: UITableViewCell {

      @IBOutlet var lblTitle : UILabel!    
    override func awakeFromNib() {
        super.awakeFromNib()
        
            self.lblTitle.font = Utility.setFont()
       

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
