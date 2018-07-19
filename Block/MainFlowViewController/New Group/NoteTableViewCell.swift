//
//  NoteTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell, TableDataAcceptable {

    @IBOutlet weak var ibTitleLabel: UILabel!
    @IBOutlet weak var ibDateLabel: UILabel!
    @IBOutlet weak var ibFolderLabel: UILabel!
    
    
    var data: TableDatable? {
        didSet {
            guard let data = self.data as? Note else { return }
            
            ibTitleLabel.text = data.title
            ibDateLabel.text = DateFormatter.sharedInstance.string(from: data.modifiedDate ?? Date())
            ibFolderLabel.text = data.folder?.folderType != .all ? data.folder?.name : ""
        }
    }

}
