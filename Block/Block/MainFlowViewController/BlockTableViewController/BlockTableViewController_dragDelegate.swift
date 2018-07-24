//
//  BlockTableViewController_dragDelegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 20..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import MobileCoreServices

extension BlockTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let state = self.state, state == .normal else { return [] }
        
        
        //TODO: 여기서 이미지일 수도 있으니 보완해야함
        guard let title = resultsController?.object(at: indexPath).text else { return [] }
        let data = title.data(using: .utf8)
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { (completion) in
            completion(data, nil)
            return nil
        }
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
}
