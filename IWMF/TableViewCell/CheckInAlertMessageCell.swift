//
//  CheckInAlertMessageCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

protocol CheckInAlertMessageProtocol{
    func alertTextViewStartEditing(textView : UITextView, tableViewCell : CheckInAlertMessageCell)
    func alertTextViewEndEditing(textView : UITextView, tableViewCell : CheckInAlertMessageCell)
}

class CheckInAlertMessageCell: UITableViewCell {    
    var delegate : CheckInAlertMessageProtocol!    
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
        delegate?.alertTextViewStartEditing(textView, tableViewCell:self)
        return true
    }    
    func textViewShouldEndEditing(textView: UITextView){
        delegate?.alertTextViewEndEditing(textView, tableViewCell:self)
    }    
}