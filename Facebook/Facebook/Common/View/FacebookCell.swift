//
//  FacebookCell.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

/// 해당 post cell이 group내에서 어떤 위치에 속하는가에 대한 type.
public enum PostRowShape {
    case single, top, middle, bottom
}

/// Facebook ListView에 사용될 public cell protocol.
public protocol FacebookCell {
    
    static var reuseIdentifier: String {get}
    /**
     DataSource로부터 다음 파라미터들의 정보를 전달받는다.
     - parameter item : 현재 cell이 가져야 하는 data.
     - parameter shape : Post의  RowCell이 가져야 하는 PostRowShape값.
     - parameter indexPath : 현재 cell의 indexPath값.
     */
    func configure(_ item: FacebookData, shape: PostRowShape?, at indexPath: IndexPath)
    
}

public extension FacebookCell {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
