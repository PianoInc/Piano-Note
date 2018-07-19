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
    
    func cacheName(folder: Folder) -> String {
        return String(describing: folder.name) + String(describing: folder.createdDate)
    }
    
    func cacheName(note: Note) -> String {
        return String(describing: note.createdDate) + String(describing: note.title)
    }
    
    func deleteCache(folder: Folder) {
        NSFetchedResultsController<Note>.deleteCache(withName: cacheName(folder: folder))
    }
    
    func deleteCache(note: Note) {
        NSFetchedResultsController<Block>.deleteCache(withName: cacheName(note: note))
    }
    
    func folderResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController<Folder> {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(Folder.typeInteger), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(Folder.order), ascending: true)
        request.sortDescriptors = [sort1, sort2]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Folder.typeInteger), cacheName: "Folder")
    }
    
    func noteResultsController(context: NSManagedObjectContext, with folder: Folder) -> NSFetchedResultsController<Note> {
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
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Note.typeInteger), cacheName: cacheName(folder: folder))
    }
        
    
    func blockResultsController(context: NSManagedObjectContext, with note: Note) -> NSFetchedResultsController<Block> {
        let request: NSFetchRequest<Block> = Block.fetchRequest()
        request.fetchBatchSize = 20
        let predicate = NSPredicate(format: "note = %@", note)
        let sort1 = NSSortDescriptor(key: #keyPath(Block.order), ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [sort1]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: cacheName(note: note))
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
                let note1 = Note(context: viewContext)
                note1.folder = allFolder
                note1.title = "선택받은 메모"
                note1.modifiedDate = Date()
                
                
                for i in 0...100000 {
                    let Block1 = Block(context: viewContext)
                    Block1.order = Double(i)
                    Block1.type = .plainText
                    Block1.note = note1
                    
                    let plainTextBlock1 = PlainTextBlock(context: viewContext)
                    plainTextBlock1.text = "\(i)번째 state는 단순히 뷰의 상태를 바꾸기 위한 값으로만 쓰여야 한다. 즉 didSet을 무조건 써야 하고, 이게 불가능한 상황(viewLoad같은 곳에서 state를 참조해서 뷰를 변화시키는 행위)이 있다하면 state를 쓰지 않는다."
                    plainTextBlock1.addToBlockCollection(Block1)
                }
                
                for i in 1...1000 {
                    let note2 = Note(context: viewContext)
                    note2.folder = allFolder
                    note2.modifiedDate = Date(timeIntervalSinceNow: -60 * Double(i))
                    note2.title = "\(i)번째 메모"
                }
                
                
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
            print("fetchFolder(type: Folder.FolderType)에서 오류: \(error.localizedDescription)")
        }
        
        let allFolder = Folder(context: viewContext)
        allFolder.name = "All Note"
        allFolder.typeInteger = 0
        return allFolder
    }
    
}
