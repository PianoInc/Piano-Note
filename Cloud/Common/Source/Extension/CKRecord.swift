//
//  CKRecord.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 9..
//

import CoreData

public extension CKRecord {
    
    /// CKRecord의 metadata.
    public var metadata: Data {
        let data = NSMutableData()
        let coder = NSKeyedArchiver(forWritingWith: data)
        coder.requiresSecureCoding = true
        encodeSystemFields(with: coder)
        coder.finishEncoding()
        return Data(referencing: data)
    }
    
    internal func syncMetaData(using container: NSPersistentContainer) {
        guard recordType != SHARE_RECORD_TYPE else {return}
        let fetchContext = container.fetchBackgroundContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: recordType)
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "\(KEY_RECORD_NAME) == %@", recordID.recordName)
        if let object = try? fetchContext.fetch(request).first as? NSManagedObject, let strongObject = object {
            strongObject.setValue(metadata, forKey: KEY_RECORD_DATA)
        }
        fetchContext.perform {
            if fetchContext.hasChanges {try? fetchContext.save()}
        }
    }
    
}
