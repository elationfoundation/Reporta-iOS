//
//  BuildThisCircleCell.swift
//  IWMF
//
//
//
//

import UIKit

class BuildThisCircleCell: UITableViewCell {

    @IBOutlet weak var btnBuildThisCircle: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblText: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code        
        btnBuildThisCircle.layer.borderWidth = 1.0
        btnBuildThisCircle.layer.borderColor = UIColor.orangeColor().CGColor
        btnBuildThisCircle.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
      
        
        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.borderColor = UIColor.orangeColor().CGColor
        btnCancel.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)


    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
