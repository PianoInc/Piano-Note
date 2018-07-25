//
//  NSManagedObjectContext_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    internal func saveIfNeeded() {
        guard hasChanges else { return }
        do {
            print("변경사항 있으니 저장한다잉")
            try save()
        } catch {
            print("saveIfNeeded에러: \(error.localizedDescription)")
        }
    }
    
    internal func cacheName(folder: Folder) -> String {
        return String(describing: folder.name) + String(describing: folder.createdDate)
    }
    
    internal func cacheName(note: Note) -> String {
        return String(describing: note.createdDate) + String(describing: note.title)
    }
    
    internal func deleteCache(folder: Folder) {
        NSFetchedResultsController<Note>.deleteCache(withName: cacheName(folder: folder))
    }
    
    internal func deleteCache(note: Note) {
        NSFetchedResultsController<Block>.deleteCache(withName: cacheName(note: note))
    }
    
    internal func folderResultsController() -> NSFetchedResultsController<Folder> {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(Folder.typeInteger), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(Folder.order), ascending: true)
        request.sortDescriptors = [sort1, sort2]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: #keyPath(Folder.typeInteger), cacheName: "Folder")
    }
    
    internal func noteResultsController(folder: Folder) -> NSFetchedResultsController<Note> {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(Note.typeInteger), ascending: false)
        let sort2: NSSortDescriptor
        switch folder.sortType {
        case .modified:
            sort2 = NSSortDescriptor(key: #keyPath(Note.modifiedDate), ascending: false)
        case .created:
            sort2 = NSSortDescriptor(key: #keyPath(Note.createdDate), ascending: false)
        case .name:
            sort2 = NSSortDescriptor(key: #keyPath(Note.title), ascending: true)
        }
        request.sortDescriptors = [sort1, sort2]
        request.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: #keyPath(Note.typeInteger), cacheName: cacheName(folder: folder))
    }
    
    internal func blockResultsController(note: Note) -> NSFetchedResultsController<Block> {
        let request: NSFetchRequest<Block> = Block.fetchRequest()
        request.fetchBatchSize = 20
        let predicate = NSPredicate(format: "note = %@", note)
        let sort1 = NSSortDescriptor(key: #keyPath(Block.order), ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [sort1]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: nil, cacheName: cacheName(note: note))
    }
    
    internal func perform<T>(resultsController: NSFetchedResultsController<T>, tableVC: TableViewController & NSFetchedResultsControllerDelegate) {
        resultsController.delegate = tableVC
        
        DispatchQueue.main.async {
            do {
                try resultsController.performFetch()
            } catch {
                print("NoteResultsController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            tableVC.tableView.reloadData()
        }
    }
    
    internal func fetchImageBlock(id: String) -> ImageBlock? {
        //TODO: 코어데이터의 image를 리사이즈해서 메모리에 올리는 법 공부해서 적용시키기
        let request: NSFetchRequest<ImageBlock> = ImageBlock.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            return try self.fetch(request).first
        } catch {
            print("fetchImageBlock에러: \(error.localizedDescription)")
        }
        return nil
    }
    
}
