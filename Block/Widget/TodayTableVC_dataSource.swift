//
//  TodayTableVC_dataSource.swift
//  Widget
//
//  Created by JangDoRi on 2018. 8. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableViewCell") as! TodayTableViewCell
        return cell
    }
    
}
