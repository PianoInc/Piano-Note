//
//  SettingDetailTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class SettingDetailTableViewController: UITableViewController {
    
    var type: String!
    private var data: [String] {
        switch type {
        case "setting_04".loc: return (0...7).map {"setting_typing_0\($0)".loc}
        case "setting_05".loc: return (0...2).map {"setting_app_0\($0)".loc}
        case "setting_06".loc: return ["setting_notification_00".loc]
        default: return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad :", type, data)
    }
    
}

extension SettingDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingDetailTableViewCell") as! SettingDetailTableViewCell
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
    
}
