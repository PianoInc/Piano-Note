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
        //        switchKeyboardIfNeeded(textView)
        
        if state != .typing {
            updateViews(for: .typing)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        guard let cell = textView.superview?.superview as? TextBlockTableViewCell,
            let block = cell.data as? Block else { return }
        block.text = textView.text
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !isCharacter(over: 10000) else { return false }
        return moveCellIfNeeded(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reactCellHeight(textView)
        //        switchKeyboardIfNeeded(textView)
        formatTextIfNeeded(textView)
        //        setTableViewOffSetIfNeeded(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        //        presentAlertController(Block, with: URL)
        return true
    }
    
    internal func moveCellIfNeeded(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let block = (textView.superview?.superview as? TableDataAcceptable)?.data as? Block,
            let indexPath = resultsController?.indexPath(forObject: block)
            else { return true }
        
        switch typingSituation(textView, block: block, replacementText: text) {
        case .resetForm:
            block.revertToPlain()
            moveCursorForResetForm(in: indexPath)
            return false
        case .movePrevious:
            guard let resultsController = resultsController, indexPath.row > 0 else { return false }
            
            var indexPath = indexPath
            indexPath.row -= 1
            let previousBlock = resultsController.object(at: indexPath)
            
            if !previousBlock.isTextType {
                //TODO: 이미지, 파일, 등등의 타입이므로 해당 block을 지울 것인지 물어보는 얼럿 창을 띄워줘야함
                print("TODO: 이미지, 파일, 등등의 타입이므로 해당 block을 지울 것인지 물어보는 얼럿 창을 띄워줘야함")
                return false
            }
            
            moveCursorTo(previousBlock, prevIndexPath: indexPath)
            
            let text = textView.text ?? ""
            previousBlock.append(text: text)
            previousBlock.modifiedDate = Date()
            block.deleteWithRelationship()
            
            return false
        case .stayCurrent:
            return true
        case .moveNext:
            //TODO: 이렇게 되면 형광펜이 깨짐, attributed로 만들어야함
            let (frontText, behindText) = textView.splitTextByCursor()
            block.text = data(detector: frontText)
            block.modifiedDate = Date()
            block.insertNextBlock(with: behindText, on: resultsController)
            
            var indexPath = indexPath
            indexPath.row += 1
            let selectedRange = NSMakeRange(0, 0)
            cursorCache = (indexPath, selectedRange)
            
            return false
        }
    }
    
    enum TypingSituation {
        case resetForm
        case movePrevious
        case stayCurrent
        case moveNext
    }
    
    private func data(detector text: String) -> String {
        return text
    }
    
    private func typingSituation(_ textView: UITextView, block: Block, replacementText text: String) -> TypingSituation {
        
        if textView.selectedRange == NSMakeRange(0, 0) && text.count == 0 {
            //문단 맨 앞에 커서가 있으면서 백스페이스 눌렀을 때
            return block.hasFormat ? .resetForm : .movePrevious
        } else if textView.selectedRange == NSMakeRange(0, 0)
            && text == "\n" && block.hasFormat {
            //문단 맨 앞에 커서가 있으면서 개행을 눌렀고, 포멧이 있을 때
            return .resetForm
        } else if text == "\n" {
            //개행을 눌렀을 때
            return .moveNext
        } else {
            return .stayCurrent
        }
    }
    
}

extension BlockTableViewController {
    /**
     PlainTextBlock이 아니라면 이 작업을 할 필요가 없음.
     */
    private func formatTextIfNeeded(_ textView: UITextView) {
        guard let block = (textView.superview?.superview as? TextBlockTableViewCell)?.data as? Block,
            let bullet = PianoBullet(text: textView.text, selectedRange: textView.selectedRange),
            block.plainTextBlock != nil,
            let indexPath = resultsController?.indexPath(forObject: block) else { return }
        
        var selectedRange = textView.selectedRange
        textView.textStorage.replaceCharacters(in: NSMakeRange(0, bullet.baselineIndex), with: "")
        block.replacePlainWith(bullet, on: resultsController, selectedRange: &selectedRange)
        cursorCache = (indexPath, selectedRange)
    }
    
    private func moveCursorForResetForm(in indexPath: IndexPath) {
        let selectedRange = NSMakeRange(0, 0)
        cursorCache = (indexPath, selectedRange)
    }
    
    private func moveCursorTo(_ previousBlock: Block, prevIndexPath indexPath: IndexPath) {
        let selectedRange = NSMakeRange(previousBlock.text?.count ?? 0, 0)
        cursorCache = (indexPath, selectedRange)
    }
}
