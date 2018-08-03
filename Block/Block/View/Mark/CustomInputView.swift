//
//  CustomInputView.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 2..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol InputViewDelegates: NSObjectProtocol {
    func action(_ data: String)
}

enum InputViewType {
    case nonPayed, payed
}

let EMOJI_GUIDE = "EMOJI_GUIDE"

class CustomInputView: UIView, InputViewDelegates {
    
    weak var delegates: MarkDelegates?
    
    private var inputHeight: CGFloat {
        let isPort = UIApplication.shared.statusBarOrientation.isPortrait
        let maxSize = [UIScreen.main.bounds.width, UIScreen.main.bounds.height].max()
        switch maxSize {
        case 568, 667: return isPort ? 216 : 162 // 5~8
        case 736: return isPort ? 226 : 162 // 8+
        case 812: return isPort ? 291 : 171 // x
        case 1024, 1112: return isPort ? 265 : 353 // pad~pad pro 10.5
        default /*(1366)*/: return isPort ? 328 : 423 // pad pro 12.9
        }
    }
    
    convenience init(_ type: InputViewType) {
        self.init(frame: .zero)
        backgroundColor = .white
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: inputHeight)
        
        let nib = Nib(nibName: "NonPayedEmojiView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? NonPayedEmojiView else {return}
        view.delegates = self
        view.type = type
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        layoutIfNeeded()
        
        guard !UserDefaults.standard.bool(forKey: EMOJI_GUIDE), type == .payed else {return}
        let offset = CGPoint(x: view.scrollView.bounds.width * 2, y: 0)
        view.scrollView.setContentOffset(offset, animated: false)
        UserDefaults.standard.set(true, forKey: EMOJI_GUIDE)
    }
    
    func action(_ data: String) {
        delegates?.action(data)
    }
    
}