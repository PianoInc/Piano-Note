//
//  BlockTableViewController_NSFetchedResultsController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import CoreData

extension BlockTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("hello")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.performBatchUpdates({ [weak self] in
            guard let `self` = self else { return }
            switch type {
            case .delete:
                guard let indexPath = indexPath else { return }
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            case .update:
                ()
//                이 부분에선 save를 하지음않음
//                guard let indexPath = indexPath else { return }
//                guard var cell = tableView.cellForRow(at: indexPath) as? TableDataAcceptable,
//                    let data = controller.object(at: indexPath) as? Block else { return }
//                cell.data = data
                
                
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
                
            }
            }, completion: nil)
    }
}
