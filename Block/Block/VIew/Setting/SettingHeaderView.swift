//
//  SettingHeaderView.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 7..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class SettingHeaderView: UIView {
    
    convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: width * 0.8))
        backgroundColor = .white
        guard let view = addSubviewIfNeeded(SettingHeaderDetailView.self) else {return}
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        layoutIfNeeded()
    }
    
}

class SettingHeaderDetailView: UIView {
    
    private var previousOffset: CGPoint = .zero
    
}


extension SettingHeaderDetailView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        let targetOffsetX = targetContentOffset.pointee.x + scrollView.bounds.width / 2
        var targetView: UIView? {
            return scrollView.subviews.first!.subviews.first {
                $0.frame.contains(CGPoint(x: targetOffsetX, y: $0.center.y))
            }
        }
        
        guard let candidateView = targetView else {
            targetContentOffset.pointee = previousOffset
            return
        }
        
        var candidateOffsetX = candidateView.center.x - scrollView.bounds.width / 2
        let limitOffsetX = candidateOffsetX - scrollView.contentOffset.x
        
        let viewSpacing: CGFloat = 10
        if (velocity.x < 0 && limitOffsetX > 0) || (velocity.x > 0 && limitOffsetX < 0) {
            let pageWidth = scrollView.bounds.width + viewSpacing
            candidateOffsetX += (velocity.x > 0) ? pageWidth : -pageWidth
        }
        
        previousOffset = CGPoint(x: candidateOffsetX, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = previousOffset
    }
    
}