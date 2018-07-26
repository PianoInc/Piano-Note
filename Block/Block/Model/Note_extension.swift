//
//  Note_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension Note: TableDatable {
    
    enum NoteType: Int64 {
        case pinned = 0
        case shared = 1
        case normal = 2
    }
    
    var type: NoteType {
        get {
            return NoteType(rawValue: typeInteger) ?? NoteType.normal
        } set {
            typeInteger = newValue.rawValue
        }
    }
    
    var isInTrash: Bool {
        return (self.folder?.folderType ?? .all) == .deleted
    }
    
    func didSelectItem(fromVC viewController: ViewController) {
        viewController.performSegue(withIdentifier: "BlockTableViewController", sender: self)
        
    }
}

extension Note {
    internal func deleteWithRelationship() {
        blockCollection?.forEach({ (item) in
            guard let block = item as? Block else { return }
            block.deleteWithRelationship()
        })
        
        self.managedObjectContext?.delete(self)
    }
}
