//
//  String.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 10..
//

internal extension String {
    
    /// 해당 string과 동일한 id의 LocalizedString을 반환한다.
    internal var loc: String {
        guard let bundle = Bundle(identifier: "com.piano.Cloud-iOS") else {return ""}
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: self)
    }
    
}
