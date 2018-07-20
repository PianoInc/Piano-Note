//
//  BlockTableViewController_CoreData.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

/**
 
 <Model Action>
 1. replace
 2. update
 3. delete
 4. insert
 
 */
extension BlockTableViewController {
    internal func replacePlainWithOrdered(block: Block, bullet: PianoBullet) {
        guard let plainTextBlock = block.plainTextBlock,
            let num = Int64(bullet.string),
            let context = block.managedObjectContext else { return }
        
        //1. orderedText를 생성하고
        let orderedTextBlock = OrderedTextBlock(context: context)
        orderedTextBlock.num = num
        orderedTextBlock.frontWhitespaces = bullet.whitespaces.string
        orderedTextBlock.text = (bullet.text as NSString).substring(from: bullet.baselineIndex)
        orderedTextBlock.textStyle = plainTextBlock.textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
        //        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        orderedTextBlock.addToBlockCollection(block)
        
        //3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
        if let plainTextBlockCollection = plainTextBlock.blockCollection,
            plainTextBlockCollection.count < 2 {
            context.delete(plainTextBlock)
        }
        
        //4. plainTextBlock 연결 끊기
        block.plainTextBlock = nil
        
        //5. 타입을 지정하고
        block.type = .orderedText
        
        //6. UI Update
        update(block: block, deletedFormatLength: -bullet.baselineIndex)
    }
    
    internal func replacePlainWithUnOrdered(block: Block, bullet: PianoBullet) {
        guard let plainTextBlock = block.plainTextBlock,
            let context = block.managedObjectContext else { return }
        
        //1. unOrderedText를 생성하고
        let unOrderedTextBlock = UnOrderedTextBlock(context: context)
        unOrderedTextBlock.key = bullet.string
        unOrderedTextBlock.frontWhitespaces = bullet.whitespaces.string
        unOrderedTextBlock.text = (bullet.text as NSString).substring(from: bullet.baselineIndex)
        unOrderedTextBlock.textStyle = plainTextBlock.textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
        //        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        unOrderedTextBlock.addToBlockCollection(block)
        
        //3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
        if let plainTextBlockCollection = plainTextBlock.blockCollection,
            plainTextBlockCollection.count < 2 {
            context.delete(plainTextBlock)
        }
        
        //4. plainTextBlock 연결 끊기
        block.plainTextBlock = nil
        
        //5. 타입을 지정해준다
        block.type = .unOrderedText
        
        //6. UI Update
        update(block: block, deletedFormatLength: -bullet.baselineIndex)
    }
    
    internal func replacePlainWithCheck(block: Block, bullet: PianoBullet) {
        guard let plainTextBlock = block.plainTextBlock,
            let context = block.managedObjectContext else { return }
        
        //1. checklistText를 생성하고
        let checklistTextBlock = ChecklistTextBlock(context: context)
        checklistTextBlock.frontWhitespaces = bullet.whitespaces.string
        checklistTextBlock.text = (bullet.text as NSString).substring(from: bullet.baselineIndex)
        checklistTextBlock.textStyle = plainTextBlock.textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
        //        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        checklistTextBlock.addToBlockCollection(block)
        
        //3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
        if let plainTextBlockCollection = plainTextBlock.blockCollection,
            plainTextBlockCollection.count < 2 {
            context.delete(plainTextBlock)
        }
        
        //4. plainTextBlock 연결 끊기
        block.plainTextBlock = nil
        
        //5. 타입을 지정해준다
        block.type = .checklistText
        
        //6. UI Update
        update(block: block, deletedFormatLength: -bullet.baselineIndex)
    }
    
    internal func replaceToPlain(block: Block) {
        guard let context = block.managedObjectContext else { return }
        
        
        //1. plainText를 생성하고
        let plainTextBlock = PlainTextBlock(context: context)
        plainTextBlock.text = block.text
        plainTextBlock.textStyle = block.textStyle ?? .body
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
        //        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        plainTextBlock.addToBlockCollection(block)
        
        //3.
        if let checklistTextBlock = block.checklistTextBlock,
            let collection = checklistTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(checklistTextBlock)
        } else if let unOrderedTextBlock = block.unOrderedTextBlock,
            let collection = unOrderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(unOrderedTextBlock)
        } else if let orderedTextBlock = block.orderedTextBlock,
            let collection = orderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(orderedTextBlock)
        }
        
        //4. 나머지 것들 연결 끊기
        block.checklistTextBlock = nil
        block.unOrderedTextBlock = nil
        block.orderedTextBlock = nil
        
        //5. 타입을 지정한다
        block.type = .plainText
        
        //6. UI Update
        update(block: block, deletedFormatLength: nil)
    }
    
    internal func movePrevious(block: Block) {
        guard var indexPath = resultsController?.indexPath(forObject: block),
            let text = block.text else { return }
        
        while indexPath.row > 0 {
            indexPath.row -= 1
            
            guard let previousBlock = resultsController?.object(at: indexPath),
                previousBlock.isTextType,
                let cell = tableView.cellForRow(at: indexPath) as? TextBlockTableViewCell else { continue }
            
            let selectedRange = NSMakeRange(previousBlock.text?.count ?? 0, 0)
            cell.ibTextView.selectedRange = selectedRange
            cell.ibTextView.isEditable = true
            cell.ibTextView.becomeFirstResponder()
            
            tableView.performBatchUpdates({
                previousBlock.append(text: text)
                update(block: previousBlock, deletedFormatLength: nil)
                delete(block: block)
            }, completion: nil)
            
            
            
            return
            
        }

        
    }
    
    internal func delete(block: Block) {
        guard let context = block.managedObjectContext else { return }
        
        //1. 자신과 연결된 블록을 체크하여 삭제한다.
        if let plainTextBlock = block.plainTextBlock,
            let collection = plainTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(plainTextBlock)
        } else if let checklistTextBlock = block.checklistTextBlock,
            let collection = checklistTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(checklistTextBlock)
        } else if let unOrderedTextBlock = block.unOrderedTextBlock,
            let collection = unOrderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(unOrderedTextBlock)
        } else if let orderedTextBlock = block.orderedTextBlock,
            let collection = orderedTextBlock.blockCollection,
            collection.count < 2 {
            context.delete(orderedTextBlock)
        } else if let drawingBlock = block.drawingBlock,
            let collection = drawingBlock.blockCollection,
            collection.count < 2 {
            context.delete(drawingBlock)
        } else if let fileBlock = block.fileBlock,
            let collection = fileBlock.blockCollection,
            collection.count < 2 {
            context.delete(fileBlock)
        } else if let imageCollectionBlock = block.imageCollectionBlock,
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
        context.delete(block)
        
        //4. UI update
        //Auto
        do {
            try context.save()
        } catch {
            print("delete(block: Block) 에러: \(error.localizedDescription)")
        }
    }
    
    //MARK: typing할 때 서식화 될 때 업데이트 메서드로 퍼포먼스를 위해 TableView UI Animation을 진행하지 않는다.
    internal func update(block: Block, deletedFormatLength: Int?) {
        guard let indexPath = resultsController?.indexPath(forObject: block),
            let cell = tableView.cellForRow(at: indexPath) as? TableDataAcceptable & TextBlockTableViewCell else { return }
        
        var selectedRange = cell.ibTextView.selectedRange
        cell.data = block
        
        if let offset = deletedFormatLength {
            selectedRange.location += offset
        }
        
        cell.ibTextView.selectedRange = selectedRange
    }
    
    internal func update(block: Block, textStyle: FontTextStyle) {
        guard let indexPath = resultsController?.indexPath(forObject: block) else { return }
        
        switch block.type {
        case .plainText:
            block.plainTextBlock?.textStyle = textStyle
        case .checklistText:
            block.checklistTextBlock?.textStyle = textStyle
        case .unOrderedText:
            block.unOrderedTextBlock?.textStyle = textStyle
        case .orderedText:
            block.orderedTextBlock?.textStyle = textStyle
        default:
            ()
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    

    
}
