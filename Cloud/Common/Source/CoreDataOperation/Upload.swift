//
//  Upload.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 13..
//  Copyright © 2018년 piano. All rights reserved.
//

import CoreData

public class Upload: Uploadable, ErrorHandleable {
    
    internal var container: Container
    internal var recordsToSave = [RecordCache]()
    internal var recordIDsToDelete = [RecordCache]()
    internal var errorBlock: ((Error?) -> ())?
    
    internal init(with container: Container) {
        self.container = container
    }
    
    /**
     CoreData의 context에 cache되어 있는 insert, update, delete될 object들을 cloud에 올릴 record로써 준비시킨다.
     - Parameter insertedObjects: -
     - Parameter updatedObjects: -
     - Parameter deletedObjects: -
     */
    public func cache(_ insertedObjects: Set<NSManagedObject> = Set<NSManagedObject>(), _ updatedObjects: Set<NSManagedObject> = Set<NSManagedObject>(), _ deletedObjects: Set<NSManagedObject> = Set<NSManagedObject>()) {
        self.cache(insertedObjects, updatedObjects, deletedObjects)
    }
    
    /// Cloud에 upload를 진행한다.
    public func upload() {
        self.upload()
        errorBlock = {self.errorHandle(upload: $0)}
    }
    
}
