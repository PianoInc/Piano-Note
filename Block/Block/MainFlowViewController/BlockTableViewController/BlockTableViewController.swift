//
//  BlockTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class BlockTableViewController: UITableViewController {
    
    //MARK: Data
    
    internal var persistentContainer: NSPersistentContainer!
    
    internal var state: ViewControllerState!
    internal var resultsController: NSFetchedResultsController<Block>?
    private var delayBlockQueue: [() -> Void] = []
    internal var selectedBlocks: [Block] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(for: state)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        

        //TODO: persistentContainer 가 nil이라는 건 preserve로 왔거나 splitView라는 말임, 따라서 할당해주고, prepare에서 하는 짓을 다시 해줘야함
        if persistentContainer == nil {
            
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0() }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? FolderPickerTableViewController, let barButtonItem = sender as? UIBarButtonItem {
            vc.popoverPresentationController?.barButtonItem = barButtonItem
            
        }
    }
    
    //MARK: layout을 업데이트 하기 위한 메서드.
    internal func update(indexPath: IndexPath, selectedRangeLocationOffset: Int?) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableDataAcceptable & TextBlockTableViewCell,
            let block = resultsController?.object(at: indexPath) else { return }
        
        var selectedRange = cell.ibTextView.selectedRange
        cell.data = block
        
        if let offset = selectedRangeLocationOffset {
            selectedRange.location += offset
        }
        
        cell.ibTextView.selectedRange = selectedRange
        
        
    }

}








