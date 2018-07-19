//
//  ContextSave.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 4..
//

import CoreData

/// CoreData의 persistent save를 감지해서 Cloud에 upload해주는 기능.
internal class ContextSave: Uploadable, ErrorHandleable {
    
    internal var container: Container
    internal var recordsToSave = [RecordCache]()
    internal var recordIDsToDelete = [RecordCache]()
    internal var errorBlock: ((Error?) -> ())?
    
    internal init(with container: Container) {
        self.container = container
    }
    
    /// NSManagedObjectContext의 DidSave에 대한 addObserver를 진행한다.
    internal func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willSave(_:)), name: .NSManagedObjectContextWillSave, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSave(_:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
}

internal extension ContextSave {
    
    @objc private func willSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context.name != FETCH_CONTEXT else {return}
        cache(context.insertedObjects, context.updatedObjects, context.deletedObjects)
    }
    
    @objc private func didSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context.name != FETCH_CONTEXT else {return}
        upload()
        errorBlock = {self.errorHandle(observer: $0)}
    }
    
}
