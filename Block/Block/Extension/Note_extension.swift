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
        case pin = 0
        case shared = 1
        case normal = 2
    }
    
    var type: NoteType {
        get {
            return NoteType(rawValue: typeInteger) ?? NoteType.normal
        } set {
            typeInteger = type.rawValue
        }
    }
    
    var isInTrash: Bool {
        return (self.folder?.folderType ?? .all) == .deleted
    }
    
    func didSelectItem(fromVC viewController: ViewController) {
        viewController.performSegue(withIdentifier: "BlockTableViewController", sender: self)
        
    }
}
