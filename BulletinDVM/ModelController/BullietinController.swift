//
//  BullietinController.swift
//  BulletinDVM
//
//  Created by Adam on 11/06/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CloudKit

class BulletinController {
    // MARK: - Properties
    static let shared = BulletinController() // Shared instance
    var bulletins = [Bulletin]() // Source of truth
    let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    // Save
    func save(bulletin: Bulletin, completion: @escaping ((_ success: Bool) -> Void)) {
        let bulletinRecord = CKRecord(bulletin: bulletin)
        database.save(bulletinRecord) { (_, error) in
            if let error = error {
                print("Error saving bulletin to cloud  \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    // Create
    func createBulletin(with message: String, completion: @escaping ((_ success: Bool) -> Void)){
        let newBulletin = Bulletin(message: message)
        save(bulletin: newBulletin) { (success) in
            if success {
                self.bulletins.append(newBulletin)
                completion(true)
            } else {
                print("Couldn't create bulletin due to unable to save to cloud")
                completion(false)
            }
        }
    }
    
    // Retrieve / Fetch
    func fetchBulletins(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Constants.bulletinKey, predicate: predicate)
        
        // Start here (at the end goal) Go up ^
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching bulletins from cloud: \(error.localizedDescription)")
                completion(false)
                return
            }
            // Unwrap records
            guard let records = records else { completion(false) ; return}
            
            // same as the method bellow
            //self.bulletins = records.compactMap { Bulletin(ckRecord: $0)}
            
            // Empty bulletinArray
            var bulletinArray: [Bulletin] = []
            // Loop through unwrapped records
            for record in records {
                guard let bulletin = Bulletin(ckRecord: record) else { continue }
                bulletinArray.append(bulletin)
            }
            // Set our source of truth to equal bulletinArray
            self.bulletins = bulletinArray
            completion(true)
        }
    }
}


















