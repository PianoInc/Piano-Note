//
//  DrawingBlockTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class DrawingBlockTableViewCell: UITableViewCell {

    enum ViewState {
        case readWrite
        case readOnly
    }
    
    @IBOutlet weak var ibImageView: UIImageView!
    var state: ViewState = .readOnly
    
    
    
    @IBAction func tapEdit(_ sender: Any) {
    }
    @IBAction func tapThickness(_ sender: Any) {
    }
    @IBAction func tapFullScreen(_ sender: Any) {
        
    }
    
    @IBAction func tapColor(_ sender: Any) {
    }

}
