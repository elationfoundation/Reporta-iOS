//
//  NextFooterTableViewCell.swift
//  IWMF
//
//
//
//

import UIKit

protocol NextButtonProtocol{
    func nextButtonClicked()
}
enum TypeOfButton : Int{
    case NextButton = 1
    case termsAndCondition = 3
    case UpdateProfile = 2
    case createUser = 4
}

class NextFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var nextBtn: UIButton!
    var delegate : NextButtonProtocol?
    var selectedType : Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func nextBtnClicked(sender: AnyObject) {
        delegate?.nextButtonClicked()
    }
    func initialize(){
        
        self.nextBtn.titleLabel?.font = Utility.setFont()

        switch selectedType{
        case TypeOfButton.NextButton.rawValue :
            self.nextBtn.setTitle(NSLocalizedString(Utility.getKey("Next"),comment:""), forState: .Normal)
            self.nextBtn.titleLabel?.textColor = UIColor.orangeColor()
        case TypeOfButton.UpdateProfile.rawValue :
            self.nextBtn.setTitle(NSLocalizedString(Utility.getKey("Update"),comment:""), forState: .Normal)
            self.nextBtn.titleLabel?.textColor = UIColor.orangeColor()
        case TypeOfButton.termsAndCondition.rawValue :
            self.nextBtn.setTitle(NSLocalizedString(Utility.getKey("Agree"),comment:""), forState: .Normal)
            self.nextBtn.titleLabel?.textColor = UIColor.orangeColor()
        case TypeOfButton.createUser.rawValue :
            self.nextBtn.setTitle(NSLocalizedString(Utility.getKey("accept"),comment:""), forState: .Normal)
            self.nextBtn.titleLabel?.textColor = UIColor.orangeColor()
        default :
            print("")
        }
    }
    
}
