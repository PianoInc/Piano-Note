//
//  NoteTableVC_FRC_delegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation
import CoreData

extension NoteTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .update:
            guard let indexPath = indexPath,
                let note = controller.object(at: indexPath) as? Note,
                let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return }
            cell.data = note
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
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
    }
    
}
