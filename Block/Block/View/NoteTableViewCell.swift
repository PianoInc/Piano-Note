//
//  NoteTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell, NoteTableDataAcceptable {

    @IBOutlet weak var ibTitleLabel: UILabel!
    @IBOutlet weak var ibSubTitleLabel: UILabel!
    @IBOutlet weak var ibDateLabel: UILabel!
    @IBOutlet weak var ibFolderLabel: UILabel!
    
    var folder: Folder?
    
    var data: TableDatable? {
        didSet {
            guard let note = self.data as? Note else { return }
            
            ibTitleLabel.text = note.title
            ibSubTitleLabel.text = note.subTitle
            ibDateLabel.text = DateFormatter.sharedInstance.string(from: note.modifiedDate ?? Date())
            
            if let screenFolderType = folder?.folderType,
                screenFolderType == .all,
                let noteFolderType = note.folder?.folderType,
                noteFolderType == .custom {
                ibFolderLabel.isHidden = false
                ibFolderLabel.text = note.folder?.name ?? ""
            } else {
                ibFolderLabel.isHidden = true
            }
            
        }
    }

}
