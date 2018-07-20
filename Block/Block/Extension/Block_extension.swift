//
//  Block_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

//CoreData 값 변경
extension Block {
    internal func replacePlainWithOrdered(bullet: PianoBullet) {
        guard let plainTextBlock = plainTextBlock,
            let num = Int64(bullet.string),
            let context = managedObjectContext else { return }
        
        //1. orderedText를 생성하고
        let orderedTextBlock = OrderedTextBlock(context: context)
        orderedTextBlock.num = num
        orderedTextBlock.frontWhitespaces = bullet.whitespaces.string
        orderedTextBlock.text = (bullet.text as NSString).substring(from: bullet.baselineIndex)
        orderedTextBlock.textStyle = plainTextBlock.textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
//        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        orderedTextBlock.addToBlockCollection(self)
        
        //3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
        if let plainTextBlockCollection = plainTextBlock.blockCollection,
            plainTextBlockCollection.count < 2 {
            context.delete(plainTextBlock)
        }
        
        //4. plainTextBlock 연결 끊기
        self.plainTextBlock = nil
        
        //5. 타입을 지정하고
        type = .orderedText
    }
    
    internal func replacePlainWithUnOrdered(bullet: PianoBullet) {
        guard let plainTextBlock = plainTextBlock,
            let context = managedObjectContext else { return }
        
        //1. unOrderedText를 생성하고
        let unOrderedTextBlock = UnOrderedTextBlock(context: context)
        unOrderedTextBlock.key = bullet.string
        unOrderedTextBlock.frontWhitespaces = bullet.whitespaces.string
        unOrderedTextBlock.text = (bullet.text as NSString).substring(from: bullet.baselineIndex)
        unOrderedTextBlock.textStyle = plainTextBlock.textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
//        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        unOrderedTextBlock.addToBlockCollection(self)
        
        //3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
        if let plainTextBlockCollection = plainTextBlock.blockCollection,
            plainTextBlockCollection.count < 2 {
            context.delete(plainTextBlock)
        }
        
        //4. plainTextBlock 연결 끊기
        self.plainTextBlock = nil
        
        //5. 타입을 지정해준다
        type = .unOrderedText
    }
    
    internal func replacePlainWithCheck(bullet: PianoBullet) {
        guard let plainTextBlock = plainTextBlock,
            let context = managedObjectContext else { return }
        
        //1. checklistText를 생성하고
        let checklistTextBlock = ChecklistTextBlock(context: context)
        checklistTextBlock.frontWhitespaces = bullet.whitespaces.string
        checklistTextBlock.text = (bullet.text as NSString).substring(from: bullet.baselineIndex)
        checklistTextBlock.textStyle = plainTextBlock.textStyle
        //TODO: 잘린 글자만큼 형광펜 범위를 조정해서 대입해줘야함
//        orderedTextBlock.attributes
        
        //2. 이를 block에 연결시킨다.
        checklistTextBlock.addToBlockCollection(self)
        
        //3. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
        if let plainTextBlockCollection = plainTextBlock.blockCollection,
            plainTextBlockCollection.count < 2 {
            context.delete(plainTextBlock)
        }
        
        //4. plainTextBlock 연결 끊기
        self.plainTextBlock = nil
        
        //5. 타입을 지정해준다
        type = .checklistText
    }
    
    internal func revertToPlain() {
        guard let context = managedObjectContext else { return }
        
        
        //1. plainText를 생성하고
        let plainTextBlock = PlainTextBlock(context: context)
        plainTextBlock.text = self.text
        plainTextBlock.textStyle = self.textStyle ?? .body
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
        }
        
        //4. 나머지 것들 연결 끊기
        self.checklistTextBlock = nil
        self.unOrderedTextBlock = nil
        self.orderedTextBlock = nil
        
        //5. 타입을 지정한다
        type = .plainText
    }
    
    internal func deleteSelf() {
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
    
    
}
