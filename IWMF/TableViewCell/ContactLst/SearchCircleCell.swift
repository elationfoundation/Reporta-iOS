//
//  SearchCircleCell.swift
//  IWMF
//
//
//
//

import UIKit

class SearchCircleCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lbSep : UILabel!
    @IBOutlet var btnAddContact : UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
         self.lblTitle.font = Utility.setFont()
        if(CommonUnit.isIphone4()){
            if btnEdit.titleLabel?.text == "+"
            {
                btnEdit.titleLabel?.font = UIFont.systemFontOfSize(20)
            }
            else
            {
                 btnEdit.titleLabel?.font = UIFont.systemFontOfSize(16)
            }

        }
        if(CommonUnit.isIphone5()){
            if btnEdit.titleLabel?.text == "+"
            {
                btnEdit.titleLabel?.font = Structures.Constant.Roboto_Regular16
            }
            else
            {
                btnEdit.titleLabel?.font = Structures.Constant.Roboto_Regular16
            }
        }
        if(CommonUnit.isIphone6()){
            if btnEdit.titleLabel?.text == "+"
            {
                btnEdit.titleLabel?.font = UIFont.systemFontOfSize(22)
            }
            else
            {
                btnEdit.titleLabel?.font = UIFont.systemFontOfSize(18)
            }
        }
        if(CommonUnit.isIphone6plus()){
            if btnEdit.titleLabel?.text == "+"
            {
                btnEdit.titleLabel?.font = UIFont.systemFontOfSize(24)
            }
            else
            {
                btnEdit.titleLabel?.font = UIFont.systemFontOfSize(20)
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
