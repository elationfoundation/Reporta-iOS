//
//  HelpTextViewCell.swift
//  IWMF
//
//
//
//

import UIKit

class HelpTextViewCell: UITableViewCell {
   
     @IBOutlet weak var txtHelpTextView: UILabel!
    @IBOutlet weak var txtHelpTextViewBorder: UILabel!
    @IBOutlet weak var btnSeeTermsofUSe: UIButton!

     override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        btnSeeTermsofUSe.setTitle(NSLocalizedString(Utility.getKey("see_terms_of_use"),comment:""), forState: UIControlState.Normal)
        txtHelpTextView.font = Utility.setFont()
        txtHelpTextView.sizeToFit()
        btnSeeTermsofUSe.hidden = true
        txtHelpTextViewBorder.layer.cornerRadius = 4
        txtHelpTextViewBorder.layer.borderWidth = 0.3
        txtHelpTextViewBorder.layer.borderColor = UIColor.blackColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
}
