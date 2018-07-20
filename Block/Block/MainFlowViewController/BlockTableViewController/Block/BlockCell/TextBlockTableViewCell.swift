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
    
    //default value = 16
    @IBOutlet weak var whitespaceConstraint: NSLayoutConstraint!
    
    
    
    var data: TableDatable? {
        didSet {
            guard let block = data as? Block else { return }
            whitespaceConstraint.constant = -16
            
            switch block.type {
            case .plainText:
                guard let plainTextBlock = block.plainTextBlock else { return }
                self.ibButton.isHidden = true
                self.ibLabel.isHidden = false
                self.ibLabel.text = ""
                
                self.ibTextView.font = plainTextBlock.textStyle.font
                self.ibLabel.font = plainTextBlock.textStyle.font
                self.ibTextView.text = plainTextBlock.text
                
                /*
                //이미지, json, detector은 전부 비동기
                DispatchQueue.global().async {
                    //
                }
                */
            case .checklistText:
                guard let checklistTextBlock = block.checklistTextBlock else { return }
                self.ibButton.isHidden = false
                self.ibLabel.isHidden = true
                self.ibLabel.text = ""
                
                self.ibTextView.font = checklistTextBlock.textStyle.font
                self.ibLabel.font = checklistTextBlock.textStyle.font
                self.ibTextView.text = checklistTextBlock.text
                self.ibButton.isSelected = checklistTextBlock.isSelected
                
                if let whitespaceStr = checklistTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : checklistTextBlock.textStyle.font]).width
                    self.whitespaceConstraint.constant += width
                }
                
                /*
                //이미지, json은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                */
                
            case .orderedText:
                guard let orderedTextBlock = block.orderedTextBlock else { return }
                
                ibButton.isHidden = true
                ibLabel.isHidden = false
                ibLabel.text = ""
                
                
                ibTextView.font = orderedTextBlock.textStyle.font
                ibLabel.font = orderedTextBlock.textStyle.font
                ibTextView.text = orderedTextBlock.text
                ibLabel.text = "\(orderedTextBlock.num)."
                
                if let whitespaceStr = orderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : orderedTextBlock.textStyle.font]).width
                    self.whitespaceConstraint.constant += width
                }
                
                /*
                //이미지, json은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                */
                
            case .unOrderedText:
                guard let unOrderedTextBlock = block.unOrderedTextBlock else { return }
                
                ibButton.isHidden = true
                ibLabel.isHidden = false
                ibLabel.text = ""
                
                ibTextView.font = unOrderedTextBlock.textStyle.font
                ibLabel.font = unOrderedTextBlock.textStyle.font
                ibTextView.text = unOrderedTextBlock.text
                ibLabel.text = "•"  //TODO: 이거 나중에 얼마든지 바뀔 수 있기 때문에 리펙토링 할 것
                
                if let whitespaceStr = unOrderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : unOrderedTextBlock.textStyle.font]).width
                    self.whitespaceConstraint.constant += width
                }
                
                /*
                 //이미지, json은 전부 비동기
                 DispatchQueue.main.async { [weak self] in
                 //TODO: JSON 로직
                 }
                 */
                
            default:
                ()
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
