//
//  Circle.swift
//  IWMF
//
//  This class is used for Store circle detail.
//
//

import Foundation

enum CircleType: Int {
    case Private = 1
    case Public = 2
    case Social = 3
}

class Circle: NSObject {
    var circleName: String!
    var circleType: CircleType!
    var contactsList: NSMutableArray!
    override init() {
        circleName = ""
        circleType = .Private
        contactsList = NSMutableArray()
        super.init()
    }
    init(name:String, type:CircleType, contactList:NSMutableArray ){
        self.circleName = name;
        circleType = type;
        contactsList = contactList
        super.init()
    }
    required init(coder aDecoder: NSCoder)
    {
        
        self.circleName  = aDecoder.decodeObjectForKey("circleName") as! String
        self.contactsList  = aDecoder.decodeObjectForKey("contactsList") as! NSMutableArray
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
        if let circleName = self.circleName{
            aCoder.encodeObject(circleName, forKey: "circleName")
        }
        if let contactsList = self.contactsList{
            aCoder.encodeObject(contactsList, forKey: "contactsList")
        }
        
        let circleTypeValue = NSNumber(integer: self.circleType.rawValue)
        aCoder.encodeObject(circleTypeValue, forKey: "circleType")
        
    }
    func insertContactsListInCircle(conList: ContactList){
        self.contactsList.addObject(conList)
    }
}