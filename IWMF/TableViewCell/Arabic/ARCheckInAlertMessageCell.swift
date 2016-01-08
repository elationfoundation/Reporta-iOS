//
//  ARCheckInAlertMessageCell.swift
//  IWMF
//
//
//
//

import UIKit
protocol ARCheckInAlertMessageProtocol{
    func alertTextViewStartEditing1(textView : UITextView, tableViewCell : ARCheckInAlertMessageCell)
    func alertTextViewEndEditing1(textView : UITextView, tableViewCell : ARCheckInAlertMessageCell)
}
class ARCheckInAlertMessageCell: UITableViewCell {
    
    var delegate : ARCheckInAlertMessageProtocol!
    var indexPath : NSIndexPath!
    var title : String!
    var value : String!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func initializeTheLabelValues(){
        self.lblTitle.font = Utility.setFont()
        lblTitle.text = title
        textView.text = value
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        delegate?.alertTextViewStartEditing1(textView, tableViewCell:self)
        return true
    }
    func textViewShouldEndEditing(textView: UITextView){
        delegate?.alertTextViewEndEditing1(textView, tableViewCell:self)
    }
}