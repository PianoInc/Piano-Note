//
//  BlockTableViewController_NSFetchedResultsController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import CoreData
import UIKit

extension BlockTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        UIView.performWithoutAnimation {
            switch type {
            case .delete:
                guard var indexPath = indexPath else { return }
                self.tableView.deleteRows(at: [indexPath], with: .none)
                
                guard let count = controller.sections?.first?.numberOfObjects else { return }
                while true {
                    guard indexPath.row < count,
                        let nextBlock = controller.object(at: indexPath) as? Block,
                        let nextOrderedBlock = nextBlock.orderedTextBlock else { return }
                    nextOrderedBlock.num -= 1
                    nextBlock.modifiedDate = Date()
                    indexPath.row += 1
                }
                
            case .insert:
                guard var newIndexPath = newIndexPath else { return }
                self.tableView.insertRows(at: [newIndexPath], with: .none)
                print("insert : \(newIndexPath.row)")
                
                //issue: 타이밍 이슈 때문에 여기서 숫자를 갱신해줘야함
                guard let block = controller.object(at: newIndexPath) as? Block,
                    let orderedTextBlock = block.orderedTextBlock,
                    let count = controller.sections?.first?.numberOfObjects else { return }
                var num = orderedTextBlock.num
                while true {
                    newIndexPath.row += 1
                    num += 1
                    guard newIndexPath.row < count,
                        let nextBlock = controller.object(at: newIndexPath) as? Block,
                        let nextOrderedTextBlock = nextBlock.orderedTextBlock else { return }
                    nextOrderedTextBlock.num = num
                    nextBlock.modifiedDate = Date() //UI 갱신용
                }

            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .none)
                print("update : \(indexPath.row)")

            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
                
            }
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
        guard let cursorCache = cursorCache,
            let cell = tableView.cellForRow(at: cursorCache.indexPath) as? TextBlockTableViewCell else { return }
        cell.ibTextView.isEditable = true
        cell.ibTextView.selectedRange = cursorCache.selectedRange
        cell.ibTextView.becomeFirstResponder()
        self.cursorCache = nil
    }
    
}
