//
//  CloudManager.swift
//  SwiftExample
//
//  Created by Matthew Wilshire on 03/04/2022.
//

import Foundation
import CloudKit

class CloudManager {
    /*
        Make sure you are logged into iCloud before running these methods
     */
    var container: CKContainer!
    
    init(identifier: String) {
        container = CKContainer(identifier: identifier)
    }
    
    func addRecord() {
        let recId = CKRecord.ID(recordName: "2020-09-10")
        let record = CKRecord(recordType: "Test", recordID: recId)

        record.setValuesForKeys([
            "title" : "BUTTERFLY EFFECT",
            "artist" : "Travis Scott"
        ])

        let database = container.publicCloudDatabase
        
        database.save(record) { record, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Saved iCloud Record Successfully")
        }
    }
    
    func addPage() {
        let recId = CKRecord.ID(recordName: "Page-05-09-2000")
        let record = CKRecord(recordType: "Page", recordID: recId)

        let pageData = CKAsset(fileURL: URL(string: "05-09-2000.data")!)

        record.setValuesForKeys([
            "data" : pageData
        ])

        let database = container.privateCloudDatabase

        database.save(record) { record, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Saved Successfully")
            //print(record)

            do {
                try FileManager.default.removeItem(at: pageData.fileURL!)
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
        }
    }
    
    func fetchTestRecords() {
        let database = container.publicCloudDatabase
        let query = CKQuery(recordType: "Test", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { records, error in
            records?.forEach({record in
                print(record)
            })
        }
    }
    
    func fetchAllPages() {
        let database = container.privateCloudDatabase
        let query = CKQuery(recordType: "Page", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { records, error in
            records?.forEach({record in
                print(record.recordID)
            })
        }
    }
    
    
    func updateRecord() {
        let recId = CKRecord.ID(recordName: "2020-09-07")
        let database = container.publicCloudDatabase
        
        //To edit a record you must first fetch it then change the contents and then save it as then it
        // will know the ch tag and creator id and other hidden fields
        database.fetch(withRecordID: recId) { record, error in

            // Must fetch the record before updating it because of the CH TYPE and other values when updating.
            print("Fetching something from database")
            if let record = record {
                print(record)

                record.setValue("LOST SOULS V2", forKey: "title")
                database.save(record) { record, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("Saved Successfully")
                    print(record!)
                }

            }
        }
    }
    
    func deleteRecord() {
        let recId = CKRecord.ID(recordName: "2020-09-07")
        let database = container.publicCloudDatabase
        database.delete(withRecordID: recId) { rec, error in
            print("Deleted")
        }
    }
    
    func fetchRecordsByUserid() {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        // Get userid to container then use it to fetch the records we inserted
        container.fetchUserRecordID { (userID, erro) -> Void in
            if let userID = userID {
                let predicate = NSPredicate(format: "creatorUserRecordID == %@", userID)
                let reference = CKQuery(recordType: "Test", predicate: predicate)
                database.perform(reference, inZoneWith: nil) { records, error in
                    //make sure to make createdUserRecordName queryable in Indexes on cloudkit console.
                    //print(error)
                    for record in records! {
                        print(record.recordID.recordName)
                    }

                }
            }

        }
    }
}
