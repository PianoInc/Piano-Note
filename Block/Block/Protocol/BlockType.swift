//
//  BlockType.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

enum BlockType: Int64 {
    case plainText
    case orderedText
    case unOrderedText
    case checklistText
    case imageCollection
    case drawing
    case file
    case separator
    case imagePicker
    case comment
}
