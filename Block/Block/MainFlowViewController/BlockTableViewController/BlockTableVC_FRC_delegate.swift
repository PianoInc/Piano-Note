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
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .none)
            refreshOrderedTextIfNeeded(controller: controller, currentIndexPath: indexPath)
            

        case .insert:
            UIView.performWithoutAnimation {
                guard let newIndexPath = newIndexPath else { return }
                self.tableView.insertRows(at: [newIndexPath], with: .none)
                
                //issue: 타이밍 이슈 때문에 여기서 숫자를 갱신해줘야함
                guard let block = controller.object(at: newIndexPath) as? Block else { return }
                block.updateNumbersAfter(controller: controller)
            }

            
        case .update:
            UIView.performWithoutAnimation {
                guard let indexPath = indexPath,
                    let block = controller.object(at: indexPath) as? Block,
                    let cell = tableView.cellForRow(at: indexPath) as? TextBlockTableViewCell else { return }
                cell.data = block
                
                    //issue: 타이밍 이슈 때문에 여기서 숫자를 갱신해줘야함
                block.updateNumbersAfter(controller: controller)
                }

        case .move:
            UIView.performWithoutAnimation {
                guard let indexPaths = tableView.indexPathsForVisibleRows else {return}
                tableView.reloadRows(at: indexPaths, with: .none)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integersIn: sectionIndex...sectionIndex), with: .automatic)
            
        case .insert:
            tableView.insertSections(IndexSet(integersIn: sectionIndex...sectionIndex), with: .automatic)
            
        default:
            ()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        guard let cursorCache = cursorCache,
            let cell = tableView.cellForRow(at: cursorCache.indexPath) as? TextBlockTableViewCell else { return }
        cell.ibTextView.isEditable = true
        cell.ibTextView.selectedRange = cursorCache.selectedRange
        cell.ibTextView.becomeFirstResponder()
        self.cursorCache = nil
    }
    
}

extension BlockTableViewController {
    private func refreshOrderedTextIfNeeded(controller: NSFetchedResultsController<NSFetchRequestResult>, currentIndexPath indexPath: IndexPath) {
        guard let count = controller.sections?.first?.numberOfObjects else { return }
        guard indexPath.row > 0 else { return }
        var indexPath = indexPath
        indexPath.row -= 1
        guard let prevBlock = controller.object(at: indexPath) as? Block,
            let prevOrderedTextBlock = prevBlock.orderedTextBlock else  { return }
        var num = prevOrderedTextBlock.num
        while true {
            num += 1
            indexPath.row += 1
            guard indexPath.row < count,
                let nextBlock = controller.object(at: indexPath) as? Block,
                let nextOrderedBlock = nextBlock.orderedTextBlock else { return }
            nextOrderedBlock.num = num
            nextBlock.modifiedDate = Date()
        }
    }
}
