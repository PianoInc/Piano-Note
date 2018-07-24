//
//  FacebookData.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

import Foundation

/// Facebook의 data type protocol.
public protocol FacebookData {
    
    /// Facebook JSON data.
    var data: [String : Any] {get set}
    /// 이 data의 id값.
    var id: String {get}
    /// 이 data를 page관리자가 작성했는지의 여부를 반환한다.
    var isAdmin: Bool {get}
    /// 이 data의 message값.
    var message: String {get}
    /// 이 data의 time값. (ISO8601)
    var time: Date {get}
    
}

public extension FacebookData {
    
    public var id: String {
        return data["id"] as? String ?? ""
    }
    public var isAdmin: Bool {
        return data["from"] as? [String : Any] != nil
    }
    public var message: String {
        return data["message"] as? String ?? ""
    }
    public var time: Date {
        guard let create = data["created_time"] as? String else {return Date()}
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate, .withTime, .withColonSeparatorInTime]
        if let date = formatter.date(from: create) {return date}
        return Date()
    }
    
}
