//
//  CommentDataSource.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

/// Facebook comment / reply 내용을 표기할 listView의 DataSource.
public class CommentDataSource<Post: FacebookPostCell, Comment: FacebookCommentCell, Reply: FacebookReplyCell>:
NSObject, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private weak var listView: UITableView?
    private var estimatedHeight = [IndexPath : CGFloat]()
    
    private let facebookRequest = FacebookRequest()
    private var data = [FacebookData]()
    
    private var postData: PostData!
    
    /// CommentDataSource RowCell selection closure
    public var didSelectRowAt: ((FacebookData) -> ())?
    
    public init(_ viewCtrl: UIViewController, listView: UITableView,
                postData: PostData, notReady: @escaping (() -> ())) {
        super.init()
        listView.delegate = self
        listView.dataSource = self
        listView.prefetchDataSource = self
        self.listView = listView
        self.postData = postData
        
        facebookRequest.commentBinder = {self.initData($0)}
        facebookRequest.replyBinder = {self.initData($0)}
        viewCtrl.facebookLogin { isReady in
            if isReady {
                self.facebookRequest.comment(from: postData.id)
            } else {
                notReady()
            }
        }
    }
    
    private func initData(_ rawData: [FacebookData]) {
        if let rawData = rawData as? [CommentData] {
            let offset = data.count
            if data.count == 0 {data.append(postData)}
            for rData in rawData {data.append(rData)}
            listView?.insertRows(at: data.enumerated().filter {offset <= $0.offset}.map {
                IndexPath(row: $0.offset, section: 0)
            }, with: .fade)
            
            guard let listView = listView, listView.bounds.height > listView.contentSize.height else {return}
            facebookRequest.comment(from: postData.id)
        } else if let rawData = rawData as? [ReplyData] {
            var offset: Int?
            for rData in rawData {
                let index = data.reversed().index(where: {
                    $0.id == rData.parentId || $0 is ReplyData && ($0 as! ReplyData).parentId == rData.parentId
                })!.hashValue
                if offset == nil {offset = index}
                data.insert(rData, at: index)
            }
            let start = offset!
            let end = offset! + (rawData.count - 1)
            listView?.insertRows(at: (start...end).map {IndexPath(row: $0, section: 0)}, with: .fade)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        estimatedHeight[indexPath] = cell.bounds.height
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = estimatedHeight[indexPath] else {return UITableViewAutomaticDimension}
        return height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cData = data[indexPath.row] as? CommentData {
            let comment = tableView.dequeueReusableCell(withIdentifier: Comment.reuseIdentifier) as! Comment
            comment.configure(cData, shape: nil, at: indexPath)
            return comment
        } else if let rData = data[indexPath.row] as? ReplyData {
            let reply = tableView.dequeueReusableCell(withIdentifier: Reply.reuseIdentifier) as! Reply
            reply.configure(rData, shape: nil, at: indexPath)
            return reply
        } else {
            let post = tableView.dequeueReusableCell(withIdentifier: Post.reuseIdentifier) as! Post
            post.configure(data[indexPath.row], shape: nil, at: indexPath)
            return post
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        didSelectRowAt?(data[indexPath.row])
        if let cData = data[indexPath.row] as? CommentData {
            guard cData.hasReply else {return}
            var mcData = cData
            mcData.hasReply = false
            data[indexPath.row] = mcData
            tableView.reloadRows(at: [indexPath], with: .fade)
            facebookRequest.reply(from: cData.id)
        } else if let rData = data[indexPath.row] as? ReplyData {
            guard rData.hasCursor != nil else {return}
            var mrData = rData
            mrData.hasCursor = nil
            data[indexPath.row] = mrData
            tableView.reloadRows(at: [indexPath], with: .fade)
            facebookRequest.reply(from: rData.parentId, with: rData.hasCursor)
        }
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndex = indexPaths.last?.row, lastIndex >= data.count - 1 else {return}
        facebookRequest.comment(from: postData.id)
    }
    
}
