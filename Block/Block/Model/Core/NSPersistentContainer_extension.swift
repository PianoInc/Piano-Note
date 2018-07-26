//
//  Database.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    
    internal func createFolderIfNeeded() {
        do {
            let request: NSFetchRequest<Folder> = Folder.fetchRequest()
            let count = try viewContext.count(for: request)
            
            if count == 0 {
                let allFolder = Folder(context: viewContext)
                allFolder.name = "All Note"
                allFolder.typeInteger = 0
                
                let lockedFolder = Folder(context: viewContext)
                lockedFolder.name = "Locked"
                lockedFolder.typeInteger = 2
                
                let deletedFolder = Folder(context: viewContext)
                deletedFolder.name = "Recently Deleted"
                deletedFolder.typeInteger = 3
                
                guard viewContext.hasChanges else { return }
                try viewContext.save()
                
            }
        } catch {
            print("createFolderIfNeeded")
        }
    }
    
    internal func fetchFolder(type: Folder.FolderType) -> Folder {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.predicate = NSPredicate(format: "typeInteger == %d", type.rawValue)
        request.fetchLimit = 1
        do {
            return try viewContext.fetch(request).first!
        } catch {
            fatalError("fetchFolder(type: Folder.FolderType)에서 오류: \(error.localizedDescription)")
        }
    }
    
    internal func fetchFolders(type: Folder.FolderType) -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.predicate = NSPredicate(format: "typeInteger == %lld", type.rawValue)
        let sort = NSSortDescriptor(key: #keyPath(Folder.typeInteger), ascending: true)
        request.sortDescriptors = [sort]
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("fetchFolder(type: Folder.FolderType)에서 오류: \(error.localizedDescription)")
        }
    }
    
}
