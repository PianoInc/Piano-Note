//
//  NonPayedEmojiView.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 1..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class NonPayedEmojiView: UIView {
    
    var closeSelected: (() -> ())?
    @IBAction private func dismiss() {closeSelected?()}
    
}
