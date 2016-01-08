//
//  TitleTableViewCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

class SignOutTableViewCell: UITableViewCell {    
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivBelowLine: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!    
    override func awakeFromNib() {
        self.lblTitle.font = Utility.setFont()
    }    
}
