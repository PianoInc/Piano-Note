//
//  NoteTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer!
    var folder: Folder!

    var resultsController: NSFetchedResultsController<Note>?
    internal var delayBlockQueue: [(NoteTableViewController) -> Void] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0(self) }
        
        try? persistentContainer.viewContext.saveIfNeeded()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        //TODO: persistentContainer 가 nil이라는 건 preserve로 왔거나 splitView라는 말임, 따라서 할당해주고, prepare에서 하는 짓을 다시 해줘야함
        if persistentContainer == nil {
            
        }
        
        
        
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("NoteResultsController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func tapNewNote(_ sender: UIBarButtonItem) {
        let note = Note()

        performSegue(withIdentifier: "DetailNavigationController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? BlockTableViewController,
            let note = sender as? Note, let folderType = note.folder?.folderType {
            let state: BlockTableViewController.ViewControllerState =
                folderType !=
                .deleted ?
                .normal :
                .deleted
            
            vc.state = state
            vc.note = note
            vc.persistentContainer = persistentContainer
            let context = persistentContainer.viewContext
            let resultsController = context.blockResultsController(note: note)
            vc.resultsController = resultsController
            resultsController.delegate = vc

            
        } else if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? SortTableViewController  {
            vc.noteTableVC = self
        }
    }
    
}

extension NoteTableViewController {
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
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3) ?? UITableViewCellEditingStyle.none
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultsController?.object(at: indexPath).didSelectItem(fromVC: self)
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

extension NoteTableViewController: NSFetchedResultsControllerDelegate {
    
}
