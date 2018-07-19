//
//  Util.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 11..
//  Copyright © 2018년 piano. All rights reserved.
//

public class Util {
    
    public func createAsset(for any: Any)-> CKAsset? {
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
    
}
