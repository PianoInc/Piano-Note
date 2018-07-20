//
//  Folder_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 12..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

protocol Uniquable {
    var identifier: String { get }
}

extension Uniquable {
    //Data 뒤에 Cell을 붙이면 뷰이다. 데이터와 뷰의 관계를 명확히 하고, 스토리보드에서 쉽게 identifier를 세팅하기 위함
    var identifier: String {
        return String(describing:type(of: self)) + "TableViewCell"
    }
    
}

protocol TableDatable: Uniquable {
    func didSelectItem(fromVC viewController: ViewController)
}

protocol TableDataAcceptable {
    var data: TableDatable? { get set }
}

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
            typeInteger = folderType.rawValue
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

extension Block: TableDatable {
    
    enum BlockType: Int64 {
        case plainText
        case orderedText
        case unOrderedText
        case checklistText
        case imageCollection
        case drawing
        case file
        case separator
        case imagePicker
        case comment
    }
    
    
    var type: BlockType {
        get {
            return BlockType(rawValue: typeInteger) ?? .plainText
        } set {
            typeInteger = newValue.rawValue
        }
    }
    
    
    
    var identifier: String {
        switch self.type {
        case .plainText,
             .orderedText,
             .unOrderedText,
             .checklistText:
            return "TextBlockTableViewCell"
        case .drawing:
            return "DrawingBlockTableViewCell"
        case .file:
            return "FileBlockTableViewCell"
        case .imageCollection:
            return "ImageCollectionBlockTableViewCell"
        case .imagePicker:
            return "ImagePickerBlockTableViewCell"
        case .separator:
            return "SeparatorBlockTableViewCell"
        case .comment:
            return "CommentBlockTableViewCell"
        }
    }
    
    var isText: Bool {
        switch self.type {
        case .checklistText,
             .orderedText,
             .plainText,
             .unOrderedText:
            return true
        default:
            return false
        }
    }
    
    var text: String? {
        switch self.type {
        case .plainText:
            return plainTextBlock?.text
        case .checklistText:
            return checklistTextBlock?.text
        case .unOrderedText:
            return unOrderedTextBlock?.text
        case .orderedText:
            return orderedTextBlock?.text
        default:
            return nil
        }
    }
    
    var hasFormat: Bool {
        switch self.type {
        case .checklistText,
             .orderedText,
             .unOrderedText:
            return true
        default:
            return false
        }
    }
    
    var textStyle: FontTextStyle? {
        switch type {
        case .plainText:
            return self.plainTextBlock?.textStyle
        case .checklistText:
            return self.checklistTextBlock?.textStyle
        case .unOrderedText:
            return self.unOrderedTextBlock?.textStyle
        case .orderedText:
            return self.orderedTextBlock?.textStyle
        default:
            return nil
        }
    }
    
    
    func didSelectItem(fromVC viewController: ViewController) {
        
    }
    
}

extension PlainTextBlock {
    
    
    //0 = body, 1 = title1, 2 = title2, 3 = title3
    var textStyle: FontTextStyle {
        get {
            switch textStyleInteger {
            case 0:
                return .body
            case 1:
                return .title1
            case 2:
                return .title2
            case 3:
                return .title3
            default:
                return .body
            }
        } set {
            switch newValue {
            case .body:
                textStyleInteger = 0
            case .title1:
                textStyleInteger = 1
            case .title2:
                textStyleInteger = 2
            case .title3:
                textStyleInteger = 3
            default:
                textStyleInteger = 0
            }
        }
    }

}

extension OrderedTextBlock {
    
    //0 = body, 1 = title1, 2 = title2, 3 = title3
    var textStyle: FontTextStyle {
        get {
            switch textStyleInteger {
            case 0:
                return .body
            case 1:
                return .title1
            case 2:
                return .title2
            case 3:
                return .title3
            default:
                return .body
            }
        } set {
            switch newValue {
            case .body:
                textStyleInteger = 0
            case .title1:
                textStyleInteger = 1
            case .title2:
                textStyleInteger = 2
            case .title3:
                textStyleInteger = 3
            default:
                textStyleInteger = 0
            }
        }
    }
}

extension UnOrderedTextBlock {
    
    //0 = body, 1 = title1, 2 = title2, 3 = title3
    var textStyle: FontTextStyle {
        get {
            switch textStyleInteger {
            case 0:
                return .body
            case 1:
                return .title1
            case 2:
                return .title2
            case 3:
                return .title3
            default:
                return .body
            }
        } set {
            switch newValue {
            case .body:
                textStyleInteger = 0
            case .title1:
                textStyleInteger = 1
            case .title2:
                textStyleInteger = 2
            case .title3:
                textStyleInteger = 3
            default:
                textStyleInteger = 0
            }
        }
    }
}

extension ChecklistTextBlock {
    
    //0 = body, 1 = title1, 2 = title2, 3 = title3
    var textStyle: FontTextStyle {
        get {
            switch textStyleInteger {
            case 0:
                return .body
            case 1:
                return .title1
            case 2:
                return .title2
            case 3:
                return .title3
            default:
                return .body
            }
        } set {
            switch newValue {
            case .body:
                textStyleInteger = 0
            case .title1:
                textStyleInteger = 1
            case .title2:
                textStyleInteger = 2
            case .title3:
                textStyleInteger = 3
            default:
                textStyleInteger = 0
            }
        }
    }
}

extension ImageCollectionBlock {
}

extension FileBlock {
}

extension DrawingBlock {
}
