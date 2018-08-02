//
//  NonPayedEmojiView.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 1..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class NonPayedEmojiView: UIView {
    
    weak var delegates: InputViewDelegates?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageConrol: UIPageControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subscriptButton: UIButton!
    @IBOutlet weak var learnLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var settingLabel: UILabel!
    
    @IBAction private func aHide() {delegates?.action("hide")}
    @IBAction private func aSubscript() {delegates?.action("subscript")}
    @IBAction private func aMore() {delegates?.action("more")}
    
}

extension NonPayedEmojiView {
    
    @IBAction private func aEmoji1(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji2(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji3(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji4(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji5(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji6(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji7(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji8(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji9(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji10(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji11(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji12(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji13(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji14(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji15(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    @IBAction private func aEmoji16(_ button: UIButton) {delegates?.action("\(button.title(for: .normal) ?? "")")}
    
}

extension NonPayedEmojiView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x / scrollView.bounds.width
        if offset.truncatingRemainder(dividingBy: 1) < 0.5 {
            pageConrol.currentPage = Int(offset)
        } else {
            pageConrol.currentPage = Int(offset + 1)
        }
    }
    
}
