//
//  TitleTableViewCell2.swift
//  IWMF
//
//
//
//

import UIKit
enum Level1 : String{
    case Single = "Single"
    case Top = "Top"
    case Middle = "Middle"
    case Bottom = "Bottom"
}

class TitleTableViewCell2: UITableViewCell {
    @IBOutlet weak var ivUpperLine: UIImageView!
    @IBOutlet weak var ivBelowLine: UIImageView!
    @IBOutlet weak var ivTopCutLine: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    typealias level = Level1!
    var levelString : NSString = ""
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    func intialize()
    {
        self.lblTitle.font = Utility.setFont()
        if lblTitle.text == NSLocalizedString(Utility.getKey("All_Circle"),comment:"")
        {
            lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (lblTitle?.font.pointSize)!)
        }
        if lblTitle.text == NSLocalizedString(Utility.getKey("All_Contacts"),comment:"")
        {
            lblTitle.font = UIFont(name: Structures.Constant.Roboto_BoldCondensed, size: (lblTitle?.font.pointSize)!)
        }
        
        if levelString == Level1.Single.rawValue{
            ivTopCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = false
        }else if levelString == Level1.Top.rawValue{
            ivTopCutLine.hidden = true
            ivUpperLine.hidden = false
            ivBelowLine.hidden = true
        }else if levelString == Level1.Middle.rawValue{
            ivTopCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = true
        }else{
            ivTopCutLine.hidden = false
            ivUpperLine.hidden = true
            ivBelowLine.hidden = false
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
