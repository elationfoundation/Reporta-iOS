//
//  SendAlertTableViewCell.swift
//  IWMF
//
//
//
//

import UIKit

protocol SendAlertButtonProtocol{
    func SendAlertBtnPressed()
}
class SendAlertTableViewCell: UITableViewCell {

    var delegate : SendAlertButtonProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var sendAlert: UIButton!
    
    @IBAction func sendAlertBtn(sender: AnyObject) {
        delegate?.SendAlertBtnPressed()
    }
    
    func intialize(){
        self.sendAlert.setTitle(NSLocalizedString(Utility.getKey("send_alert"),comment:""), forState: .Normal)
        self.sendAlert.titleLabel?.font = Utility.setFont()
    }
}
