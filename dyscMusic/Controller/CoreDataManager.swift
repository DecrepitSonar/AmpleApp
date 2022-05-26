//
//  CoreDataManager.swift
//  dyscMusic
//
//  Created by bajo on 2022-03-05.
//

import Foundation
import CoreData
import UIKit

class DataMananager {
    
//    var managedContext: NSPersistentContainer!
    var viewContext: NSManagedObjectContext!
    enum DBError: Error {
        case Failed
        case Success
    }
    
    
    static let shared = DataMananager()
    
    init() {
        
        DispatchQueue.main.async {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                return
              }
            
            let managedContext =
                appDelegate.persistentContainer
            
            self.viewContext = managedContext.viewContext
        }
        
    }

    // Todo: get all items from search history context
    func getAllSearchHistoryItems() -> [NSManagedObject]? { return nil}
    // Todo: add item to search history context
    func addItemToSearchHistory(itemId: String){}
    // Todo: remove item from search historycontext
    func removeItemFromSearchHistory(itemId: String){}
    // Todo: remove all items from search History
    func removeAllItemsFromSearchHistory(){}
    
    
}
