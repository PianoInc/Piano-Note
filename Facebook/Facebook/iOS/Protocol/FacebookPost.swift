//
//  FacebookPost.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

public protocol FacebookPostDelegate {}

public extension FacebookPostDelegate where Self: UIViewController {
    
    /**
     Facebook post 내용을 표기할 tableView의 DataSource.
     - parameter tableView : Datasource를 attach 하고자 하는 tableView.
     - parameter notReady : Facebook login이 failed 일때 호출한다.
     - returns : PostDataSource()
     */
    func delegate(with tableView: UITableView, _ notReady: @escaping (() -> ())) -> PostDataSource<FacebookSectionCell, FacebookRowCell> {
        return PostDataSource<FacebookSectionCell, FacebookRowCell>(self, listView: tableView, notReady: notReady)
    }
    
}

public extension FacebookPostDelegate where Self: UITableViewController {
    
    /**
     Facebook post 내용을 표기할 tableView의 DataSource.
     - parameter notReady : Facebook login이 failed 일때 호출한다.
     - returns : PostDataSource()
     */
    func delegate(_ notReady: @escaping (() -> ())) -> PostDataSource<FacebookSectionCell, FacebookRowCell> {
        return PostDataSource<FacebookSectionCell, FacebookRowCell>(self, listView: tableView, notReady: notReady)
    }
    
}
