//
//  CloudManager.swift
//  Cloud
//
//  Created by JangDoRi on 2018. 7. 6..
//

/**
 Cloud & CoreData sync기능을 제공하는 CloudManager.
 - warning: set DataConvert, call setup() 필수.
 */
public class CloudManager {
    
    private var container: Container
    
    /// Cloud에서 보내온 changed notification에 대한 처리기능.
    public var fetch: Fetch?
    /// Cloud share invitation에 대한 처리기능.
    public var acceptShared: AcceptShared?
    /// Cloud에 구성원을 invite하여 share하는 작업에 대한 처리기능.
    public lazy var share = Share(with: container)
    
    /// Offline등의 이유로 Cloud에 올바르게 sync하지 못했던 작업들에 대한 처리기능.
    private var longLived: LongLived?
    /// Cloud에서 사용 될 custom Database & Zone 구독정보를 관리하는 기능.
    private var subscription: Subscription?
    /// CoreData의 persistent적으로 save되었을때를 감지하여 Cloud에 sync해주는 기능.
    private var contextSave: ContextSave?
    /// Cloud account가 바뀌었을때에 대한 처리기능.
    private var accountChanged: AccountChanged?
    
    public init(with container: Container) {
        self.container = container
        container.cloud.accountStatus { status, error in
            guard status == .available else {return}
            self.initialize()
            self.setup()
        }
    }
    
    private func initialize() {
        acceptShared = AcceptShared()
        accountChanged = AccountChanged(with: container)
        fetch = Fetch(with: container)
        longLived = LongLived(with: container)
        subscription = Subscription(with: container)
        contextSave = ContextSave(with: container)
    }
    
    private func setup() {
        func fetchAll() {accountChanged?.requestUserInfo {self.fetch?.operate()}}
        fetchAll()
        subscription?.operate {self.longLived?.operate()}
        accountChanged?.addObserver {fetchAll()}
        contextSave?.addObserver()
    }
    
}
