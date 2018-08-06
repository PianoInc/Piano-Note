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
    private var data: [String] {
        return ["", "", ""]
    }
    
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
        cell.titleLabel.text = "title"
        cell.contantLabel.text = "asdasdasdasdsdfaasdfsdfdsafdsafdsafdsfdsfsdfsfsafasfadsfasfsfsfasfadsfsdfdsfads"
        cell.dateLabel.text = "date"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

