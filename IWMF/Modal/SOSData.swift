//
//  SOSData.swift
//  IWMF
//
//

import Foundation
import CoreData

@objc(SOSData)
class SOSData: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var sosData: NSData?
    @NSManaged var sosName: String?

}
