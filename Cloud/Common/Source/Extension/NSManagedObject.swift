//
//  NSManagedObjectContext.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 4..
//

import CoreData

public extension NSManagedObject {
    
    /// "recordData"로 생성한 CKRecord.
    public var record: CKRecord? {
        guard let metaData = value(forKey: KEY_RECORD_DATA) as? Data else {return nil}
        let coder = NSKeyedUnarchiver(forReadingWith: metaData)
        coder.requiresSecureCoding = true
        let record = CKRecord(coder: coder)
        coder.finishDecoding()
        return record
    }
    
}
