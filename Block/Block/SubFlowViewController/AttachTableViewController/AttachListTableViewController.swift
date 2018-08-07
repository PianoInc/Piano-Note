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
    
}

extension AttachListTableViewController {
    
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
        print(indexPath)
    }
    
}
