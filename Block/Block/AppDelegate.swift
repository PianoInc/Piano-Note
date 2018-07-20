//
//  AppDelegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 5..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import Cloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var cloudManager: CloudManager?
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Block")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //TODO: 여기 해결해야함
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        if !UserDefaults.standard.bool(forKey: "previouslyLaunched") {
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
            persistentContainer.createFolderIfNeeded()
        }
        initCloudManager()
        initSplitView()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        cloudManager?.fetch?.operate(with: userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata) {
        cloudManager?.acceptShared?.operate(with: cloudKitShareMetadata)
        cloudManager?.acceptShared?.perShareCompletionBlock = { data, share, error in
            print("perShareCompletionBlock :", data, share ?? "", error ?? "")
        }
    }
    
    private func initCloudManager() {
        let container = Container(cloud: CKContainer.default(), coreData: persistentContainer)
        cloudManager = CloudManager(with: container)
    }
    
}

extension AppDelegate : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    private func initSplitView() {
        guard let splitViewController = window?.rootViewController as? UISplitViewController else {return}
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.maximumPrimaryColumnWidth = 414
        splitViewController.minimumPrimaryColumnWidth = 320
        
        if let vc = (splitViewController.viewControllers.first as? UINavigationController)?.topViewController as? FolderTableViewController {
            vc.persistentContainer = persistentContainer
            persistentContainer.performBackgroundTask { [weak self] context in
                guard let `self` = self else { return }
                //컨텍스트를 멤버변수로 갖고 있게 하여, 나중에 저장할 때 사용한다.
                vc.context = context
                let resultsController = self.persistentContainer.folderResultsController(context: context)
                vc.resultsController = resultsController
                self.persistentContainer.perform(resultsController: resultsController, tableVC: vc)
            }
        } else {
            print("에러발생!! 스플릿뷰의 첫번째 컨트롤러가 폴더가 아니다!")
        }
    }
    
}
