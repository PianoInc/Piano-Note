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

    lazy var searchResultsDelegate: SearchResultsDelegate = {
        let delegate = SearchResultsDelegate()
        delegate.noteTableViewController = self
        delegate.resultsController = resultsController
        return delegate
    }()

    var resultsController: NSFetchedResultsController<Note>?
    internal var delayBlockQueue: [(NoteTableViewController) -> Void] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0(self) }
    }

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultsViewController)
        controller.searchResultsUpdater = self
        return controller
    }()

    lazy var searchResultsViewController: SearchResultsViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController {
            viewController.loadView()
            return viewController
        }
        return nil
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
        setupSearchViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let displayMode = splitViewController?.displayMode,
            displayMode == .allVisible {
            clearsSelectionOnViewWillAppear = false
        }
        super.viewWillAppear(animated)
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
        
        if let identifier = segue.identifier, identifier == "FilterSearchSplitViewController" {
            guard let vc = segue.destination as? UISplitViewController else { return }
            // FilterSearchSplitView
            vc.delegate = self
            vc.preferredDisplayMode = .allVisible
            vc.maximumPrimaryColumnWidth = 414
            vc.minimumPrimaryColumnWidth = 320
        } else if let identifier = segue.identifier, identifier == "BlockNavigationController" {
            guard let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? BlockTableViewController,
                let note = sender as? Note,
                let folderType = note.folder?.folderType else { return }
            
            let state: BlockTableViewController.ViewControllerState =
                folderType != .deleted ?
                        .normal : .deleted
            
            vc.state = state
            vc.note = note
            vc.persistentContainer = persistentContainer
            let context = persistentContainer.viewContext
            let resultsController = context.blockResultsController(note: note)
            vc.resultsController = resultsController
            resultsController.delegate = vc

            if let block = searchResultsDelegate.selectedBlock {
                vc.searchedBlock = block
            }
        } else if let identifier = segue.identifier, identifier == "AttachTypeTableViewController" {
            guard let vc = segue.destination as? AttachTypeTableViewController else {return}
            
            var types = [AttachType]()
            guard let notes = self.resultsController?.fetchedObjects else {return}
            for note in notes {
                guard let blocks = note.blockCollection else {continue}
                for block in blocks {
                    guard let block = block as? Block else {continue}
                    if block.address != nil && !types.contains(.address) {types.append(.address)}
                    if block.type == .checklistText && !types.contains(.checklist) {types.append(.checklist)}
                    if block.contact != nil && !types.contains(.contact) {types.append(.contact)}
                    if block.event != nil && !types.contains(.event) {types.append(.event)}
                    if block.link != nil && !types.contains(.link) {types.append(.link)}
                }
            }
            
            vc.notes = notes
            vc.types = types
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

extension NoteTableViewController : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
