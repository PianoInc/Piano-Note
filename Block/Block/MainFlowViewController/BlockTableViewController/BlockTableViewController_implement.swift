//
//  BlockTableViewController_implement.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension BlockTableViewController {
    
    internal func setCursor(position: CGPoint) {
        let indexPath = tableView.indexPathForRow(at: position)
    }
    
    internal func switchKeyboardIfNeeded(_ textView: UITextView) {
        
        if textView.text.count == 0 && textView.keyboardType == .default {
            textView.keyboardType = .twitter
            textView.reloadInputViews()
        } else if textView.text.count != 0 && textView.keyboardType == .twitter {
            textView.keyboardType = .default
            textView.reloadInputViews()
        }
    }
    
    internal func reactCellHeight(_ textView: UITextView) {
        let index = textView.text.count
        guard index > 0 else {
            tableView.performBatchUpdates(nil, completion: nil)
            return
        }
        
        let lastLineRect = textView.layoutManager.lineFragmentRect(forGlyphAt: index - 1, effectiveRange: nil)
        let textViewHeight = textView.bounds.height
        guard textView.layoutManager.location(forGlyphAt: index - 1).y == 0
            || textViewHeight - (lastLineRect.origin.y + lastLineRect.height) > 20 else {
                return
        }
        
        tableView.performBatchUpdates(nil, completion: nil)
        
        
    }
    
    internal func setTableViewOffSetIfNeeded(textView: UITextView) {
        //텍스트뷰 좌표계에서 커서 위치를 테이블 뷰로 이동시켜 판단
        
    }
    
    internal func presentAlertController(_ Block: Block, with URL: URL) {
        
    }
    
    internal func performAlertController(with: URL) {
        
    }
    
    internal func isCharacter(over: Int) -> Bool {
        return over > 10000
    }
    
}
