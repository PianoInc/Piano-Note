//
//  Block_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

extension Block: TableDatable {
    var type: BlockType {
        get {
            return BlockType(rawValue: typeInteger) ?? .plainText
        } set {
            typeInteger = newValue.rawValue
        }
    }
    
    var frontWhitespaces: String? {
        get {
            switch type {
            case .checklistText:
                return checklistTextBlock?.frontWhitespaces
            case .orderedText:
                return orderedTextBlock?.frontWhitespaces
            case .unOrderedText:
                return unOrderedTextBlock?.frontWhitespaces
            default:
                return nil
            }
        } set {
            switch type {
            case .checklistText:
                self.checklistTextBlock?.frontWhitespaces = newValue
            case .unOrderedText:
                self.unOrderedTextBlock?.frontWhitespaces = newValue
            case .orderedText:
                self.orderedTextBlock?.frontWhitespaces = newValue
            default:
                ()
            }
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
    
    var isTextType: Bool {
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
        get {
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
        } set {
            switch self.type {
            case .plainText:
                plainTextBlock?.text = newValue
            case .checklistText:
                checklistTextBlock?.text = newValue
            case .unOrderedText:
                unOrderedTextBlock?.text = newValue
            case .orderedText:
                orderedTextBlock?.text = newValue
            default:
                ()
            }
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
    
    var textStyle: FontTextStyle {
        get {
            switch type {
            case .plainText:
                return plainTextBlock?.textStyle ?? .body
            case .checklistText:
                return checklistTextBlock?.textStyle ?? .body
            case .unOrderedText:
                return unOrderedTextBlock?.textStyle ?? .body
            case .orderedText:
                return orderedTextBlock?.textStyle ?? .body
            default:
                return .body
            }
        } set {
            switch type {
            case .plainText:
                plainTextBlock?.textStyle = newValue
            case .checklistText:
                checklistTextBlock?.textStyle = newValue
            case .unOrderedText:
                unOrderedTextBlock?.textStyle = newValue
            case .orderedText:
                orderedTextBlock?.textStyle = newValue
            default:
                ()
            }
        }
        
    }
    
    internal func append(text: String) {
        switch self.type {
        case .plainText:
            guard let originText = plainTextBlock?.text else { return }
            plainTextBlock?.text = originText + text
        case .checklistText:
            guard let originText = checklistTextBlock?.text else { return }
            checklistTextBlock?.text = originText + text
        case .unOrderedText:
            guard let originText = unOrderedTextBlock?.text else { return }
            unOrderedTextBlock?.text = originText + text
        case .orderedText:
            guard let originText = orderedTextBlock?.text else { return }
            orderedTextBlock?.text = originText + text
        default:
            return
        }
    }
    
    
    func didSelectItem(fromVC viewController: ViewController) {
        
    }
    
}

extension Block {
    
    /**
     1. bullet 생성
     2. 이를 block에 연결
     3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
     4. plainTextBlock 연결 끊기
     5. 타입 지정
     6. UI 정보 전달
     */
    internal func replacePlainWith(_ bullet: PianoBullet, on resultsController: NSFetchedResultsController<Block>?, selectedRange: inout NSRange) {
        guard let plain = plainTextBlock,
            let context = managedObjectContext
            else { return }
        
        type = bullet.blockType
        modifiedDate = Date()
        
        var bulletTextBlock: BulletTextBlockType
        switch bullet.type {
        case .orderedlist:
            bulletTextBlock = OrderedTextBlock(context: context)
        case .unOrderedlist:
            bulletTextBlock = UnOrderedTextBlock(context: context)
        case .checkist:
            bulletTextBlock = ChecklistTextBlock(context: context)
        }
        
        bulletTextBlock.frontWhitespaces = bullet.whitespaces.string
        bulletTextBlock.key = bullet.string
        
        
        if let num = Int64(bullet.string),
            let resultsController = resultsController {
            let correctNum = modifyNumIfNeeded(resultsController: resultsController) ?? num
            var bullet = bullet
            bullet.string = "\(correctNum)"
            bulletTextBlock.num = num
        }
        //TODO: attributes에 대한 처리도 해야함(피아노 효과 할 때)
        //        bulletTextBlock.attributes
        
        bulletTextBlock.addToBlockCollection(self)
        
        if let plainBlockCollection = plain.blockCollection, plainBlockCollection.count < 2 {
            context.delete(plain)
        }
        
        plainTextBlock = nil
        
        selectedRange.location -= bullet.baselineIndex
    }
    
    internal func revertToPlain() {
        guard let context = managedObjectContext else { return }
        
        type = .plainText
        modifiedDate = Date()
        
        //1. plainText를 생성하고
        var plainTextBlock = PlainTextBlock(context: context)
        plainTextBlock.text = text
        plainTextBlock.textStyle = textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
        //        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        plainTextBlock.addToBlockCollection(self)
        
        //3.
        if let checklistTextBlock = checklistTextBlock,
            let collection = checklistTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(checklistTextBlock)
        } else if let unOrderedTextBlock = unOrderedTextBlock,
            let collection = unOrderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(unOrderedTextBlock)
        } else if let orderedTextBlock = orderedTextBlock,
            let collection = orderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(orderedTextBlock)
            //TODO: 아래에 ordered이면 현재 order로 치환하고 그다음부터 숫자 크기 세팅
        }
        
        //4. 나머지 것들 연결 끊기
        checklistTextBlock = nil
        unOrderedTextBlock = nil
        orderedTextBlock = nil
        
    }
    
    internal func combinePreviousBlock(on resultsController: NSFetchedResultsController<Block>?) {
        guard let resultsController = resultsController,
            var indexPath = resultsController.indexPath(forObject: self),
            let text = text else { return }
        
        while indexPath.row > 0 {
            indexPath.row -= 1
            let previousBlock = resultsController.object(at: indexPath)
            guard resultsController.object(at: indexPath).isTextType else { continue }
            previousBlock.append(text: text)
            previousBlock.modifiedDate = Date()
            self.deleteWithRelationship()
            return
        }
    }
    
    internal func insertBlock(with text: String, on resultsController: NSFetchedResultsController<Block>?) {
        guard let resultsController = resultsController,
            let count = resultsController.sections?.first?.numberOfObjects,
            var indexPath = resultsController.indexPath(forObject: self),
            let context = managedObjectContext else { return }
        
        indexPath.row += 1
        
        //다음 block이 있다면, order는 둘의 평균으로 잡고, 없다면 + 1하기
        let createdOrder: Double
        if indexPath.row < count {
            let nextOrder = resultsController.object(at: indexPath).order
            createdOrder = (order + nextOrder) / 2
        } else {
            createdOrder = order + 1
        }
        
        //1. block 생성
        let newblock = Block(context: context)
        newblock.order = order
        newblock.note = note
        newblock.type = type
        
        order = createdOrder
        
        switch type {
        case .plainText:
            
            guard let plainTextBlock = plainTextBlock else { return }
            
            //2. plainBlock 생성
            let newPlainBlock = PlainTextBlock(context: context)
            newPlainBlock.text = text
            newPlainBlock.textStyleInteger = plainTextBlock.textStyleInteger
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newPlainBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newPlainBlock.addToBlockCollection(newblock)
            
        case .checklistText:
            guard let checklistTextBlock = checklistTextBlock else { return }
            
            //2. checklistText 생성
            let newChecklistTextBlock = ChecklistTextBlock(context: context)
            newChecklistTextBlock.text = text
            newChecklistTextBlock.textStyleInteger = checklistTextBlock.textStyleInteger
            newChecklistTextBlock.frontWhitespaces = checklistTextBlock.frontWhitespaces
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newChecklistTextBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newChecklistTextBlock.addToBlockCollection(newblock)
            
        case .unOrderedText:
            guard let unOrderedTextBlock = unOrderedTextBlock else { return }
            
            //2. unOrderedText 생성
            let newUnOrderedTextBlock = UnOrderedTextBlock(context: context)
            newUnOrderedTextBlock.text = text
            newUnOrderedTextBlock.textStyleInteger = unOrderedTextBlock.textStyleInteger
            newUnOrderedTextBlock.frontWhitespaces = unOrderedTextBlock.frontWhitespaces
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newUnOrderedTextBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newUnOrderedTextBlock.addToBlockCollection(newblock)
            
        case .orderedText:
            guard let orderedTextBlock = orderedTextBlock else { return }
            
            //2. orderedText 생성
            let newOrderedTextBlock = OrderedTextBlock(context: context)
            newOrderedTextBlock.text = text
            newOrderedTextBlock.num = orderedTextBlock.num + 1
            newOrderedTextBlock.textStyleInteger = orderedTextBlock.textStyleInteger
            newOrderedTextBlock.frontWhitespaces = orderedTextBlock.frontWhitespaces
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newOrderedTextBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newOrderedTextBlock.addToBlockCollection(newblock)
            
        default:
            return
        }
        
    }
    
    internal func insertNextBlock(with text: String, on resultsController: NSFetchedResultsController<Block>?) {
        guard let resultsController = resultsController,
            let count = resultsController.sections?.first?.numberOfObjects,
            var indexPath = resultsController.indexPath(forObject: self),
            let context = managedObjectContext else { return }
        
        indexPath.row += 1
        
        //다음 block이 있다면, order는 둘의 평균으로 잡고, 없다면 + 1하기
        let createdOrder: Double
        if indexPath.row < count {
            let nextOrder = resultsController.object(at: indexPath).order
            createdOrder = (order + nextOrder) / 2
        } else {
            createdOrder = order + 1
        }
        
        
        //1. block 생성
        let newblock = Block(context: context)
        newblock.order = createdOrder
        newblock.note = note
        newblock.type = type
        
        switch type {
        case .plainText:
            
            guard let plainTextBlock = plainTextBlock else { return }
            
            //2. plainBlock 생성
            let newPlainBlock = PlainTextBlock(context: context)
            newPlainBlock.text = text
            newPlainBlock.textStyleInteger = plainTextBlock.textStyleInteger
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newPlainBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newPlainBlock.addToBlockCollection(newblock)
            
        case .checklistText:
            guard let checklistTextBlock = checklistTextBlock else { return }
            
            //2. checklistText 생성
            let newChecklistTextBlock = ChecklistTextBlock(context: context)
            newChecklistTextBlock.text = text
            newChecklistTextBlock.textStyleInteger = checklistTextBlock.textStyleInteger
            newChecklistTextBlock.frontWhitespaces = checklistTextBlock.frontWhitespaces
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newChecklistTextBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newChecklistTextBlock.addToBlockCollection(newblock)
            
        case .unOrderedText:
            guard let unOrderedTextBlock = unOrderedTextBlock else { return }
            
            //2. unOrderedText 생성
            let newUnOrderedTextBlock = UnOrderedTextBlock(context: context)
            newUnOrderedTextBlock.text = text
            newUnOrderedTextBlock.textStyleInteger = unOrderedTextBlock.textStyleInteger
            newUnOrderedTextBlock.frontWhitespaces = unOrderedTextBlock.frontWhitespaces
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newUnOrderedTextBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newUnOrderedTextBlock.addToBlockCollection(newblock)
            
        case .orderedText:
            guard let orderedTextBlock = orderedTextBlock else { return }
            
            //2. orderedText 생성
            let newOrderedTextBlock = OrderedTextBlock(context: context)
            newOrderedTextBlock.text = text
            newOrderedTextBlock.num = orderedTextBlock.num + 1
            newOrderedTextBlock.textStyleInteger = orderedTextBlock.textStyleInteger
            newOrderedTextBlock.frontWhitespaces = orderedTextBlock.frontWhitespaces
            
            //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
            //        newOrderedTextBlock.attributes
            
            //2. 이를 block에 연결시킨다.
            newOrderedTextBlock.addToBlockCollection(newblock)
            
        default:
            return
        }
        
    }
    
    internal func updateNumbersAfter(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let orderedTextBlock = orderedTextBlock,
            let resultsController = controller as? NSFetchedResultsController<Block>,
            var indexPath = resultsController.indexPath(forObject: self) else { return }
    
        var num = orderedTextBlock.num
        while true {
            indexPath.row += 1
            num += 1
            guard let numberOfObjects = resultsController.sections?.first?.numberOfObjects,
                indexPath.row < numberOfObjects else { return }
            let nextBlock = resultsController.object(at: indexPath)
            guard let nextOrderedTextBlock = nextBlock.orderedTextBlock,
                num != nextOrderedTextBlock.num,
                (self.frontWhitespaces ?? "") == (nextBlock.frontWhitespaces ?? "") else { return }
            
            nextOrderedTextBlock.num = num
            nextBlock.modifiedDate = Date()
            
        }
    }
    
    internal func deleteWithRelationship() {
        guard let context = managedObjectContext else { return }
        
        //1. 자신과 연결된 블록을 체크하여 삭제한다.
        if let plainTextBlock = plainTextBlock,
            let collection = plainTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(plainTextBlock)
        } else if let checklistTextBlock = checklistTextBlock,
            let collection = checklistTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(checklistTextBlock)
        } else if let unOrderedTextBlock = unOrderedTextBlock,
            let collection = unOrderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(unOrderedTextBlock)
        } else if let orderedTextBlock = orderedTextBlock,
            let collection = orderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(orderedTextBlock)
        } else if let drawingBlock = drawingBlock,
            let collection = drawingBlock.blockCollection,
            collection.count < 2 {
            context.delete(drawingBlock)
        } else if let fileBlock = fileBlock,
            let collection = fileBlock.blockCollection,
            collection.count < 2 {
            context.delete(fileBlock)
        } else if let imageCollectionBlock = imageCollectionBlock,
            let collection = imageCollectionBlock.blockCollection,
            collection.count < 2 {
            
            //TODO: 이미지 컬렉션이 갖고 있는 ID의 이미지값들도 지워야함, 이 로직이 맞는 지 테스트해야함
            if let imageIDCollection = imageCollectionBlock.imageIDCollection {
                for imageID in imageIDCollection {
                    guard let imageID = imageID as? ImageID,
                        let id = imageID.id else { continue }
                    //이미지와 이미지 id 모두 지워야 한다
                    if let imageBlock = context.fetchImageBlock(id: id) {
                        context.delete(imageBlock)
                    }
                    context.delete(imageID)
                }
            }
            context.delete(imageCollectionBlock)
        } else {
            //나머지 추가로 추가될 것들
        }
        
        
        //TODO: 2. 댓글은 당연히 다 지운다. -> 자신과 order가 같은 모든 블럭 + 연결된 커멘트를 지워야함
        
        
        //3. 나 자신을 지워야함
        context.delete(self)
        
    }
    
    private func modifyNumIfNeeded(resultsController: NSFetchedResultsController<Block>) -> Int64? {
        guard var indexPath = resultsController.indexPath(forObject: self),
            indexPath.row > 0,
            let previousOrderedTextBlock = resultsController
                .object(at: IndexPath(row: indexPath.row - 1,
                                      section: indexPath.section)).orderedTextBlock,
            (self.orderedTextBlock?.frontWhitespaces ?? "") == (previousOrderedTextBlock.frontWhitespaces ?? "")
            else { return nil }
        
        return previousOrderedTextBlock.num + 1
        
    }
}
