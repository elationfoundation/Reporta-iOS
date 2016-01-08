//
//  ARLocationListingCell.swift
//  IWMF
//
//
//
//
import UIKit

class ARLocationListingCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    var title : String! = ""
    var value : NSString! = ""
    var detail : String! = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func intialize()
    {
        self.lblTitle.font = Utility.setFont()
        self.lblDetail.font = Utility.setDetailFont()
        if value != nil {
            if  value.length > 0 {
                self.lblTitle.text = value as String
            } else {
                self.lblTitle.text = title
            }
        } else {
            self.lblTitle.text = title
        }
        self.lblDetail.text = detail
    }
}