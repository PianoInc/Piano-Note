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
    var state: ViewControllerState = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(for: state)
        clearsSelectionOnViewWillAppear = true
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? NoteTableViewController,
            let folder = sender as? Folder {
            
            vc.folder = folder
            vc.persistentContainer = persistentContainer
            let state: NoteTableViewController.ViewControllerState
            switch folder.folderType {
            case .all, .custom:
                state = .normal
                
            case .deleted:
                state = .deleted
                
            case .locked:
                state = .locked
                
            }
            vc.state = state
            
            let context = persistentContainer.viewContext
            let resultsController = context.noteResultsController(folder: folder)
            vc.resultsController = resultsController
            resultsController.delegate = vc
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

extension FolderTableViewController {
    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("FolderTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func save() {
        persistentContainer.viewContext.saveIfNeeded()
    }
}
