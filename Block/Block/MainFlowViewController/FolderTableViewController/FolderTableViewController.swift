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

        // for restoration
        if resultsController == nil {
            let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            persistentContainer = container
            resultsController = container.viewContext.folderResultsController()
            resultsController?.delegate = self
        }

        updateViews(for: state)
        clearsSelectionOnViewWillAppear = true

        // no restoration session, bypass this view conroller
        if !(UIApplication.shared.delegate as! AppDelegate).isRestoreSession {
            byPassCurrentViewController()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "NoteTableViewController" || identifier == "NoAnimationNoteViewController" {
            guard let vc = segue.destination as? NoteTableViewController, let folder = sender as? Folder else { return }
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
            
        } else if let identifier = segue.identifier, identifier == "FacebookSplitViewController" {
            guard let vc = segue.destination as? UISplitViewController else { return }
            // Facebook splitView
            vc.delegate = self
            vc.preferredDisplayMode = .allVisible
            vc.maximumPrimaryColumnWidth = 414
            vc.minimumPrimaryColumnWidth = 320
        } else if let identifier = segue.identifier, identifier == "SettingSplitViewController" {
            guard let vc = segue.destination as? UISplitViewController else { return }
            // Setting splitView
            vc.delegate = self
            vc.preferredDisplayMode = .allVisible
            vc.maximumPrimaryColumnWidth = 414
            vc.minimumPrimaryColumnWidth = 320
        }
    }
    
    @IBAction func tapAddFolder(_ sender: Any) {
        
    }
}

extension FolderTableViewController : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
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
        guard !tableView.isEditing else { return }
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

    private func byPassCurrentViewController() {
        do {
            try resultsController?.performFetch()
        } catch {
            print("FolderTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
        }
        let folder = resultsController?.object(at: IndexPath(row: 0, section: 0))
        performSegue(withIdentifier: "NoAnimationNoteViewController", sender: folder)
    }
}

extension FolderTableViewController: UIDataSourceModelAssociation {

    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        guard let resultsController = resultsController, !idx.isEmpty else { return nil }

        return resultsController.object(at: idx).objectID
            .uriRepresentation()
            .absoluteString
    }

    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        if let url = URL(string: identifier),
            let id = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let folder = persistentContainer.viewContext.object(with: id) as? Folder {
            return resultsController?.indexPath(forObject: folder)
        }
        return nil
    }
}
