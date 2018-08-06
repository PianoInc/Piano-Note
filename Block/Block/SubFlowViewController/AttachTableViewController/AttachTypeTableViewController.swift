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
    
    var notes = [Note]()
    var types = [AttachType]()
    
    private var data: [String] {
        var result = [String]()
        (2...6).forEach {result.append("attach_0\($0)".loc)}
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "attach_01".loc
        empty()
    }
    
    private func empty() {
        guard types.isEmpty else {return}
        let emptyLabel = UILabel(frame: view.bounds)
        emptyLabel.backgroundColor = .white
        emptyLabel.text = "No have any Attachments."
        view.addSubview(emptyLabel)
        guard let naviFrame = navigationController?.navigationBar.frame else {return}
        guard let toolBarFrame = navigationController?.toolbar.frame else {return}
        emptyLabel.frame.size.height = toolBarFrame.minY - naviFrame.maxY
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let listVC = segue.destination as? AttachListTableViewController else {return}
        guard let type = sender as? AttachType else {return}
        listVC.type = type
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
        performSegue(withIdentifier: "AttachListTableViewController", sender: AttachType(rawValue: indexPath.row))
    }
    
}
