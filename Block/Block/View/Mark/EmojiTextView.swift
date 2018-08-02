//
//  EmojiTextView.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 2..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class EmojiTextView: UITextView {
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes where mode.primaryLanguage == "emoji" {
            return mode
        }
        return nil
    }
    
}
