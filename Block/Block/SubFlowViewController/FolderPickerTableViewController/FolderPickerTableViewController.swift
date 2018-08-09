//
//  CategoryPickerTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class FolderPickerTableViewController: UITableViewController {
    
    var note: Note?
    var resultsController: NSFetchedResultsController<Folder>?
    var context: NSManagedObjectContext {
        return resultsController?.managedObjectContext ??
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
            
            self.toolbarItems?.last?.isEnabled = false
            guard let fetchedObjects = self.resultsController?.fetchedObjects, !fetchedObjects.isEmpty else {return}
            self.toolbarItems?.last?.isEnabled = true
        }
    }
    
    @IBAction func tapDone(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func newfolder(_ sender: UIBarButtonItem) {
        showCreateFolderAlertVC()
    }
    
    func showCreateFolderAlertVC() {
        let alert = UIAlertController(title: "Add Folder".loc, message: "AddFolderMessage".loc, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel".loc, style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Create".loc, style: .default) { action in
            guard let text = alert.textFields?.first?.text else {return}
            let lastOrder = self.resultsController?.fetchedObjects?.filter({$0.typeInteger == 3}).last?.order ?? 0
            let newFolder = Folder(context: self.context)
            newFolder.name = text
            newFolder.order = lastOrder + 1
            newFolder.folderType = .custom
        }
        ok.isEnabled = false
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField { (textField) in
            textField.returnKeyType = .done
            textField.enablesReturnKeyAutomatically = true
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        present(alert, animated: true, completion: nil)
    }
    
    @objc func textChanged(sender: AnyObject) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) {resp = resp.next}
        let alert = resp as! UIAlertController
        guard let contain = resultsController?.fetchedObjects?.contains(where: {$0.name == tf.text}) else {return}
        alert.actions[1].isEnabled = (tf.text != "") && !contain
    }
    
}

extension FolderPickerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = resultsController?.object(at: indexPath) else {return UITableViewCell()}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {return UITableViewCell()}
        cell.textLabel?.text = data.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let folder = resultsController?.sections?[indexPath.section].objects?[indexPath.row] as? Folder else {return}
        note?.folder = folder
    }
    
}

extension FolderPickerTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath, let folder = controller.object(at: indexPath) as? Folder,
                let cell = tableView.cellForRow(at: indexPath) as? FolderTableViewCell else {return}
            cell.data = folder
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete: tableView.deleteSections(IndexSet(integersIn: sectionIndex...sectionIndex), with: .fade)
        case .insert: tableView.insertSections(IndexSet(integersIn: sectionIndex...sectionIndex), with: .fade)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
