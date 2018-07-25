//
//  FolderTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 12..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class FolderTableViewCell: UITableViewCell, TableDataAcceptable {

    var data: TableDatable? {
        didSet {
            guard let folder = self.data as? Folder else { return }
            
            switch folder.folderType {
            case .all:
                imageView?.image = #imageLiteral(resourceName: "total")
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            case .custom:
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                imageView?.image = nil
            case .locked:
                imageView?.image = #imageLiteral(resourceName: "lock")
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            case .deleted:
                imageView?.image = #imageLiteral(resourceName: "delete")
                textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            }
            
            textLabel?.text = folder.name
            detailTextLabel?.text = "\(folder.noteCollection?.count ?? 0)"
        }
    }
}
