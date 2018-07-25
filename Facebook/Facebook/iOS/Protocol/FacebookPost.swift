//
//  FacebookPost.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

public protocol FacebookPostDelegate {}

public extension FacebookPostDelegate where Self: UIViewController {
    
    func delegate(with tableView: UITableView, _ notReady: @escaping (() -> ())) -> PostDataSource<FacebookSectionCell, FacebookRowCell> {
        return PostDataSource<FacebookSectionCell, FacebookRowCell>(self, listView: tableView, notReady: notReady)
    }
    
}

public extension FacebookPostDelegate where Self: UITableViewController {
    
    func delegate(_ notReady: @escaping (() -> ())) -> PostDataSource<FacebookSectionCell, FacebookRowCell> {
        return PostDataSource<FacebookSectionCell, FacebookRowCell>(self, listView: tableView, notReady: notReady)
    }
    
}
