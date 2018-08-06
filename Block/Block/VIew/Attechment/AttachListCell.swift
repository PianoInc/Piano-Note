//
//  AttachListCell.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 6..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class AttachListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with block: Block, type: AttachType) {
        titleLabel.text = block.note?.title
        
        let mAttStr = NSMutableAttributedString(string: block.text ?? "")
        switch type {
        case .address: guard let ranges = block.address?.ranges else {return}
        ranges.forEach {mAttStr.addAttributes([.foregroundColor : UIColor(hex6: "0079ff")], range: $0)}
        case .contact: guard let ranges = block.contact?.ranges else {return}
        ranges.forEach {mAttStr.addAttributes([.foregroundColor : UIColor(hex6: "0079ff")], range: $0)}
        case .event: guard let ranges = block.event?.ranges else {return}
        ranges.forEach {mAttStr.addAttributes([.foregroundColor : UIColor(hex6: "0079ff")], range: $0)}
        case .link: guard let ranges = block.link?.ranges else {return}
        ranges.forEach {mAttStr.addAttributes([.foregroundColor : UIColor(hex6: "0079ff")], range: $0)}
        default: break
        }
        contentLabel.attributedText = mAttStr
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M. dd"
        dateLabel.text = formatter.string(from: block.modifiedDate ?? Date())
    }
    
}
