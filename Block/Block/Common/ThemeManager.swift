//
//  ColorManager.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 30..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

struct ThemeManager {
    
    enum ThemeType: Int64 {
        case normal = 0
        case sakura = 1
        case iceCream = 2
        case piano = 3
        case night = 4
    }
    
    let type: ThemeType
    
    init(type: ThemeType) {
        self.type = type
    }
    
    var backgroundImage: Image? {
        return Image(named: String(describing: type) + "BackgroundImage")
    }
    var unorderedListImage: Image? {
        return Image(named: String(describing: type) + "UnorderedListImage")
    }
    var uncheckImage: Image? {
        return Image(named: String(describing: type) + "UncheckImage")
    }
    var checkImage: Image? {
        return Image(named: String(describing: type) + "CheckImage")
    }
    
    var backgroundColor: Color {
        switch type {
        case .normal:
            return Color.white
        case .sakura:
            return Color.orange
        case .iceCream:
            return Color.green
        case .piano:
            return Color.white
        case .night:
            return Color.black
        }
    }
    
    var textColor: Color {
        switch type {
        case .normal:
            return .darkText
        case .sakura:
            return .darkText
        case .iceCream:
            return .darkText
        case .piano:
            return .darkText
        case .night:
            return .darkText
        }
    }
    
    var highlightColor: Color {
        switch type {
        case .normal:
            return Color.yellow.withAlphaComponent(0.5)
        case .sakura:
            return Color.yellow.withAlphaComponent(0.5)
        case .iceCream:
            return Color.yellow.withAlphaComponent(0.5)
        case .piano:
            return Color.yellow.withAlphaComponent(0.5)
        case .night:
            return Color.yellow.withAlphaComponent(0.5)
        }
    }
    
    var linkColor: Color {
        switch type {
        case .normal:
            return Color.cyan
        case .sakura:
            return Color.cyan
        case .iceCream:
            return Color.cyan
        case .piano:
            return Color.cyan
        case .night:
            return Color.cyan
        }
    }
}
