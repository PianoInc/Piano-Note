//
//  NSPersistentContainer.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 4..
//

import CoreData

internal extension NSPersistentContainer {
    
    internal var fetchBackgroundContext: NSManagedObjectContext {
        let backgroundContext = newBackgroundContext()
        backgroundContext.name = FETCH_CONTEXT
        return backgroundContext
    }
    
}
