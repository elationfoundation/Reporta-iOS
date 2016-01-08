//
//  ConfirmedCICell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

class ConfirmedCICell: UITableViewCell {    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!    
    var title : String! = ""
    var value : String! = ""    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
    func intialize(){
        if(CommonUnit.isIphone4()){
            self.lblTitle.font = Structures.Constant.Roboto_Regular15
              self.lblDetail.font = Structures.Constant.Roboto_Regular34
        }
        if(CommonUnit.isIphone5()){
            self.lblTitle.font = Structures.Constant.Roboto_Regular15
            self.lblDetail.font = Structures.Constant.Roboto_Regular34
        }
        if(CommonUnit.isIphone6()){
            self.lblTitle.font = Structures.Constant.Roboto_Regular16
             self.lblDetail.font = Structures.Constant.Roboto_Regular34
        }
        if(CommonUnit.isIphone6plus()){
            self.lblTitle.font = Structures.Constant.Roboto_Regular18
            self.lblDetail.font = Structures.Constant.Roboto_Regular34
        }
        self.lblDetail.text = value
        self.lblTitle.text = title
    }    
}