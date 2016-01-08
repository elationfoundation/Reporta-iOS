//
//  CreateNewUserTableViewCell.swift
//  IWMF
//
//
//
//
import UIKit

protocol CreateUserProtocol{
    func btnCompleteAccountCreationClicked()
    func btnCancelClicked()
}

class CreateNewUserTableViewCell: UITableViewCell {

    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var delegate : CreateUserProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnConfrimClicked(sender: AnyObject) {
        self.delegate?.btnCompleteAccountCreationClicked()
    }    
    @IBAction func btnCancelClicked(sender: AnyObject) {
        self.delegate?.btnCancelClicked()
    }
    func initialize(){
        self.btnCancel.setTitle(NSLocalizedString(Utility.getKey("Cancel"),comment:""), forState: .Normal)
        self.btnConfirm.setTitle(NSLocalizedString(Utility.getKey("accept"),comment:""), forState: .Normal)
        self.btnConfirm.titleLabel?.textColor = UIColor.orangeColor()
    }
  
}
