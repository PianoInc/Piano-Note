//
//  Detect.swift
//  Block
//
//  Created by JangDoRi on 2018. 7. 26..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

let DETECT_EVENT = "EVENT_" + UUID().uuidString
let DETECT_REMINDER = "REMINDER_" + UUID().uuidString
let DETECT_CONTACT = "CONTACT_" + UUID().uuidString
let DETECT_ADDRESS = "ADDRESS_" + UUID().uuidString
let DETECT_LINK = "LINK_" + UUID().uuidString

struct Event: Codable {
    var ranges: [NSRange]
}

struct Contact: Codable {
    var ranges: [NSRange]
}

struct Address: Codable {
    var ranges: [NSRange]
}

struct Link: Codable {
    var ranges: [NSRange]
}
