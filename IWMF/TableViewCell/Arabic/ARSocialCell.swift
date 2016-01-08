//
//  ARSocialCell.swift
//  IWMF
//
//
//
//

import UIKit

class ARSocialCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnMark: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ShortLine: UILabel!
    @IBOutlet weak var fullLine: UILabel!
    @IBOutlet weak var fullLineTop: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var positionX: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font = Utility.setFont()
        self.btnLogin.titleLabel!.font = Utility.setDetailFont()
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
