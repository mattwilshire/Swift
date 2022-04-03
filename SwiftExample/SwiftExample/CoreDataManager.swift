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
    func createSong() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        
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
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return [Music]()
          }
        
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          let fetchRequest = NSFetchRequest<Music>(entityName: "Music")
          //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
          
          do {
              songs = try managedContext.fetch(fetchRequest)
              
              return songs
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        return [Music]()
    }
    
    func wipeSongs() {
        var songs: [Music] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext = appDelegate.persistentContainer.viewContext
        
          let fetchRequest = NSFetchRequest<Music>(entityName: "Music")
          
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
