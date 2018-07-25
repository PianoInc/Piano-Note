//
//  TextBlockType.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

protocol TextBlockType {
    var attributes: Data? { get set }
    var ckMetaData: Data? { get set }
    var createdDate: Date? { get set }
    var modifiedDate: Date? { get set }
    var recordName: String? { get set }
    var tagStr: String? { get set }
    var text: String? { get set }
    var textStyleInteger: Int64 { get set }
    var textStyle: FontTextStyle { get set }
    var blockCollection: NSSet? { get set }
    
    func addToBlockCollection(_ value: Block)
}

extension TextBlockType {
    var textStyle: FontTextStyle {
        get {
            switch textStyleInteger {
            case 0: return .body
            case 1: return .title1
            case 2: return .title2
            case 3: return .title3
            default: return .body
            }
        } set {
            switch newValue {
            case .body: textStyleInteger = 0
            case .title1: textStyleInteger = 1
            case .title2: textStyleInteger = 2
            case .title3: textStyleInteger = 3
            default: textStyleInteger = 0
            }
        }
    }
    
    var font: Font {
        get {
            if textStyle == .body {
                return Font.preferredFont(forTextStyle: .body)
            } else {
                return Font.preferredFont(forTextStyle: textStyle).bold()
            }
        }
    }
}
