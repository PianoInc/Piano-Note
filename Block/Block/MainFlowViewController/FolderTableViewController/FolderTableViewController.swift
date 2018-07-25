//
//  CategoryTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class FolderTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer!
    var resultsController: NSFetchedResultsController<Folder>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? NoteTableViewController,
            let folder = sender as? Folder {
            
            vc.persistentContainer = persistentContainer
            
            persistentContainer.performBackgroundTask { (context) in
                let resultsController = context.noteResultsController(folder: folder)
                vc.resultsController = resultsController
                context.perform(resultsController: resultsController, tableVC: vc)
            }
        }
    }

    @IBAction func tapAddFolder(_ sender: Any) {

    }
}

extension FolderTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = resultsController?.object(at: indexPath) else { return UITableViewCell() }
        var cell = tableView.dequeueReusableCell(withIdentifier: data.identifier) as! TableDataAcceptable & UITableViewCell
        cell.data = data
        return cell
     }
 
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return resultsController?.object(at: indexPath).folderType != .custom ? false : true
     }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3) ?? UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultsController?.object(at: indexPath).didSelectItem(fromVC: self)
    }
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

     }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}

extension FolderTableViewController: NSFetchedResultsControllerDelegate {
    
}
