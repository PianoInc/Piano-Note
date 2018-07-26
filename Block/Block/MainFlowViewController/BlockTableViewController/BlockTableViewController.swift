//
//  BlockTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class BlockTableViewController: UIViewController {
    
    //MARK: Data
    
    @IBOutlet weak var tableView: UITableView!
    internal var persistentContainer: NSPersistentContainer!
    
    internal var state: ViewControllerState!
    internal var note: Note!
    internal var resultsController: NSFetchedResultsController<Block>?
    private var delayBlockQueue: [() -> Void] = []
    internal var selectedBlocks: [Block] = []
    internal var cursorCache: (indexPath: IndexPath, selectedRange: NSRange)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(for: state)
        fetchData()
        setupTableView()

        //TODO: persistentContainer 가 nil이라는 건 preserve로 왔거나 splitView라는 말임, 따라서 할당해주고, prepare에서 하는 짓을 다시 해줘야함
        if persistentContainer == nil {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unRegisterKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setNoteTitle()
        save()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0() }
        
        let count = resultsController?.sections?.first?.numberOfObjects ?? 0
        if count == 0 {
            tapBackground("firstWriting")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? FolderPickerTableViewController, let barButtonItem = sender as? UIBarButtonItem {
            vc.popoverPresentationController?.barButtonItem = barButtonItem
            
        }
    }
}


extension BlockTableViewController {
    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("BlockTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
    }
    
    private func setNoteTitle() {
        
        if let resultsController = resultsController,
            let count = resultsController.sections?.first?.numberOfObjects,
            count > 0 {
            
            for i in 0 ..< count {
                let indexPath = IndexPath(row: i, section: 0)
                let block = resultsController.object(at: indexPath)
                if block.isTextType {
                    note.title = block.text
                    break
                }
            }
        }
    }
    
    private func setupTableView(){
        tableView.contentInset = tableViewInset
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
    }
    
    private func save() {
        persistentContainer.viewContext.saveIfNeeded()
    }
}





