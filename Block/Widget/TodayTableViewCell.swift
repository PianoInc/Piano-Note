//
//  TodayTableViewCell.swift
//  Widget
//
//  Created by JangDoRi on 2018. 8. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var numberOfLines: Int {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: return 3
        default: return 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.numberOfLines = numberOfLines
    }
    
}
