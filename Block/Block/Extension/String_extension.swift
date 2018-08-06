//
//  String_extension.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension String {
   
    var loc: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var dataDetector: Any? {
        let types: NSTextCheckingResult.CheckingType = [.date, .phoneNumber, .address, .link]
        let detector = try? NSDataDetector(types:types.rawValue)
        if let match = detector?.firstMatch(in: self, options: .reportCompletion, range: NSMakeRange(0, count)) {
            switch match.resultType {
            case .address: return match.addressComponents
            case .date: return match.date
            case .phoneNumber: return match.phoneNumber
            case .link: return match.url
            default: break
            }
        }
        return nil
    }
    
}
