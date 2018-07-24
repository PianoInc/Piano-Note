//
//  CommentData.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

/// Facebook의 comment data.
public struct CommentData: FacebookData {
    
    public var data: [String : Any]
    /// CommentData가 하위 replyData를 가지는지의 여부.
    public var hasReply: Bool
    /// CommentData가 가지는 reply data의 갯수.
    public var replyCount: Int {
        return data["comment_count"] as? Int ?? 0
    }
    
}
