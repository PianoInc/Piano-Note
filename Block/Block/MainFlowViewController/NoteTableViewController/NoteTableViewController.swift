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

    var searchResults = [SearchResult]()

    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultsViewController)
        controller.searchResultsUpdater = self
        return controller
    }()

    lazy var searchResultsViewController: UITableViewController? = {
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

        setupSearchViewController()
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


extension NoteTableViewController: UISearchResultsUpdating {
    private func setupSearchViewController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        searchResultsViewController?.tableView.dataSource = self
        searchResultsViewController?.tableView.delegate = self
        searchResultsViewController?.tableView.rowHeight = UITableViewAutomaticDimension
        searchResultsViewController?.tableView.estimatedRowHeight = 140
        searchResultsViewController?.tableView.register(SearchResultSectionHeader.self, forHeaderFooterViewReuseIdentifier: "SearchResultSectionHeader")
        searchResultsViewController?.tableView.register(SearchResultSectionFooter.self, forHeaderFooterViewReuseIdentifier: "SearchResultSectionFooter")
    }

    struct SearchResult {
        let note: Note
        var arributedStrings: [NSAttributedString] = []
        // TODO: note identifier
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text,
            let notes = resultsController?.fetchedObjects,
            searchController.isActive else { return }

        searchResults = notes.map { convert(note: $0, with: keyword) }
            .filter { $0 != nil }
            .map { $0! }
        searchResultsViewController?.tableView.reloadData()
    }

    // 함수 이름 이상함
    private func convert(note: Note, with keyword: String) -> SearchResult? {
        guard let blocks = note.blockCollection?.allObjects as? [Block] else { return nil }
        var result = SearchResult(note: note, arributedStrings: [])

        for block in blocks {
            if let plain = block.plainTextBlock, let text = plain.text, text.contains(keyword) {
                let attributedString = NSAttributedString(string: text)
                // TODO: 하이라이트 해줘야 함.
                result.arributedStrings.append(attributedString)
            }
        }
        if result.arributedStrings.isEmpty {
            return nil
        }
        return result
    }
}
