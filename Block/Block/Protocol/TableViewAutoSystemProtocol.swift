//
//  Uniquable.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

/**
 클래스 이름 + 뷰 이름으로 identifier를 만들도록 정의
 */
protocol Uniquable {
    var identifier: String { get }
}

extension Uniquable {
    //Data 뒤에 Cell을 붙이면 뷰이다. 데이터와 뷰의 관계를 명확히 하고, 스토리보드에서 쉽게 identifier를 세팅하기 위함
    var identifier: String {
        return String(describing:type(of: self)) + "TableViewCell"
    }
    
}

/**
 dataSource 혹은 delegate에 대한 함수들을 정의
 */
protocol TableDatable: Uniquable {
    func didSelectItem(fromVC viewController: ViewController)
}

protocol TableDataAcceptable {
    var data: TableDatable? { get set }
}

protocol NoteTableDataAcceptable: TableDataAcceptable {
    var folder: Folder? { get set }
}
