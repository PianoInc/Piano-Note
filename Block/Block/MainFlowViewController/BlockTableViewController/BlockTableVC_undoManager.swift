//
//  BlockTableVC_undoManager.swift
//  Block
//
//  Created by 김범수 on 2018. 8. 5..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
/*
 * 현재는 viewDidAppear에서 마지막에 save를 하는식으로 사용하고 있는데,
 * 나중에 실시간 sync를 지원하시려면 결국 editAction을 기반으로 save를 해야할 것으로 생각됩니다.
 * Block내의 textView 또한 독립된 undoManager를 가질 수 있습니다.
 * FirstResponder가 textView에게 넘어가있을 땐 어차피 undo의 컨트롤을 textView가 할 수 밖에없습니다.
 * (undo메세지는 firstResponder의 undoManager에 전달되기 때문)
 * 저희가 신경써야할 부분은 focus가 cell로부터 나왔을때 밑의 메소드들을 사용하여
 * save & registerUndoAction하는 것이 포인트가 될 것으로 보입니다.
 * eg. cell의 textView가 resignFirstResponder했을 때 applyModification()
 *     cell을 복사해서 붙여넣었을때 applyAddtion()
 *     cell을 지웠을 때 applyDeletion()
 */
extension BlockTableViewController {
    
    func applyModification(at indexPath: IndexPath) {
        guard let block = resultsController?.object(at: indexPath)
            else { return /*여기로 오면 안된다!*/}

        //TODO: 블록에 따라 여러가지 데이터 타입이 존재 할 수 있기 때문에 프로토콜 정의 필요
        //register undo시 closure capture가 일어나므로
        //지금은 block자체를 넘기지만 최대한 value type으로 가는게 좋을것 같다.
        let previousText = block.text ?? ""
        
        //register undo
        undoManager?.registerUndo(withTarget: self) { target in
            block.text = previousText
            try? target.persistentContainer?.viewContext.save()
        }
        
        //perform ordinary save
        try? persistentContainer?.viewContext.save()
    }
    
    func applyDeletion(at indexPath: IndexPath) {
        guard let block = resultsController?.object(at: indexPath)
            else { return /*여기로 오면 안된다!*/}
        
        undoManager?.registerUndo(withTarget: self) { target in
            //TODO: CoreData에서 insertAt같은거...
        }
        persistentContainer?.viewContext.delete(block)
    }
    
    func applyAddition(at indexPath: IndexPath, with newBlock: Block) {
        undoManager?.registerUndo(withTarget: self) { target in
            target.persistentContainer?.viewContext.delete(newBlock)
        }
        //TODO: persistentContainer?.viewContext.insertAt? 같은 동작 필요
    }
}
