//
//  PostDataSource.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

/// Facebook post 내용을 표기할 listView의 DataSource.
public class PostDataSource<Section: FacebookSectionCell, Row: FacebookRowCell>:
NSObject, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    private weak var listView: UITableView?
    private var estimatedHeight = [IndexPath : CGFloat]()
    
    private let facebookRequest = FacebookRequest()
    private var data = [PostData]()
    
    private var pageId = ""
    
    /// PostDataSource RowCell selection closure
    public var didSelectRowAt: ((PostData) -> ())?
    
    /**
     - parameter viewCtrl : ViewController context.
     - parameter listView : 결과를 attach하려는 tableView.
     - parameter pageId : 불러오려는 Facebook PageId.
     - parameter notReady : 로그인 실패시 호출.
     */
    public init(_ viewCtrl: UIViewController, listView: UITableView,
                pageId: String = "602234013303895", notReady: @escaping (() -> ())) {
        super.init()
        listView.delegate = self
        listView.dataSource = self
        listView.prefetchDataSource = self
        self.listView = listView
        self.pageId = pageId
        
        facebookRequest.postBinder = {self.initData($0 as! [PostData])}
        viewCtrl.facebookLogin { isReady in
            if isReady {
                self.facebookRequest.post(from: pageId)
            } else {
                notReady()
            }
        }
    }
    
    private func initData(_ rawData: [PostData]) {
        let offset = data.count
        for raw in rawData {
            if !data.contains {$0.time.group == raw.time.group} {
                var postData = raw
                postData.isSection = true
                data.append(postData)
            }
            if data.contains(where: {$0.time.group == raw.time.group}) {
                let index = data.reversed().index(where: {$0.time.group == raw.time.group})
                data.insert(raw, at: index!.hashValue)
            }
        }
        listView?.insertRows(at: data.enumerated().filter {offset <= $0.offset}.map {
            IndexPath(row: $0.offset, section: 0)
        }, with: .fade)
        
        guard let listView = listView, listView.bounds.height > listView.contentSize.height else {return}
        facebookRequest.post(from: pageId)
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
        let data = self.data[indexPath.row]
        if data.isSection {
            let section = tableView.dequeueReusableCell(withIdentifier: Section.reuseIdentifier) as! Section
            section.configure(data, shape: nil, at: indexPath)
            return section
        } else {
            let row = tableView.dequeueReusableCell(withIdentifier: Row.reuseIdentifier) as! Row
            row.configure(data, shape: shape(with: indexPath), at: indexPath)
            return row
        }
    }
    
    private func shape(with indexPath: IndexPath) -> PostRowShape {
        let key = data[indexPath.row].time.group
        let section = data.filter({$0.time.group == key}).dropFirst()
        let indexInSection = section.index(where: {return $0.id == data[indexPath.row].id})! - 1
        if section.count == 1 {
            return .single
        } else if indexInSection == 0 {
            return .top
        } else if indexInSection == section.count - 1 {
            return .bottom
        }
        return .middle
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        didSelectRowAt?(data[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndex = indexPaths.last?.row, lastIndex >= data.count - 1 else {return}
        facebookRequest.post(from: pageId)
    }
    
}
