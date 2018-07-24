//
//  FacebookRequest.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

typealias FacebookBinder = ([FacebookData]) -> ()

/// Facebook Page에서 Post, Comment, Reply등의 정보를 요청할 수 있다.
class FacebookRequest: NSObject {
    
    /**
     한번에 호출할 data의 갯수
     - warning : 15 이하로 설정시 Graph API의 data cursor가 비정상적으로 작동할 가능성이 있음.
     */
    private let capacity = "25"
    
    /// 추가적인 request에서 다음 data 위치를 지시하는 cursor값.
    private var postCursor: String? = ""
    private var commentCursor: String? = ""
    
    /// Request에 사용할 serial dispatch queue.
    private var dispatch = DispatchQueue(label: "FacebookRequest")
    
    // FacebookData들의 data binder.
    var postBinder: FacebookBinder?
    var commentBinder: FacebookBinder?
    var replyBinder: FacebookBinder?
    
    /**
     해당 page id의 post data를 request한다.
     - parameter pageId : 요청하고자 하는 facebook page id.
     */
    func post(from pageId: String) {
        guard self.postCursor != nil else {return}
        dispatch.async {
            let param = ["fields" : "created_time, name, message, from, comments.limit(1){id}",
                         "limit" : self.capacity, "after" : self.postCursor!]
            let request = FBSDKGraphRequest(graphPath: "/\(pageId)/posts", parameters: param)
            request!.start { (_, result, _) in
                guard let result = result else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {return}
                guard let json = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any] else {return}
                guard let data = json?["data"] as? [[String: Any]] else {return}
                
                self.postCursor = nil
                if let paging = json?["paging"] as? [String: Any], let next = paging["next"] as? String {
                    self.postCursor = String(next[next.index(lastOf: "=")...])
                }
                
                let loadData = data.filter({
                    return $0["name"] as? String != nil && $0["message"] as? String != nil &&
                        $0["comments"] as? [String: Any] != nil
                }).map {PostData(data: $0, isSection: false)}
                
                if !loadData.isEmpty {
                    DispatchQueue.main.async {self.postBinder?(loadData)}
                } else {
                    self.post(from: pageId)
                }
            }
        }
    }
    
    /**
     해당 post id의 comment data를 request한다.
     - parameter postId : 요청하고자 하는 facebook post id.
     */
    func comment(from postId: String) {
        guard self.commentCursor != nil else {return}
        dispatch.async {
            let param = ["fields" : "id, created_time, message, comment_count, from",
                         "limit" : self.capacity, "after" : self.commentCursor!]
            let request = FBSDKGraphRequest(graphPath: "/\(postId)/comments", parameters: param)
            request!.start { (_, result, _) in
                guard let result = result else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {return}
                guard let json = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any] else {return}
                guard let data = json?["data"] as? [[String: Any]] else {return}
                
                self.commentCursor = nil
                if let paging = json?["paging"] as? [String: Any], let next = paging["next"] as? String {
                    self.commentCursor = String(next[next.index(lastOf: "=")...])
                }
                
                let loadData = data.map {
                    CommentData(data: $0, hasReply: $0["comment_count"]as? String != "0")
                }
                
                if !loadData.isEmpty {
                    DispatchQueue.main.async {self.commentBinder?(loadData)}
                } else {
                    self.comment(from: postId)
                }
            }
        }
    }
    
    /**
     해당 comment id의 reply data를 request한다.
     - parameter commentId : 요청하고자 하는 facebook comment id.
     - parameter after : reply data 위치를 지시하는 cursor값.
     */
    func reply(from commentId: String, with after: String? = "") {
        guard let after = after else {return}
        dispatch.async {
            let param = ["fields" : "created_time, message, from",
                         "limit" : self.capacity, "after" : after]
            let request = FBSDKGraphRequest(graphPath: "/\(commentId)/comments", parameters: param)
            request!.start { (_, result, _) in
                guard let result = result else {return}
                guard let resultData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {return}
                guard let json = try? JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: Any] else {return}
                guard let data = json?["data"] as? [[String: Any]] else {return}
                
                var nextCursor: String! = nil
                if let paging = json?["paging"] as? [String: Any], let next = paging["next"] as? String {
                    nextCursor = String(next[next.index(lastOf: "=")...])
                }
                
                let loadData = data.enumerated().map { (index, rRata) -> ReplyData in
                    if index == data.count - 1 {
                        return ReplyData(data: rRata, parentId: commentId, hasCursor: nextCursor)
                    } else {
                        return ReplyData(data: rRata, parentId: commentId, hasCursor: nil)
                    }
                }
                
                if !loadData.isEmpty {
                    DispatchQueue.main.async {self.replyBinder?(loadData)}
                } else {
                    self.reply(from: commentId, with: nextCursor)
                }
            }
        }
    }
    
}
