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
    var data: [Data]?
    struct Data: Codable {
        let title: String?
        let date: Date
        let range: NSRange
    }
}

struct Contact: Codable {
    var data: [Data]?
    struct Data: Codable {
        let name: String?
        let number: String
        let range: NSRange
    }
}

struct Address: Codable {
    var data: [NSRange]?
}

struct Link: Codable {
    var data: [NSRange]?
}
