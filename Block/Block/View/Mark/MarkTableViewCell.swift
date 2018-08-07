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
    @IBOutlet weak var keepSwitch: UISwitch!
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var lowerLine: UIView!
    
    func configure(with title: String, index: Int) {
        reset()
        line(index)
        if index == 0 || index == 5 {
            isUserInteractionEnabled = false
            backgroundColor = .clear
            if index == 0 {centerTitle.text = title}
        } else {
            leftTitle.text = title
            switch index {
            case 6:
                selectionStyle = .none
                keepSwitch.isHidden = false
            case 7: leftTitle.textColor = UIColor(hex6: "0079ff")
            default: indicator.isHidden = false
            }
        }
    }
    
    private func reset() {
        backgroundColor = .white
        indicator.isHidden = true
        centerTitle.text = ""
        leftTitle.textColor = .black
        leftTitle.text = ""
        emoji.text = ""
        keepSwitch.isHidden = true
    }
    
    private func line(_ index: Int) {
        switch index {
        case 1 ,2, 3, 6:
            upperLine.isHidden = true
            lowerLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        case 4, 5, 7: upperLine.isHidden = true
        default: break
        }
        layoutIfNeeded()
    }
    
    @IBAction private func action(keepSwitch: UISwitch) {
        print(keepSwitch.isOn)
    }
    
}
