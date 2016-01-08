//
//  Entity.swift
//  IWMF
//
//

import Foundation
import CoreData

@objc(UserDetail)
class UserDetail: NSManagedObject {
    @NSManaged var userData: NSData?
    @NSManaged var userName: String?
// Insert code here to add functionality to your managed object subclass

}
