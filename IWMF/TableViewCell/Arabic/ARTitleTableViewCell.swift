//
//  ARTitleTableViewCell.swift
//  IWMF
//
//
//
//

import UIKit
enum Level2 : String{
    case Single = "Single"
    case Top = "Top"
    case Middle = "Middle"
    case Bottom = "Bottom"
}

class ARTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivBelowLine: UIImageView!
    @IBOutlet weak var ivTopCutLine: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    typealias level = Level2!
    var levelString : NSString = ""
    var type : Int = 0
    @IBOutlet weak var btnArrow: UIButton!
    @IBAction func btnArrowClicked(sender: AnyObject) {
    }
    func intialize()
    {
        self.lblTitle.font = Utility.setFont()
        self.lblDetail.font = Utility.setDetailFont()
        
        if type == 2
        {
            btnArrow.hidden = false
        }
        else
        {
            btnArrow.hidden = true
        }
        
        if lblTitle.text == NSLocalizedString(Utility.getKey("All_Circle"),comment:"")
        {
            lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (lblTitle?.font.pointSize)!)
        }
        if lblTitle.text == NSLocalizedString(Utility.getKey("All_Contacts"),comment:"")
        {
            lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (lblTitle?.font.pointSize)!)
        }
        
        if levelString == Level.Single.rawValue{
            ivTopCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = false
        }else if levelString == Level.Top.rawValue{
            ivTopCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = true
        }else if levelString == Level.Middle.rawValue{
            ivTopCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = true
        }else{
            ivTopCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = false
        }
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
