//
//  String.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 23..
//  Copyright © 2018년 piano. All rights reserved.
//

import Foundation

internal extension String {
    
    /// 해당 string과 동일한 id의 LocalizedString을 반환한다.
    internal var loc: String {
        #if os(iOS)
        if let bundle_iOS = Bundle(identifier: "com.piano.Facebook-iOS") {
            return NSLocalizedString(self, tableName: nil, bundle: bundle_iOS, value: self, comment: self)
        }
        #elseif os(OSX)
        if let bundle_Mac = Bundle(identifier: "com.piano.Facebook-Mac") {
            return NSLocalizedString(self, tableName: nil, bundle: bundle_Mac, value: self, comment: self)
        }
        #endif
        return ""
    }
    
    /**
     뒤에서부터 찾고자 하는 string의 index를 반환한다.
     - parameter lastOf : 찾고자 하는 string.
     - returns : 찾고자 하는 string의 index값.
     */
    internal func index(lastOf: String) -> String.Index {
        if let range = range(of: lastOf, options: .backwards, range: nil, locale: nil) {
            return range.upperBound
        }
        return startIndex
    }
    
}
