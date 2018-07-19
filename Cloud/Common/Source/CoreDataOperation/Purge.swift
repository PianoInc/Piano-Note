//
//  Purge.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 5..
//

import CoreData

internal class Purge {
    
    private let container: Container
    
    internal init(with container: Container) {
        self.container = container
    }
    
    internal func operate() {
        let fetchContext = container.coreData.fetchBackgroundContext
        for entity in container.coreData.managedObjectModel.entities where entity.isCloudable {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            request.includesPropertyValues = false
            guard let objects = try? fetchContext.fetch(request) as? [NSManagedObject], let strongObjects = objects else {continue}
            strongObjects.forEach {fetchContext.delete($0)}
        }
        fetchContext.perform {
            if fetchContext.hasChanges {try? fetchContext.save()}
        }
    }
    
}
