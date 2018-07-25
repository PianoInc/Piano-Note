//
//  BlockTableViewController_DropDelegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit


/**
 Consume Data from a Drop Session
 To consume data from a drop session in a table view, you implement three delegate methods.
 */
extension BlockTableViewController: UITableViewDropDelegate {
    
    /**
     First, your app can refuse the drag items based on their class, the state of your app, or other requirements. This project’s implementation allows a user to drop only instances of the NSString class. Here is the model-agnostic portion of this code:
     */
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    /**
     Second, you must tell the system how you want to consume the data, which is typically by copying it. You specify this choice by way of a drop proposal:
     */
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    /**
     Finally, after the user lifts their finger from the screen, indicating their intent to drop the drag items, your table view has one opportunity to request particular data representations of the drag items:
     
     (This delegate method is the only opportunity for accessing and loading
     the data representations offered in the drag item. The drop coordinator
     supports accessing the dropped items, updating the table view, and specifying
     optional animations. Local drags with one item go through the existing
     `tableView(_:moveRowAt:to:)` method on the data source.)
     */
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // Consume drag items.
            let stringItems = items as! [String]
            
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                
//                self.model.addItem(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }
            
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
