//
//  Detect.swift
//  Block
//
//  Created by JangDoRi on 2018. 7. 26..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

let DETECT_LINK = UUID().uuidString

enum DetectType: String {
    case calendar = "calendar"
    case reminder = "reminder"
    case contact = "contact"
}

enum RecommandBarState {
    case calendar(title: String, startDate: Date)
    case reminder(title: String, date: Date)
    case contact(name: String, number: String)
    case pasteboard(NSAttributedString)
    case restore([(order: Int, Block: Block)])
}

public class Detect: NSObject {
    
    var type: DetectType
    var state: RecommandBarState
    var range: NSRange
    
    init(type: DetectType, state: RecommandBarState, range: NSRange) {
        self.type = type
        self.state = state
        self.range = range
    }
    
}
