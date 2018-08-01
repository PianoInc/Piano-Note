//
//  CustomDisclosureIndicator.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 1..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class CustomDisclosureIndicator: UIView {
    
    @IBInspectable
    public var color: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let x = bounds.midX + 1.5
        let y = bounds.midY
        let R = CGFloat(4.5)
        
        context?.move(to: CGPoint(x: x-R, y: y-R))
        context?.addLine(to: CGPoint(x: x, y: y))
        context?.addLine(to: CGPoint(x: x-R, y: y+R))
        context?.setLineCap(.square)
        context?.setLineJoin(.miter)
        context?.setLineWidth(2)
        color.setStroke()
        context?.strokePath()
    }
    
}
