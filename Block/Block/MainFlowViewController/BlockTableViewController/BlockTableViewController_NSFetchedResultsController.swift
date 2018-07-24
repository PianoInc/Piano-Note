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
                guard let indexPath = indexPath else { return }
                self.tableView.deleteRows(at: [indexPath], with: .none)
                
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                self.tableView.insertRows(at: [newIndexPath], with: .none)
                
            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .none)
//                tableView.beginUpdates()
//                guard var cell = tableView.cellForRow(at: indexPath) as? TableDataAcceptable,
//                    let data = controller.object(at: indexPath) as? Block else { return }
//                cell.data = data
//                tableView.endUpdates()

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
