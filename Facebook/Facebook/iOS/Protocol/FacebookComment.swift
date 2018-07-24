//
//  FacebookComment.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

import UIKit

public protocol FacebookCommentDelegate {}

public extension FacebookCommentDelegate where Self: UIViewController {
    
    func delegate(with tableView: UITableView, postData: PostData, _ notReady: @escaping (() -> ())) -> CommentDataSource<FacebookPostCell, FacebookCommentCell, FacebookReplyCell> {
        return CommentDataSource<FacebookPostCell, FacebookCommentCell, FacebookReplyCell>(self, listView: tableView, postData: postData, notReady: notReady)
    }
    
}

public extension FacebookCommentDelegate where Self: UITableViewController {
    
    func delegate(postData: PostData, _ notReady: @escaping (() -> ())) -> CommentDataSource<FacebookPostCell, FacebookCommentCell, FacebookReplyCell> {
        return CommentDataSource<FacebookPostCell, FacebookCommentCell, FacebookReplyCell>(self, listView: tableView, postData: postData, notReady: notReady)
    }
    
}
