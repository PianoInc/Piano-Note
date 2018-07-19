//
//  DataConvert.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 12..
//  Copyright © 2018년 piano. All rights reserved.
//

import CoreData

/**
 App side convert 기능.
 - Note: Set computeBlock first before call setup().
 */
public struct DataConvert {
    
    /// CKRecord -> NSManagedObject의 value를 처리해줘야 하는 block.
    public static var recordToObjectBlock: ((ManagedUnit) -> ())?
    /// NSManagedObject -> CKRecord의 value를 처리해줘야 하는 block.
    public static var objectToRecordBlock: ((ManagedUnit) -> ManagedUnit)?
    /// Cloud로 upload를 시도하다가 conflict 발생시 호출된다.
    public static var conflictBlock: ((ConflictRecord) -> ())?
    
}
