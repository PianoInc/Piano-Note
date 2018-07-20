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
    
    var textStyle: TextStyle? {
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
    
    func set(textStyle: TextStyle) {
        
        switch type {
        case .plainText:
            self.plainTextBlock?.textStyle = textStyle
        case .checklistText:
            self.checklistTextBlock?.textStyle = textStyle
        case .unOrderedText:
            self.unOrderedTextBlock?.textStyle = textStyle
        case .orderedText:
            self.orderedTextBlock?.textStyle = textStyle
        default:
            ()
        }
    }
    
    func didSelectItem(fromVC viewController: ViewController) {
        
    }
    
}

enum TextStyle: Int64 {
    case body = 0
    case title1 = 1
    case title2 = 2
    case title3 = 3
    
    var font: Font {
        switch self {
        case .body:
            return Font.preferredFont(forTextStyle: .body)
            
        case .title1:
            return Font.preferredFont(forTextStyle: .title1).bold()
            
        case .title2:
            return Font.preferredFont(forTextStyle: .title2).bold()
            
        case .title3:
            return Font.preferredFont(forTextStyle: .title3).bold()
            
        }
    }
}

extension PlainTextBlock {
    
    var textStyle: TextStyle {
        get {
            return TextStyle(rawValue: textStyleInteger) ?? TextStyle.body
        } set {
            textStyleInteger = newValue.rawValue
        }
    }

}

extension OrderedTextBlock {
    
    var textStyle: TextStyle {
        get {
            return TextStyle(rawValue: textStyleInteger) ?? TextStyle.body
        } set {
            textStyleInteger = newValue.rawValue
        }
    }
}

extension UnOrderedTextBlock {
    
    var textStyle: TextStyle {
        get {
            return TextStyle(rawValue: textStyleInteger) ?? TextStyle.body
        } set {
            textStyleInteger = newValue.rawValue
        }
    }
}

extension ChecklistTextBlock {
    
    var textStyle: TextStyle {
        get {
            return TextStyle(rawValue: textStyleInteger) ?? TextStyle.body
        } set {
            textStyleInteger = newValue.rawValue
        }
    }
}

extension ImageCollectionBlock {
}

extension FileBlock {
}

extension DrawingBlock {
}
