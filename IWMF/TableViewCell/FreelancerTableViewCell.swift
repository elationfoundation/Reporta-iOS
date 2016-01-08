//
//  FreelancerTableViewCell.swift
//  IWMF
//
//
//
//

import UIKit

protocol FreelancerBtProtocol{
    func freelancerButtonClicked(isSelected : NSNumber)
}

class FreelancerTableViewCell: UITableViewCell {

    @IBOutlet weak var okImage: UIImageView!
    @IBOutlet weak var freelancerBtn: UIButton!
    var delegate : FreelancerBtProtocol!
    var isSelectedValue : Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
    @IBAction func freelancerBtnClicked(sender: AnyObject) {
        
        if(isSelectedValue == true){
            isSelectedValue = false
            self.okImage.image = UIImage(named: "Uncheck")
        }else{
            isSelectedValue = true
             self.okImage.image = UIImage(named: "ok")
           
        }
        delegate?.freelancerButtonClicked(NSNumber(bool: isSelectedValue))
    }    
    func initialize(){
        freelancerBtn.setTitle(NSLocalizedString(Utility.getKey("Freelancer"),comment:""), forState: .Normal)
        self.freelancerBtn.titleLabel?.font = Utility.setFont()
        self.okImage.hidden = false
        if(isSelectedValue == true)
        {
            self.okImage.image = UIImage(named: "ok")
            
        }
        else
        {
           self.okImage.image = UIImage(named: "Uncheck")
        }

        
    }

 
}
