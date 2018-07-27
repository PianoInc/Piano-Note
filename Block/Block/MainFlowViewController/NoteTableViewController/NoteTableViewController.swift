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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = true
        updateViews(for: state)
        fetchData()
        
        //TODO: persistentContainer 가 nil이라는 건 preserve로 왔거나 splitView라는 말임, 따라서 할당해주고, prepare에서 하는 짓을 다시 해줘야함
        if persistentContainer == nil {
            
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
    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("NoteTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func save() {
        persistentContainer.viewContext.saveIfNeeded()
    }
}
