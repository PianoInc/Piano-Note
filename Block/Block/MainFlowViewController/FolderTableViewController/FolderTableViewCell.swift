//
//  FolderTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 12..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell, TableDataAcceptable {

    var data: TableDatable? {
        didSet {
            guard let data = self.data as? Folder else { return }
            textLabel?.text = data.name
            
            switch data.folderType {
            case .all, .custom:
                textLabel?.textColor = .black
            case .locked:
                textLabel?.textColor = .blue
            case .deleted:
                textLabel?.textColor = .red
            }
        }
    }
    

}
