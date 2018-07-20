//
//  Converter.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 19..
//  Copyright © 2018년 piano. All rights reserved.
//

internal class Converter {
    
    internal func cloud(conflict record: ConflictRecord) {
        print("diff result :", diff(with: record))
    }
    
    private func diff(with record: ConflictRecord) -> String {
        guard let a = record.ancestor?.value(forKey: "text") as? String else {return ""}
        guard let s = record.server?.value(forKey: "text") as? String else {return ""}
        guard let c = record.client?.value(forKey: "text") as? String else {return ""}
        
        var result = c
        let diff3Maker = Diff3Maker(ancestor: a, a: c, b: s)
        let diff3Chunks = diff3Maker.mergeInLineLevel().flatMap { chunk -> [Diff3Block] in
            if case let .change(oRange, aRange, bRange) = chunk {
                let oString = (a as NSString).substring(with: oRange)
                let aString = (c as NSString).substring(with: aRange)
                let bString = (s as NSString).substring(with: bRange)
                
                let wordDiffMaker = Diff3Maker(ancestor: oString, a: aString, b: bString, separator: "")
                return wordDiffMaker.mergeInWordLevel(oOffset: oRange.lowerBound, aOffset: aRange.lowerBound, bOffset: bRange.lowerBound)
                
            } else if case let .conflict(oRange, aRange, bRange) = chunk {
                let oString = (a as NSString).substring(with: oRange)
                let aString = (c as NSString).substring(with: aRange)
                let bString = (s as NSString).substring(with: bRange)
                
                let wordDiffMaker = Diff3Maker(ancestor: oString, a: aString, b: bString, separator: "")
                return wordDiffMaker.mergeInWordLevel(oOffset: oRange.lowerBound, aOffset: aRange.lowerBound, bOffset: bRange.lowerBound)
            } else { return [chunk] }
        }
        
        var offset = 0
        diff3Chunks.forEach {
            switch $0 {
            case .add(let index, let range):
                let replacement = (s as NSString).substring(with: range)
                result.insert(contentsOf: replacement, at: c.index(c.startIndex, offsetBy: index+offset))
                offset += range.length
            case .delete(let range):
                let start = c.index(c.startIndex, offsetBy: range.location + offset)
                let end = c.index(c.startIndex, offsetBy: range.location + offset + range.length)
                result.removeSubrange(Range(uncheckedBounds: (lower: start, upper: end)))
                offset -= range.length
            case .change(_, let myRange, let serverRange):
                let replacement = (s as NSString).substring(with: serverRange)
                let start = c.index(c.startIndex, offsetBy: myRange.location + offset)
                let end = c.index(c.startIndex, offsetBy: myRange.location + offset + myRange.length)
                result.replaceSubrange(Range(uncheckedBounds: (lower: start, upper: end)), with: replacement)
                offset += serverRange.length - myRange.length
            default: break
            }
        }
        return result
    }
    
    internal func object(toRecord unit: ManagedUnit) -> ManagedUnit {
        guard let object = unit.object, let record = unit.record else {return unit}
        for key in object.entity.attributesByName.keys {
            let value = object.value(forKey: key)
            if key == "imageData" {
                record.setValue(createAsset(for: value), forKey: key)
            } else {
                guard key != KEY_RECORD_NAME, key != KEY_RECORD_DATA else {continue}
                record.setValue(value, forKey: key)
            }
        }
        return ManagedUnit(record: record, object: nil)
    }
    
    private func createAsset(for any: Any?)-> CKAsset? {
        let fileName = UUID().uuidString.lowercased() + ".jpg"
        let fullURL = URL(fileURLWithPath: fileName, relativeTo: FileManager.default.temporaryDirectory)
        do {
            guard let data = any as? Data else {return nil}
            try data.write(to: fullURL)
            return CKAsset(fileURL: fullURL)
        } catch {
            return nil
        }
    }
    
    internal func record(toObject unit: ManagedUnit) {
        guard let record = unit.record, let object = unit.object else {return}
        for key in record.allKeys() where !systemField(key) {
            if key == "imageData" {
                guard let asset = record.value(forKey: key) as? CKAsset else {continue}
                object.setValue(try? Data(contentsOf: asset.fileURL), forKey: key)
            } else {
                object.setValue(record.value(forKey: key), forKey: key)
            }
        }
    }
    
    private func systemField(_ key: String)-> Bool {
        return ["recordName", "createdBy", "createdAt",
                "modifiedBy", "modifiedAt", "changeTag"].contains(key)
    }
    
}
