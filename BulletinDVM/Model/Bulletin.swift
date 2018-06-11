//
//  Bulletin.swift
//  BulletinDVM
//
//  Created by Adam on 11/06/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import Foundation
import CloudKit

class Bulletin {
    let timestamp: Date
    let message: String
    let cloudKitID: CKRecordID
    
    // String Litrals
    
    init(timestamp: Date = Date(), message: String, cloudKitID: CKRecordID = CKRecordID(recordName: UUID.init().uuidString)) {
        self.timestamp = timestamp
        self.message = message
        self.cloudKitID = cloudKitID
    }
    
    // BALANCING ACT - Keeping your records and MO's glued: Part 1: MO
    init?(ckRecord: CKRecord) {
        guard let timestamp = ckRecord[Constants.timestampKey] as? Date,
            let message = ckRecord[Constants.messageKey] as? String else { return nil }
        self.timestamp = timestamp
        self.message = message
        self.cloudKitID = ckRecord.recordID // RELATED BY ID
    }
}

extension CKRecord {
    // BALANCING ACT - Keeping your records and MO's glued: Part 2: CKRecord
    convenience init(bulletin: Bulletin) {
        self.init(recordType: Constants.bulletinKey, recordID: bulletin.cloudKitID) //RELATED BY ID
        self.setValue(bulletin.timestamp, forKey: Constants.timestampKey)
        self.setValue(bulletin.message, forKey: Constants.messageKey)
    }
}
