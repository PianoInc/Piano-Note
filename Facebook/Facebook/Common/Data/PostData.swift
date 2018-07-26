//
//  PostData.swift
//  Facebook
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

/// Facebook의 post data.
public struct PostData: FacebookData {
    
    public var data: [String : Any]
    /// PostData가 section data인지의 여부.
    public var isSection: Bool
    
}
