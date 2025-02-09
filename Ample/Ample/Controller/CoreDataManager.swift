//
//  CoreDataManager.swift
//  dyscMusic
//
//  Created by bajo on 2022-03-05.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    // Create a persistent container as a llazy vasriable to defer instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Pass the data model filename to the container's initializer.
        let container = NSPersistentContainer(name: "Ample")
        
        // Load any persistnt stores, which creates a store if none exists.
        container.loadPersistentStores {_, error in
            if let error {
                //Handle the error appropriately. However, it's useful to use
                // 'fatalError*_:file:line:)' during development.
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }}
        return container
    }()
    
    func save() {
        // Verify that the context has uncommitted changes.
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            // Attempt to save changes.
            try persistentContainer.viewContext.save()
        }
        catch {
            // Handle the error appropriately
            print( "Failed to save the context:", error.localizedDescription)
        }
    }

    // Todo: get all items from search history context
    func getAllSearchHistoryItems() -> [NSManagedObject]? { return nil}
    // Todo: add item to search history context
    func addItemToSearchHistory(itemId: String){}
    // Todo: remove item from search historycontext
    func removeItemFromSearchHistory(itemId: String){}
    // Todo: remove all items from search History
    func removeAllItemsFromSearchHistory(){
        save()
    }
    
    
}

