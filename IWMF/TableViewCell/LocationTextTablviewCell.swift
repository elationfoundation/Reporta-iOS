//
//  LocationTextTablviewCell.swift
//  IWMF
//
//
//
//

import Foundation
import UIKit

protocol LocationTextChangeProtocol{
    func locationTextViewStartEditing(textView : UITextView)
    func locationTextViewEndEditing(textView : UITextView)
}


class LocationTextTablviewCell: UITableViewCell, UITextViewDelegate {    
    @IBOutlet weak var textView: UITextView!
    var delegate : LocationTextChangeProtocol?    
    override func awakeFromNib()
    {
        self.textView.font = Utility.setFont()
        super.awakeFromNib()
    }    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    {
        delegate?.locationTextViewStartEditing(textView)
        return true
    }    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        
        if textView.accessibilityIdentifier != nil
        {
            if textView.accessibilityIdentifier == "Affiliation"
            {
                let newLength = textView.text.characters.count + text.characters.count - range.length
                return newLength <= 100
            }
        }
        return true
    }

    func textViewDidEndEditing(textView: UITextView)
    {
        delegate?.locationTextViewEndEditing(textView)
    }    
}