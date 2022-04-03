//
//  CoreDataManager.swift
//  SwiftExample
//
//  Created by Matthew Wilshire on 03/04/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        // Model is the name of the .xcdatamodel file.
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
    }
    
    func createSong() {
          
        let managedContext = persistentContainer.viewContext
        
        let song = Music(context: managedContext)
        song.name = "First Class"
        song.artist = "Jack Harlow"
        song.image = Data()
        
        do {
            try managedContext.save()
            print("Saved song")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchSongs() -> [Music] {
        var songs: [Music] = []
        
        let managedContext = persistentContainer.viewContext
          
        let fetchRequest = Music.fetchRequest()
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
          
        do {
            songs = try managedContext.fetch(fetchRequest)
            return songs
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func wipeSongs() {
        var songs: [Music] = []
          
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = Music.fetchRequest()
          
        do {
            songs = try managedContext.fetch(fetchRequest)
              
            for song in songs {
                managedContext.delete(song)
            }
            try managedContext.save()
            print("Deleted Songs")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
