//
//  AttachTypeTableViewController.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 6..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

enum AttachType: Int {
    case address = 0
    case checklist = 1
    case contact = 2
    case event = 3
    case link = 4
}

class AttachTypeTableViewController: UITableViewController {
    
    private var data: [String] {return (0...4).map({"attach_0\($0)".loc})}
    
    var notes = [Note]()
    var types = [AttachType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "attach_05".loc
        ifDataEmpty()
    }
    
    private func ifDataEmpty() {
        guard types.isEmpty else {return}
        let emptyLabel = UILabel(frame: view.bounds)
        emptyLabel.backgroundColor = .white
        emptyLabel.textAlignment = .center
        emptyLabel.text = "attach_06".loc
        view.addSubview(emptyLabel)
        
        guard let naviFrame = navigationController?.navigationBar.frame else {return}
        guard let toolBarFrame = navigationController?.toolbar.frame else {return}
        emptyLabel.frame.size.height = toolBarFrame.minY - naviFrame.maxY
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let listVC = segue.destination as? AttachListTableViewController else {return}
        guard let row = sender as? Int, let type = AttachType(rawValue: row) else {return}
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Block> = Block.fetchRequest()
        
        request.fetchBatchSize = 20
        request.predicate = predicate(with: type)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Block.modifiedDate), ascending: false)]
        
        listVC.type = type
        listVC.navigationItem.title = "attach_0\(row)".loc
        listVC.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Attach_" + "attach_0\(row)".loc)
    }
    
    private func predicate(with type: AttachType) -> NSPredicate {
        switch type {
        case .address: return NSPredicate(format: "note IN %@ AND hasAddress == true", notes)
        case .checklist: return NSPredicate(format: "note IN %@ AND checklistTextBlock != nil", notes)
        case .contact: return NSPredicate(format: "note IN %@ AND hasContact == true", notes)
        case .event: return NSPredicate(format: "note IN %@ AND hasEvent == true", notes)
        case .link: return NSPredicate(format: "note IN %@ AND hasLink == true", notes)
        }
    }
    
}

extension AttachTypeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachTypeCell") as! AttachTypeCell
        cell.isUserInteractionEnabled = types.contains(AttachType(rawValue: indexPath.row)!)
        cell.titleLabel.alpha = cell.isUserInteractionEnabled ? 1 : 0.2
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "AttachListTableViewController", sender: indexPath.row)
    }
    
}
