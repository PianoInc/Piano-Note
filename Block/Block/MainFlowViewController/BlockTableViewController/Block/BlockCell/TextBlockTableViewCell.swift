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
    weak var BlockTableViewController: BlockTableViewController?
    
    
    var data: TableDatable? {
        didSet {
            guard let block = data as? Block else { return }
            
            switch block.type {
            case .plainText:
                guard let plainTextBlock = block.plainTextBlock else { return }
                ibButton.isHidden = true
                ibLabel.isHidden = false
                ibLabel.text = ""
                
                ibTextView.font = plainTextBlock.textStyle.font
                ibLabel.font = plainTextBlock.textStyle.font
                ibTextView.text = plainTextBlock.text
                
                //이미지, json, detector은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                
            case .checklistText:
                guard let checklistTextBlock = block.checklistTextBlock else { return }
                ibButton.isHidden = false
                ibLabel.isHidden = true
                ibLabel.text = ""
                
                
                
                ibTextView.font = checklistTextBlock.textStyle.font
                ibLabel.font = checklistTextBlock.textStyle.font
                ibTextView.text = checklistTextBlock.text
                ibButton.isSelected = checklistTextBlock.isSelected
                
                //이미지, json은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                
                
            case .orderedText:
                guard let orderedTextBlock = block.orderedTextBlock else { return }
                
                ibButton.isHidden = true
                ibLabel.isHidden = false
                ibLabel.text = ""
                
                
                ibTextView.font = orderedTextBlock.textStyle.font
                ibLabel.font = orderedTextBlock.textStyle.font
                ibTextView.text = orderedTextBlock.text
                ibLabel.text = "\(orderedTextBlock.num)." 
                
                //이미지, json은 전부 비동기
                DispatchQueue.main.async { [weak self] in
                    //TODO: JSON 로직
                }
                
            default:
                ()
            }
        }
    }
        
    @IBAction func tapButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
