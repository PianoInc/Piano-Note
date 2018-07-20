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
