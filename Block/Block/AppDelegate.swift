//
//  AppDelegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 5..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import Facebook

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if !UserDefaults.standard.bool(forKey: "previouslyLaunched") {
            UserDefaults.standard.set(true, forKey: "previouslyLaunched")
            persistentContainer.viewContext.createFolderIfNeeded()
        }
        
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
            splitViewController.preferredDisplayMode = .allVisible
            splitViewController.maximumPrimaryColumnWidth = 414
            splitViewController.minimumPrimaryColumnWidth = 320
            
            if let vc = (splitViewController.viewControllers.first as? UINavigationController)?.topViewController as? FolderTableViewController {
                vc.persistentContainer = persistentContainer
                let context = persistentContainer.viewContext
                let resultsController = context.folderResultsController()
                vc.resultsController = resultsController
                resultsController.delegate = vc
            } else {
                print("에러발생!! 스플릿뷰의 첫번째 컨트롤러가 폴더가 아니다!")
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
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
    
    func saveContext () {
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

extension AppDelegate : UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
