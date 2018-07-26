//
//  Folder_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension Folder: TableDatable {
    
    enum FolderType: Int64 {
        case all = 0
        case custom = 1
        case locked = 2
        case deleted = 3
    }
    
    var folderType: FolderType {
        get {
            return FolderType(rawValue: typeInteger) ?? FolderType.all
        } set {
            typeInteger = newValue.rawValue
        }
    }
    
    enum SortType: Int64 {
        case modified = 0
        case created = 1
        case name = 2
    }
    
    var sortType: SortType {
        get {
            return SortType(rawValue: sortTypeInteger) ?? SortType.modified
        } set {
            sortTypeInteger = sortType.rawValue
        }
    }
    
    func didSelectItem(fromVC viewController: ViewController) {
        viewController.performSegue(withIdentifier: "NoteTableViewController", sender: self)
    }
}
