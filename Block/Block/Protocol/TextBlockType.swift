//
//  TextBlockType.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 21..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

protocol TextBlockType {
    var highlightData: Data? { get set }
    var linkData: Data? { get set }
    var addressData: Data? { get set }
    var contactData: Data? { get set }
    var eventData: Data? { get set }
    var highlight: Highlight? { get set }
    var event: Event? { get set }
    var contact: Contact? { get set }
    var address: Address? { get set }
    var link: Link? { get set }
    var ckMetaData: Data? { get set }
    var createdDate: Date? { get set }
    var modifiedDate: Date? { get set }
    var recordName: String? { get set }
    var tagStr: String? { get set }
    var text: String? { get set }
    var textStyleInteger: Int64 { get set }
    var textStyle: FontTextStyle { get set }
    var blockCollection: NSSet? { get set }
    
    func addToBlockCollection(_ value: Block)
}

extension TextBlockType {
    
    var highlight: Highlight? {
        get {
            guard let highlightData = highlightData else { return nil }
            return try? JSONDecoder().decode(Highlight.self, from: highlightData)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            highlightData = data
        }
    }
    
    var event: Event? {
        get {
            guard let eventData = eventData else { return nil }
            return try? JSONDecoder().decode(Event.self, from: eventData)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            eventData = data
        }
    }
    
    var contact: Contact? {
        get {
            guard let contactData = contactData else { return nil }
            return try? JSONDecoder().decode(Contact.self, from: contactData)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            contactData = data
        }
    }
    
    var address: Address? {
        get {
            guard let addressData = addressData else { return nil }
            return try? JSONDecoder().decode(Address.self, from: addressData)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            addressData = data
        }
    }
    
    var link: Link? {
        get {
            guard let linkData = linkData else { return nil }
            return try? JSONDecoder().decode(Link.self, from: linkData)
        } set {
            let data = try? JSONEncoder().encode(newValue)
            linkData = data
        }
    }
    
    var textStyle: FontTextStyle {
        get {
            switch textStyleInteger {
            case 0: return .body
            case 1: return .title1
            case 2: return .title2
            case 3: return .title3
            default: return .body
            }
        } set {
            switch newValue {
            case .body: textStyleInteger = 0
            case .title1: textStyleInteger = 1
            case .title2: textStyleInteger = 2
            case .title3: textStyleInteger = 3
            default: textStyleInteger = 0
            }
        }
    }
    
    var font: Font {
        get {
            if textStyle == .body {
                return Font.preferredFont(forTextStyle: .body)
            } else {
                return Font.preferredFont(forTextStyle: textStyle).bold()
            }
        } set {
            switch newValue {
            case Font.preferredFont(forTextStyle: .body):
                textStyle = .body
                
            case Font.preferredFont(forTextStyle: .title1).bold():
                textStyle = .title1
                
            case Font.preferredFont(forTextStyle: .title2).bold():
                textStyle = .title2
                
            case Font.preferredFont(forTextStyle: .title3).bold():
                textStyle = .title3
            
            default:
                textStyle = .body
                
            }

        }
    }
}
