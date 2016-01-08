//
//  Contact.swift
//  IWMF
//
//  This class is used for store detail of contact
//
//

import Foundation

enum ContactStatus: Int {
    case RequestNotSent = -1
    case RequestSent = 0
    case Accepted = 1
    case Decline = 2
}

class Contact: NSObject {
    var contactID: NSNumber!
    var contactListID: NSNumber!
    var firstName: String!
    var lastName: String!
    var name: String!
    var cellPhone: String!
    var email: String!
    var emailFriendToUnlock: String!
    var selected: String!
    var associated_circles : NSMutableArray!
    var contactStatus: ContactStatus!
    required init(coder aDecoder: NSCoder)
    {
        self.contactID  = aDecoder.decodeObjectForKey("contactID") as! NSNumber
        self.contactListID  = aDecoder.decodeObjectForKey("contactListID") as! NSNumber
        self.firstName  = aDecoder.decodeObjectForKey(Structures.User.User_FirstName) as! String
        self.lastName  = aDecoder.decodeObjectForKey("lastName") as! String
        self.name  = aDecoder.decodeObjectForKey("name") as! String
        self.cellPhone  = aDecoder.decodeObjectForKey("cellPhone") as! String
        self.email  = aDecoder.decodeObjectForKey(Structures.User.UserEmail) as! String
        self.emailFriendToUnlock  = aDecoder.decodeObjectForKey("emailFriendToUnlock") as! String
        self.selected  = aDecoder.decodeObjectForKey("selected") as! String
        self.associated_circles  = aDecoder.decodeObjectForKey("associated_circles") as! NSMutableArray
        
        let contactStatusValue = Int(aDecoder.decodeObjectForKey("contactStatus") as! NSNumber)
        if contactStatusValue == -1
        {
            self.contactStatus = ContactStatus.RequestNotSent
        }
        else  if contactStatusValue == 0
        {
            self.contactStatus = ContactStatus.RequestSent
        }
        else  if contactStatusValue == 1
        {
            self.contactStatus = ContactStatus.Accepted
        }
        else  if contactStatusValue == 2
        {
            self.contactStatus = ContactStatus.Decline
        }
        
    }
    func encodeWithCoder(aCoder: NSCoder) {
        if let contactID = self.contactID{
            aCoder.encodeObject(contactID, forKey: "contactID")
        }
        if let contactListID = self.contactListID{
            aCoder.encodeObject(contactListID, forKey: "contactListID")
        }
        if let firstName = self.firstName{
            aCoder.encodeObject(firstName, forKey: Structures.User.User_FirstName)
        }
        if let lastName = self.lastName{
            aCoder.encodeObject(lastName, forKey: "lastName")
        }
        if let name = self.name{
            aCoder.encodeObject(name, forKey: "name")
        }
        if let cellPhone = self.cellPhone{
            aCoder.encodeObject(cellPhone, forKey: "cellPhone")
        }
        if let email = self.email{
            aCoder.encodeObject(email, forKey: Structures.User.UserEmail)
        }
        if let emailFriendToUnlock = self.emailFriendToUnlock{
            aCoder.encodeObject(emailFriendToUnlock, forKey: "emailFriendToUnlock")
        }
        if let selected = self.selected{
            aCoder.encodeObject(selected, forKey: "selected")
        }
        if let associated_circles = self.associated_circles{
            aCoder.encodeObject(associated_circles, forKey: "associated_circles")
        }
        
        let contactStatusValue = NSNumber(integer: self.contactStatus.rawValue)
        aCoder.encodeObject(contactStatusValue, forKey: "contactStatus")
        
    }
    override init() {
        contactID  = NSNumber(integer: 0)
        contactListID  = NSNumber(integer: 0)
        firstName = ""
        lastName = ""
        cellPhone = ""
        email = ""
        name = ""
        emailFriendToUnlock = ""
        selected = "0"
        associated_circles = NSMutableArray()
        contactStatus = .RequestNotSent
        
        super.init()
    }
    init(id:NSNumber, conListID:NSNumber, fn:String, ln:String, cp: String, email: String, friendEmailToUnlock:String ,contactStatus:ContactStatus){
        self.contactID = id;
        self.contactListID = conListID;
        self.firstName = fn;
        self.lastName = ln;
        self.cellPhone = cp;
        self.email = email;
        self.contactStatus = contactStatus;
        self.name = fn + ln;
        self.emailFriendToUnlock = friendEmailToUnlock;
        self.selected = "0";
        self.associated_circles = [] as NSMutableArray
        super.init()
    }
}