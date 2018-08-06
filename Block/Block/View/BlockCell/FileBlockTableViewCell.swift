//
//  FileBlockTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class FileBlockTableViewCell: UITableViewCell {
    @IBOutlet weak var ibImageView: UIImageView!
    @IBOutlet weak var ibTitleLabel: UILabel!
    @IBOutlet weak var ibSizeLabel: UILabel!
    @IBOutlet weak var ibDateLabel: UILabel!
 
    @IBAction func tapShare(_ sender: Any) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
