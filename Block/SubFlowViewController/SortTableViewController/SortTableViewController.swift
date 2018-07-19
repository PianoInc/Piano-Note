//
//  SortTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    weak var noteTableVC: NoteTableViewController?
    lazy var selectedIndexPath: IndexPath = {
//        let row = Int(noteTableVC?.folder.sortTypeInteger ?? 0)
        return IndexPath(row: 0, section: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.delegate?.tableView!(tableView, didSelectRowAt: selectedIndexPath)
    }


    
    @IBAction func tapDone(_ sender: Any) {
        
//        let sortTypeInteger = Int16(selectedIndexPath.row)
//        if noteTableVC?.folder.sortTypeInteger != sortTypeInteger {
//            noteTableVC?.delayBlockQueue.append({ (noteTableVC) in
//                noteTableVC.folder.sortTypeInteger = sortTypeInteger
//                //TODO: 폴더 값 변경했으니 디스크에 저장해줘야함
//                noteTableVC.resultsController = CoreData.sharedInstance.createNoteResultsController(folder: noteTableVC.folder)
//                noteTableVC.performFetchAndReload(noteTableVC.resultsController)
//            })
//        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
}

extension SortTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.delegate?.tableView!(tableView, didDeselectRowAt: selectedIndexPath)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
        
        selectedIndexPath = indexPath
        
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
    
}
