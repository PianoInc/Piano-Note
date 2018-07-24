//
//  UITextView_delegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 23..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension TextView {
    func splitTextByCursor() -> (String, String) {
        let location = selectedRange.location
        let frontText = (text as NSString).substring(to: location)
        let behindText = (text as NSString).substring(from: location)
        return (frontText, behindText)
    }
}
