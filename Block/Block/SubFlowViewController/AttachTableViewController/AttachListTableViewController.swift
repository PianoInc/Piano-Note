//
//  AttachListTableViewController.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 6..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class AttachListTableViewController: UITableViewController {
    
    var type: AttachType!
    var data: [Block]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "attach_0\(type.rawValue + 2)".loc
    }
    
}

extension AttachListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachListCell") as! AttachListCell
        cell.configure(with: data[indexPath.row], type: type)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print(indexPath)
    }
    
}

