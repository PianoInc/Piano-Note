//
//  FolderTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 12..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class FolderTableViewCell: UITableViewCell, TableDataAcceptable {

    var data: TableDatable? {
        didSet {
            guard let folder = self.data as? Folder else { return }
            
            switch folder.folderType {
            case .all:
                imageView?.image = #imageLiteral(resourceName: "total")
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            case .custom:
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                imageView?.image = nil
            case .locked:
                imageView?.image = #imageLiteral(resourceName: "lock")
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            case .deleted:
                imageView?.image = #imageLiteral(resourceName: "delete")
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
            
            textLabel?.text = folder.name
            detailTextLabel?.text = "\(folder.noteCollection?.count ?? 0)"
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            delegate.persistentContainer.performBackgroundTask { (context) in
                if folder.folderType == .all {
                    let request: NSFetchRequest<Note> = Note.fetchRequest()
                    request.predicate = NSPredicate(format: "folder.typeInteger < 2")
                    request.resultType = .countResultType
                    do {
                        let count = try context.count(for: request)
                        DispatchQueue.main.async { [weak self] in
                            self?.detailTextLabel?.text = "\(count)"
                        }
                        
                    } catch {
                        print(print("모든 폴더 갯수 만들다 에러: \(error.localizedDescription)"))
                    }
                }
            }
            
            
            
            
        }
    }
}
