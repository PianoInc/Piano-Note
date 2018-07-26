//
//  TextBlockTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class TextBlockTableViewCell: UITableViewCell, TableDataAcceptable {
    @IBOutlet weak var ibButton: UIButton!
    @IBOutlet weak var ibLabel: UILabel!
    @IBOutlet weak var ibTextView: BlockTextView!
    @IBOutlet weak var ibTextViewLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var ibButtonLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var ibLabelLeadingAnchor: NSLayoutConstraint!
    
    var data: TableDatable? {
        didSet {
            guard let block = data as? Block else { return }
            
            switch block.type {
            case .plainText:
                guard let plainTextBlock = block.plainTextBlock else { return }
                
                ibTextView.font = plainTextBlock.font
                ibTextView.text = plainTextBlock.text ?? ""
                ibTextViewLeadingAnchor.constant = 0
                /*
                //이미지, json, detector은 전부 비동기
                DispatchQueue.global().async {
                    //
                }
                */
            case .checklistText:
                guard let checklistTextBlock = block.checklistTextBlock else { return }
                ibLabel.isHidden = true
                ibButton.isHidden = false
                
                let font = checklistTextBlock.font
                ibTextView.font = font
                ibLabel.font = ibLabel.font.withSize(font.pointSize)
                ibTextView.text = checklistTextBlock.text ?? ""
                ibTextViewLeadingAnchor.constant = ibButton.frame.width + 8
                ibButtonLeadingAnchor.constant = 0
                ibLabelLeadingAnchor.constant = 0

                self.ibButton.isSelected = checklistTextBlock.isSelected
                
                if let whitespaceStr = checklistTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        ibTextViewLeadingAnchor.constant += width
                        ibButtonLeadingAnchor.constant += width
                        ibLabelLeadingAnchor.constant += width
                    }
                }
                
                /*
                //이미지, json은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                */
                
            case .orderedText:
                guard let orderedTextBlock = block.orderedTextBlock else { return }
                ibLabel.isHidden = false
                ibButton.isHidden = true
                
                let font = orderedTextBlock.font
                ibTextView.font = font
                ibLabel.font = ibLabel.font.withSize(font.pointSize)
                ibTextView.text = orderedTextBlock.text ?? ""
                ibLabel.text = "\(orderedTextBlock.num)."
                ibLabel.sizeToFit()
                ibTextViewLeadingAnchor.constant = ibLabel.frame.width + 8
                ibButtonLeadingAnchor.constant = 0
                ibLabelLeadingAnchor.constant = 0
                
                
                if let whitespaceStr = orderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        ibTextViewLeadingAnchor.constant += width
                        ibButtonLeadingAnchor.constant += width
                        ibLabelLeadingAnchor.constant += width
                    }
                }
                
                /*
                //이미지, json은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                */
                
            case .unOrderedText:
                guard let unOrderedTextBlock = block.unOrderedTextBlock else { return }
                ibLabel.isHidden = false
                ibButton.isHidden = true
                
                let font = unOrderedTextBlock.font
                ibTextView.font = font
                ibLabel.font = ibLabel.font.withSize(font.pointSize)
                ibTextView.text = unOrderedTextBlock.text ?? ""
                ibLabel.text = "•"  //TODO: 이거 나중에 얼마든지 바뀔 수 있기 때문에 리펙토링 할 것
                ibTextViewLeadingAnchor.constant = ibLabel.frame.width + 8
                ibButtonLeadingAnchor.constant = 0
                ibLabelLeadingAnchor.constant = 0
                
                
                if let whitespaceStr = unOrderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        ibTextViewLeadingAnchor.constant += width
                        ibButtonLeadingAnchor.constant += width
                        ibLabelLeadingAnchor.constant += width
                    }
                }
                
                /*
                 //이미지, json은 전부 비동기
                 DispatchQueue.main.async { [weak self] in
                 //TODO: JSON 로직
                 }
                 */
                
            default:
                print("cannot invoked")
            }
        }
    }
        
    @IBAction func tapButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let block = data as? Block,
            let checklistTextBlock = block.checklistTextBlock else { return }
        checklistTextBlock.isSelected = sender.isSelected
    }
    
}
