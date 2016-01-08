//
//  ContactList.swift
//  IWMF
//
//  This class is used for store List of contact
//
//

import Foundation

class ContactList: NSObject {
    var contactListID: NSNumber!
    var contactListName: String!
    var contactUserID: NSNumber!
    var circleType: CircleType!
    var isDefaultContactList : String!
    var contacts: [AnyObject]!
    
    required init(coder aDecoder: NSCoder)
    {
        
        self.contactListID  = aDecoder.decodeObjectForKey("contactListID") as! NSNumber
        self.contactListName  = aDecoder.decodeObjectForKey("contactListName") as! String
        self.isDefaultContactList  = aDecoder.decodeObjectForKey("isDefaultContactList") as! String
        self.contactUserID  = aDecoder.decodeObjectForKey("contactUserID") as! NSNumber
        self.contacts  = aDecoder.decodeObjectForKey(Structures.Constant.Contacts) as! [AnyObject]
        let circleTypeValue = Int(aDecoder.decodeObjectForKey("circleType") as! NSNumber)
        if circleTypeValue == 1
        {
            self.circleType = CircleType.Private
        }
        else  if circleTypeValue == 2
        {
            self.circleType = CircleType.Public
        }
        else  if circleTypeValue == 3
        {
            self.circleType = CircleType.Social
        }
        
    }
    func encodeWithCoder(aCoder: NSCoder) {
        if let contactListID = self.contactListID{
            aCoder.encodeObject(contactListID, forKey: "contactListID")
        }
        if let contactListName = self.contactListName{
            aCoder.encodeObject(contactListName, forKey: "contactListName")
        }
        if let isDefaultContactList = self.isDefaultContactList{
            aCoder.encodeObject(isDefaultContactList, forKey: "isDefaultContactList")
        }
        if let contactUserID = self.contactUserID{
            aCoder.encodeObject(contactUserID, forKey: "contactUserID")
        }
        if let contacts = self.contacts{
            aCoder.encodeObject(contacts, forKey: Structures.Constant.Contacts)
        }
        let circleTypeValue = NSNumber(integer: self.circleType.rawValue)
        aCoder.encodeObject(circleTypeValue, forKey: "circleType")
    }
    
    override init() {
        contactListID  = NSNumber(integer: 0)
        contactUserID  = NSNumber(integer: 0)
        contactListName = ""
        isDefaultContactList = "0"
        contacts = [AnyObject]()
        circleType = .Private
        super.init()
    }
    init(id:NSNumber, name:String, user:NSNumber, circleType:
        CircleType!, contacts:[AnyObject] ){
            self.contactListID = id;
            self.contactListName = name;
            self.contactUserID = user;
            self.circleType = circleType;
            self.contacts = contacts;
            isDefaultContactList = "0"
            super.init()
    }
    func insertContactInContactList(contact:AnyObject){
        self.contacts.append(contact);
    }
}