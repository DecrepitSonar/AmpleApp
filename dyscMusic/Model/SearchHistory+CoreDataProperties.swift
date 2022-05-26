//
//  SearchHistory+CoreDataProperties.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-08.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var audioURL: String?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var posterImageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var videoURL: String?

}

extension SearchHistory : Identifiable {

}
