//
//  FormatTextBlockType.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

protocol BulletTextBlockType: TextBlockType {
    var frontWhitespaces: String? { get set }
    var key: String? { get set }
    var num: Int64 { get set }
}
