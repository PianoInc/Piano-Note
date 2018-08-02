//
//  MarkTableViewCell.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 1..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class MarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upperLine: UIView!
    @IBOutlet weak var centerTitle: UILabel!
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var lowerLine: UIView!
    
    func configure(with title: String, index: Int) {
        reset()
        if index == 0 {
            centerTitle.text = title
        } else {
            if index != 5 {
                isUserInteractionEnabled = true
                backgroundColor = .white
                indicator.isHidden = false
            }
            if index == 6 {
                indicator.isHidden = true
                leftTitle.textColor = UIColor(hex6: "0079ff")
            }
            leftTitle.text = title
        }
        line(index)
    }
    
    private func reset() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        indicator.isHidden = true
        centerTitle.text = ""
        leftTitle.textColor = .black
        leftTitle.text = ""
        emoji.text = ""
    }
    
    private func line(_ index: Int) {
        switch index {
        case 1 ,2, 3:
            upperLine.isHidden = true
            lowerLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        case 4, 5, 6: upperLine.isHidden = true
        default: break
        }
        layoutIfNeeded()
    }
    
}
