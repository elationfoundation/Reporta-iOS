//
//  MediaCell.swift
//  IWMF
//
//
//
//


import UIKit

class MediaCell: UITableViewCell {

    @IBOutlet weak var mediaiconLeft: UIImageView!
    @IBOutlet weak var mediaiconRight: UIImageView!
    @IBOutlet weak var lbltilewithdate: UILabel!
    @IBOutlet weak var lblhours: UILabel!
    @IBOutlet weak var lbldetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
    func setValues( media: String!, imageType : MediaType){
        
        
        if Structures.Constant.appDelegate.isArabic == true
        {
            mediaiconRight.hidden = false
            mediaiconLeft.hidden = true
            lbltilewithdate.textAlignment = NSTextAlignment.Right
            lblhours.textAlignment = NSTextAlignment.Right
            lbldetails.textAlignment = NSTextAlignment.Right
        }
        else
        {
            mediaiconRight.hidden = true
            mediaiconLeft.hidden = false
            lbltilewithdate.textAlignment = NSTextAlignment.Left
            lblhours.textAlignment = NSTextAlignment.Left
            lbldetails.textAlignment = NSTextAlignment.Left
        }

        self.lbltilewithdate.font = Utility.setFont()
        self.lbldetails.font = Utility.setFont()
        self.lblhours.font = Utility.setFont()

           
        lblhours.text=NSLocalizedString(Utility.getKey("retry_within_7_days"),comment:"")
        lbldetails.text = NSLocalizedString(Utility.getKey("Slide to resend or delete"),comment:"")
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: media, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(18)])
        let length = media.characters.count
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSRange(location:11,length:length-11))
        self.lbltilewithdate.attributedText = myMutableString
        if(imageType == .Image)
        {
            self.mediaiconLeft.image = UIImage(named: "pic")
            self.mediaiconRight.image = UIImage(named: "pic")
        }
        if(imageType == .Video)
        {
            self.mediaiconLeft.image = UIImage(named: "media-file")
            self.mediaiconRight.image = UIImage(named: "media-file")
        }
        if(imageType == .Audio){
            self.mediaiconLeft.image = UIImage(named: "media-file")
            self.mediaiconRight.image = UIImage(named: "media-file")
        }
    }
}
