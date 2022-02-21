//
//  User+CoreDataClass.swift
//  dyscMusic
//
//  Created by bajo on 2022-02-12.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
