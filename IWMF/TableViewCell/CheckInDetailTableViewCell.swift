//
//  CheckInLocationTableViewCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

class CheckInDetailTableViewCell: UITableViewCell, UITextViewDelegate {    
    @IBOutlet weak var textView: UITextView!
    var identity : String! = ""
    var value : NSString! = ""
    var title : String! = ""    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }    
    func intialize()
    {
        
        textView.selectable = false
        if value != nil{
            if  value.length > 0{
                self.textView.text = value as String
                self.textView.textColor = UIColor.blackColor()
            }else{
                self.textView.text = title
                self.textView.textColor = UIColor.lightGrayColor()
            }
        }else{
            self.textView.text = title
            self.textView.textColor = UIColor.lightGrayColor()
        }
        self.textView.font = Utility.setFont()
    }
    func textViewDidBeginEditing(textView: UITextView)
    {
        
    }
    func textViewDidEndEditing(textView: UITextView)
    {
        
    }
}