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
    internal var resultsController: NSFetchedResultsController<Block>?
    private var delayBlockQueue: [() -> Void] = []
    internal var selectedBlocks: [Block] = []
    internal var cursorCache: (indexPath: IndexPath, selectedRange: NSRange)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(for: state)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
//        tableView.dragDelegate = self
//        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("NoteResultsController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
        

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

    @IBAction func tapBackground(_ sender: Any) {
        //Todo: 텍스트 맨 밑에 터치했을 때 마지막 셀이 텍스트 셀이 아니라면, 셀 생성하여 커서 띄우고, 텍스트 셀이라면 맨 마지막에 커서 띄우기
    }
}








