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
    
    static let shared = DataMananager()
    
    var context: NSManagedObjectContext!
    
    init() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        context = appDelegate.persistentContainer.viewContext
    }
    
    
//    let context = AppDelegate.
    // Todo: insert new user
    func createUser(user: UserData){
        
        let item = User(context: context)
        item.id = user.id
        item.username = user.username
        item.password = user.password
        item.email = user.email
        
        do{
           try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    // Todo: remove User
    func removeUser(){
        
    }
    // Todo: check if user exists / return user
    func isUserExisting() -> Bool {
        
        
        return false
    }
    
    // Todo: insert new album
    // Todo: return collection of albums
    // Todo: remove album from db
    
    // Todo: insert new track
    // Todo: return saved tracks
    // Todo: remove track from saved
    
    // Todo: insert new artist in following
    // Todo: return artists
    // Todo: remove artist
    // Todo: return artist with id
    
    // Todo: insert new playlist
    // Todo: remove playlist
    // Todo: return all playlists
    // Todo: return playlist with id
}
