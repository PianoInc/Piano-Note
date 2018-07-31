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
    var state: ViewControllerState!

    var resultsController: NSFetchedResultsController<Note>?
    internal var delayBlockQueue: [(NoteTableViewController) -> Void] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0(self) }
    }

//    var searchController: UISearchController!
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultsController)
        return controller
    }()

    lazy var searchResultsController: UITableViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SearchResultsController") as? UITableViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        switch resultsController {
        case .none:
            let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            persistentContainer = container

        case .some(_):
            updateViews(for: state)
            asyncFetchData()
        }
        clearsSelectionOnViewWillAppear = true

        // setup seach controller
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(folder.objectID.uriRepresentation(), forKey: "folderURI")
        coder.encode(state.rawValue, forKey: "NoteTableViewControllerState")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let url = coder.decodeObject(forKey: "folderURI") as? URL,
            let decodeState = coder.decodeObject(forKey: "NoteTableViewControllerState") as? String,
            let id = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let folder = persistentContainer.viewContext.object(with: id) as? Folder {

            self.folder = folder
            state = ViewControllerState(rawValue: decodeState)
            resultsController = persistentContainer.viewContext.noteResultsController(folder: folder)
            resultsController?.delegate = self
            updateViews(for: state)
            syncFetchData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        save()
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
    private func asyncFetchData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("NoteTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
    }

    private func syncFetchData() {
        do {
            try self.resultsController?.performFetch()
        } catch {
            print("NoteTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    private func save() {
        persistentContainer.viewContext.saveIfNeeded()
    }
}


