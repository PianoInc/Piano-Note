//
//  AttachListTableViewController.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 6..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class AttachListTableViewController: UITableViewController {
    
    var resultsController: NSFetchedResultsController<Block>?
    var type: AttachType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "BlockNavigationController" {
            guard let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? BlockTableViewController,
                let block = sender as? Block,
                let note = block.note,
                let folderType = note.folder?.folderType else { return }
            let state: BlockTableViewController.ViewControllerState =
                folderType != .deleted ?
                    .normal : .deleted
            vc.state = state
            vc.note = note
            vc.searchedBlock = block
            let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer
            vc.persistentContainer = persistentContainer
            let context = persistentContainer.viewContext
            let resultsController = context.blockResultsController(note: note)
            vc.resultsController = resultsController
            resultsController.delegate = vc
            
        }
    }
    
}

extension AttachListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = resultsController?.object(at: indexPath) else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachListCell") as! AttachListCell
        cell.configure(with: data, type: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let data = resultsController?.object(at: indexPath) else {return}
        performSegue(withIdentifier: "BlockNavigationController", sender: data)
    }
    
}
