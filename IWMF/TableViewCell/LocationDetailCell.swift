//
//  LocationDetailCell.swift
//  IWMF
//
//
//
//

import UIKit

class LocationDetailCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblTitle.font = Utility.setFont()
        self.lblSubTitle.font = Utility.setDetailFont()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }    
}
