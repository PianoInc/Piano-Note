//
//  SettingTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    private var data: [[String : [String]]] {
        return [["Typing" : ["Improve Typing Speed", "Text Size and Width"]]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = SettingHeaderView(width: splitViewController?.primaryColumnWidth ?? 414)
        tableView.register(Nib(nibName: "SettingTableViewHeader", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "SettingTableViewHeader")
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension SettingTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].values.first?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingTableViewHeader") as! SettingTableViewHeader
        header.headerLabel.text = data[section].keys.first
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.titleLabel.text = data[indexPath.section].values.first?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "SettingDetailTableViewController", sender: nil)
    }
    
}
