//
//  SettingTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    private var data: [String] {
        return ["setting_04".loc, "setting_05".loc, "setting_06".loc]
    }
    
    private var headerSize: CGFloat {
        let columnWidth = splitViewController?.primaryColumnWidth ?? 320
        return (columnWidth < 320) ? 320 : columnWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView = SettingHeaderView(size: headerSize)
        tableView.tableHeaderView = headerView
        guard let detailView = headerView.subView(SettingHeaderDetailView.self) else {return}
        detailView.trialSelected = {
            // TODO...
        }
        detailView.detailSelected = {
            self.performSegue(withIdentifier: "SettingSubscribeViewController", sender: $0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingDetailTableViewController" {
            guard let naviVC = segue.destination as? UINavigationController else {return}
            guard let detailVC = naviVC.topViewController as? SettingDetailTableViewController else {return}
            guard let type = sender as? String else {return}
            detailVC.type = type
            detailVC.navigationItem.title = type
        } else if segue.identifier == "SettingSubscribeViewController" {
            guard let subscribeVC = segue.destination as? SettingSubscribeViewController else {return}
            guard let type = sender as? Int else {return}
            subscribeVC.type = type
            subscribeVC.navigationItem.title = "setting_subscribe_00".loc
        }
        
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension SettingTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "SettingDetailTableViewController", sender: data[indexPath.row])
    }
    
}
