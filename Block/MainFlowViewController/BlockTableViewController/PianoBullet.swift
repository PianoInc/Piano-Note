//
//  PianoBullet.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 18..
//  Copyright © 2018년 Piano. All rights reserved.
//
import Foundation

//TODO: Copy-on-Write 방식 책 보고 구현하기
public struct PianoBullet {
    
    public enum PianoBulletType: Int {
        case orderedlist
        case unOrderedlist
        case checkist
    }
    
    private let regexs: [(type: PianoBulletType, regex: String)] = [
        (.orderedlist, "^\\s*(\\d+)(?=\\. )"),
        (.unOrderedlist, "^\\s*([*])(?= )"),
        (.checkist, "^\\s*([-])(?= )")
    ]
    
    public let type: PianoBulletType
    public let whitespaces: (string: String, range: NSRange)
    public let string: String
    public let range: NSRange
    public let paraRange: NSRange
    
    
    public var baselineIndex: Int {
        return range.location + range.length + (type != .orderedlist ? 1 : 2)
    }
    
    public var isOverflow: Bool {
        return range.length > 20
    }
    
    public init?(text: String, selectedRange: NSRange) {
        let nsText = text as NSString
        let paraRange = nsText.paragraphRange(for: selectedRange)
        
        for (type, regex) in regexs {
            if let (string, range) = text.detect(searchRange: paraRange, regex: regex) {
                self.type = type
                self.string = string
                self.range = range
                let wsRange = NSMakeRange(paraRange.location, range.location - paraRange.location)
                let wsString = nsText.substring(with: wsRange)
                self.whitespaces = (wsString, wsRange)
                self.paraRange = paraRange
                return
            }
        }
        
        return nil
    }
    
    /*
     피아노를 위한 line 이니셜라이져
     */
    public init?(text: String, lineRange: NSRange) {
        
        let nsText = text as NSString
        guard nsText.length != 0 else { return nil }
        let paraRange = nsText.paragraphRange(for: lineRange)
        for (type, regex) in regexs {
            if let (string, range) = text.detect(searchRange: lineRange, regex: regex) {
                self.type = type
                self.string = string
                self.range = range
                let wsRange = NSMakeRange(paraRange.location, range.location - paraRange.location)
                let wsString = nsText.substring(with: wsRange)
                self.whitespaces = (wsString, wsRange)
                self.paraRange = paraRange
                return
            }
        }
        
        return nil
    }
    
    public func prevBullet(text: String) -> PianoBullet? {
        
        guard paraRange.location != 0 else { return nil }
        return PianoBullet(text: text, selectedRange: NSMakeRange(paraRange.location - 1, 0))
        
    }
    
    public func isSequencial(next: PianoBullet) -> Bool {
        
        guard let current = UInt(string),
            let next = UInt(next.string) else { return false }
        return current + 1 == next
        
    }
    
}

extension PianoBullet {
    
}

extension String {
    func detect(searchRange: NSRange, regex: String) -> (String, NSRange)? {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: .anchorsMatchLines)
            guard let result = regularExpression.matches(in: self, options: .withTransparentBounds, range: searchRange).first else { return nil }
            let range = result.range(at: 1)
            let string = (self as NSString).substring(with: range)
            return (string, range)
        } catch {
            print(error.localizedDescription)
        }
        return nil
        
    }
}
