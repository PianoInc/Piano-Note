//
//  FacebookComment.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

public protocol FacebookCommentDelegate {}

public extension FacebookCommentDelegate where Self: UIViewController {
    
    /**
     Facebook comment / reply 내용을 표기할 tableView의 DataSource.
     - parameter tableView : Datasource를 attach 하고자하는 tableView.
     - parameter postData : Load 하고자 하는 comment들이 속하는 post의 data.
     - parameter notReady : Facebook login이 failed 일때 호출한다.
     */
    func delegate(with tableView: UITableView, postData: PostData, _ notReady: @escaping (() -> ())) {
        _ = CommentDataSource<FacebookPostCell, FacebookCommentCell, FacebookReplyCell>(self, listView: tableView, postData: postData, notReady: notReady)
    }
    
}

public extension FacebookCommentDelegate where Self: UITableViewController {
    
    
    /**
     Facebook comment / reply 내용을 표기할 tableView의 DataSource.
     - parameter postData : Load 하고자 하는 comment들이 속하는 post의 data.
     - parameter notReady : Facebook login이 failed 일때 호출한다.
     */
    func delegate(postData: PostData, _ notReady: @escaping (() -> ())) {
        _ = CommentDataSource<FacebookPostCell, FacebookCommentCell, FacebookReplyCell>(self, listView: tableView, postData: postData, notReady: notReady)
    }
    
}
