//
//  BlockTableViewController_TextViewDelegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

extension BlockTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateViews(for: .typing)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !isCharacter(over: 10000) else { return false }
        return moveCellIfNeeded(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reactCellHeight(textView)
        switchKeyboardIfNeeded(textView)
        formatTextIfNeeded(textView)
        //        setTableViewOffSetIfNeeded(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        //        presentAlertController(Block, with: URL)
        return true
    }
    
    internal func moveCellIfNeeded(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let block = (textView.superview?.superview as? TableDataAcceptable)?.data as? Block
            else { return true }
        
        switch typingSituation(textView, block: block, replacementText: text) {
        case .resetForm:
            replaceToPlain(block: block)
            
        case .movePrevious:
            movePrevious(block: block)
            return false
        case .stayCurrent:
            ()
        case .moveNext:
            ()
        }
        
        return true
    }
    
    enum TypingSituation {
        case resetForm
        case movePrevious
        case stayCurrent
        case moveNext
    }
    
    private func typingSituation(_ textView: UITextView, block: Block, replacementText text: String) -> TypingSituation {
        if textView.selectedRange == NSMakeRange(0, 0) && text.count == 0 {
            return block.hasFormat ? .resetForm : .movePrevious
        } else if textView.selectedRange == NSMakeRange(0, 0) && text == "\n" {
            return block.hasFormat ? .resetForm : .moveNext
        } else {
            return .stayCurrent
        }
    }
    
    
    
    private func formatTextIfNeeded(_ textView: UITextView) {
        //PlainTextBlock이 아니라면 이 작업을 할 필요가 없음.
        guard let block = (textView.superview?.superview as? TextBlockTableViewCell)?.data as? Block,
            let indexPath = resultsController?.indexPath(forObject: block),
            var bullet = PianoBullet(text: textView.text, selectedRange: textView.selectedRange) else { return }
        
        switch bullet.type {
        case .orderedlist:
            guard let num = Int(bullet.string),
                !bullet.isOverflow else { return }
            
            let correctNum = modifyNumIfNeeded(num, indexPath)
            bullet.string = "\(correctNum)"
            replacePlainWithOrdered(block: block, bullet: bullet)
            adjustAfterOrder(correctNum, indexPath)
            
        case .unOrderedlist:
            replacePlainWithUnOrdered(block: block, bullet: bullet)
        case .checkist:
            replacePlainWithCheck(block: block, bullet: bullet)
        }
    }
    
    private func modifyNumIfNeeded(_ num: Int, _ indexPath: IndexPath) -> Int64 {
        var indexPath = indexPath
        indexPath.row -= 1
        guard indexPath.row >= 0,
            let block = resultsController?
                .object(at: indexPath),
            let orderedTextBlock = block.orderedTextBlock else { return Int64(num) }
        return orderedTextBlock.num + 1
    }
    
    //CoreData 값 변경
    private func adjustAfterOrder(_ num: Int64, _ indexPath: IndexPath) {
        var indexPath = indexPath
        var num = num
        while true {
            indexPath.row += 1
            num += 1
            guard indexPath.row != resultsController?.sections?[0].numberOfObjects,
                let block = resultsController?.object(at: indexPath),
                let orderedTextBlock = block.orderedTextBlock,
                num != orderedTextBlock.num else { return }
            
            orderedTextBlock.num = num
            update(block: block, deletedFormatLength: nil)
        }
    }
    
}
