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
            ibLabel.text = ""
            
            switch block.type {
            case .plainText:
                guard let plainTextBlock = block.plainTextBlock else { return }
                ibButton.isHidden = true
                ibLabel.isHidden = false
                
                
                let font = UIFont.preferredFont(forTextStyle: plainTextBlock.textStyle)
                ibTextView.font = font
                ibLabel.font = font
                ibTextView.text = plainTextBlock.text ?? ""
//                ibTextView.textStorage.replaceCharacters(in: NSMakeRange(0, ibTextView.textStorage.length),
//                                                              with: plainTextBlock.text ?? "")
                
                /*
                //이미지, json, detector은 전부 비동기
                DispatchQueue.global().async {
                    //
                }
                */
            case .checklistText:
                guard let checklistTextBlock = block.checklistTextBlock else { return }
                ibButton.isHidden = false
                ibLabel.isHidden = true
                
                
                let font = UIFont.preferredFont(forTextStyle: checklistTextBlock.textStyle)
                ibTextView.font = font
                ibLabel.font = font
                ibTextView.text = checklistTextBlock.text ?? ""
//                ibTextView.textStorage.replaceCharacters(in: NSMakeRange(0, ibTextView.textStorage.length),
//                                                              with: checklistTextBlock.text ?? "")
                self.ibButton.isSelected = checklistTextBlock.isSelected
                
                if let whitespaceStr = checklistTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        //TODO: 이거 제대로 실행되는 지 체크
                        self.whitespaceConstraint.constant = width
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
                
                ibButton.isHidden = true
                ibLabel.isHidden = false
                
                
                let font = UIFont.preferredFont(forTextStyle: orderedTextBlock.textStyle)
                ibTextView.font = font
                ibLabel.font = font
                ibTextView.text = orderedTextBlock.text ?? ""
//                ibTextView.textStorage.replaceCharacters(in: NSMakeRange(0, ibTextView.textStorage.length),
//                                                              with: orderedTextBlock.text ?? "")
                ibLabel.text = "\(orderedTextBlock.num)."
                
                if let whitespaceStr = orderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        self.whitespaceConstraint.constant = width
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
                
                ibButton.isHidden = true
                ibLabel.isHidden = false
                ibLabel.text = ""
                
                let font = UIFont.preferredFont(forTextStyle: unOrderedTextBlock.textStyle)
                ibTextView.font = font
                ibLabel.font = font
                ibTextView.text = unOrderedTextBlock.text ?? ""
//                ibTextView.textStorage.replaceCharacters(in: NSMakeRange(0, ibTextView.textStorage.length),
//                                                         with: unOrderedTextBlock.text ?? "")
                
                ibLabel.text = "•"  //TODO: 이거 나중에 얼마든지 바뀔 수 있기 때문에 리펙토링 할 것
                
                if let whitespaceStr = unOrderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        self.whitespaceConstraint.constant = width
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
