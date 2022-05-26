//
//  Albums+CoreDataProperties.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-01.
//
//

import Foundation
import CoreData


extension Albums {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Albums> {
        return NSFetchRequest<Albums>(entityName: "Albums")
    }

    @NSManaged public override var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var title: String?

}
