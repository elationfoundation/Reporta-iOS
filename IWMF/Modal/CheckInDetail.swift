//
//  CheckInDetail.swift
//  IWMF
//
//

import Foundation
import CoreData

@objc(CheckInDetail)
class CheckInDetail: NSManagedObject {
   
    @NSManaged var checkinData: NSData?
    @NSManaged var checkinName: String?
    

// Insert code here to add functionality to your managed object subclass
}
