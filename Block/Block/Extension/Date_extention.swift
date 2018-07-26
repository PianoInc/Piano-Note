//
//  Date_extention.swift
//  Block
//
//  Created by JangDoRi on 2018. 7. 26..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension Date {
    
    var isoString: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate, .withTime, .withColonSeparatorInTime]
        return formatter.string(from: self)
    }
    
}
