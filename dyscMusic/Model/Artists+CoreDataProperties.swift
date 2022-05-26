//
//  Artists+CoreDataProperties.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-01.
//
//

import Foundation
import CoreData


extension Artists {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artists> {
        return NSFetchRequest<Artists>(entityName: "Artists")
    }

    @NSManaged public override var id: String?
    @NSManaged public var imageURL: String?
//    @NSManaged public var isVerified: String?
    @NSManaged public var name: String?

}
