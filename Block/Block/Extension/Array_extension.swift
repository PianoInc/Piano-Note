//
//  Array_extension.swift
//  Block
//
//  Created by JangDoRi on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension Array {
    
    func shifted(by shift: Int) -> Array<Element> {
        guard count > 0, (shift % count) != 0 else {return self}
        let moduleShift = shift % count
        let negativeShift = shift < 0
        let effectiveShift = negativeShift ? moduleShift + count : moduleShift
        let shift: (Int) -> Int = {$0 + effectiveShift >= self.count ? $0 + effectiveShift - self.count : $0 + effectiveShift}
        return self.enumerated().sorted(by: {shift($0.offset) < shift($1.offset)}).map { $0.element}
    }
    
}
