//
//  ErrorHandleable.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 6..
//

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

internal protocol ErrorHandleable: class {
    var container: Container {get set}
    var errorBlock: ((Error?) -> ())? {get set}
}

internal extension ErrorHandleable where Self: Subscription {
    
    internal func errorHandle(subscription error: Error?) {
        guard let error = error as? CKError else {return}
        switch error.code {
        case .zoneNotFound: Sync(with: container).operate()
        case .operationCancelled: break
        default: break
        }
    }
    
}

internal extension ErrorHandleable where Self: Share {
    
    internal func errorHandle(share error: Error?) {
        guard let error = error as? CKError else {return}
        switch error.code {
        case .batchRequestFailed: Fetch(with: container).operate()
        default: break
        }
    }
    
}

internal extension ErrorHandleable where Self: Fetch {
    
    internal func errorHandle(fetch error: Error, _ database: CKDatabase) {
        guard let error = error as? CKError else {return}
        switch error.code {
        case .userDeletedZone:
            #if os(iOS)
            let alert = UIAlertController(title: "purge_title".loc, message: "purge_msg".loc, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "cancel".loc, style: .cancel))
            alert.addAction(UIAlertAction(title: "apply".loc, style: .default) { _ in Purge(with: self.container).operate()})
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
            #elseif os(OSX)
            #endif
        case .changeTokenExpired:
            if database.databaseScope == .private {
                token.byZoneID[PRIVATE_DB_ID] = nil
                zoneOperation(database)
            } else {
                token.byZoneID[DATABASE_DB_ID] = nil
                token.byZoneID[SHARED_DB_ID] = nil
                dbOperation(database)
            }
        default: break
        }
    }
    
}

internal extension ErrorHandleable where Self: ContextSave {
    
    internal func errorHandle(observer error: Error?) {
        guard let error = error as? CKError else {return}
        switch error.code {
        case .zoneNotFound: Sync(with: container).operate()
        case .operationCancelled: break
        case .serverRecordChanged: conflict(error)
        default: break
        }
    }
    
    private func conflict(_ error: CKError) {
        guard let ancestorRecord = error.ancestorRecord, let serverRecord = error.serverRecord, let clientRecord = error.clientRecord else {return}
        serverRecord.syncMetaData(using: container)
        let record = ConflictRecord(ancestor: ancestorRecord, server: serverRecord, client: clientRecord)
        let converter = Converter()
        converter.cloud(conflict: record, using: container)
    }
    
}
