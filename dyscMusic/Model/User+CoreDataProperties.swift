//
//  User+CoreDataProperties.swift
//  dyscMusic
//
//  Created by bajo on 2022-02-12.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?
    @NSManaged public var joinDate: String?

}

extension User : Identifiable {

}
