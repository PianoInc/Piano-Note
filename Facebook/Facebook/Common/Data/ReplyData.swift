//
//  ReplyData.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

/// Facebook의 reply data.
public struct ReplyData: FacebookData {
    
    public var data: [String : Any]
    /// ReplyData가 속하는 comment data의 id값.
    public var parentId: String
    /// ReplyData의 추가적인 request에서 다음 data 위치를 지시하는 cursor값.
    public var hasCursor: String!
    
}
