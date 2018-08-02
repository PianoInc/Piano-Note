//
//  NonPayedEmojiView.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 1..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class NonPayedEmojiView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageConrol: UIPageControl!
    
    var closeSelected: (() -> ())?
    @IBAction private func dismiss() {closeSelected?()}
    
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
