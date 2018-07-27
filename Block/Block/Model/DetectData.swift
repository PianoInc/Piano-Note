//
//  Detect.swift
//  Block
//
//  Created by JangDoRi on 2018. 7. 26..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

let DETECT_LINK = UUID().uuidString

struct Event: Codable {
    let data: [Data]?
    struct Data: Codable {
        let title: String?
        let date: Date
        let range: NSRange
    }
}

struct Contact: Codable {
    let data: [Data]?
    struct Data: Codable {
        let name: String?
        let number: String
        let range: NSRange
    }
}

struct Address: Codable {
    let data: [NSRange]?
}

struct Link: Codable {
    let data: [NSRange]?
}
