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
        return UITextInputMode.activeInputModes.first(where: {$0.primaryLanguage == "emoji"})
    }
    
}
