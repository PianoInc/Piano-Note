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

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
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

//    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
//        print(identifierComponents, "identifierComponents")
//
//        if let storyboard = coder.decodeObject(forKey: UIStateRestorationViewControllerStoryboardKey) as? UIStoryboard,
//            let viewControllerID = identifierComponents.last as? String {
//            switch viewControllerID {
//            case "FolderTableViewController":
//                if let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID) as? FolderTableViewController {
//                    vc.persistentContainer = persistentContainer
//                    vc.resultsController = persistentContainer.viewContext.folderResultsController()
//                    return vc
//                }
//            case "NoteTableViewController":
//                if let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID) as? NoteTableViewController,
//                    let url = coder.decodeObject(forKey: "folderURI") as? URL,
//                    let coordinator = persistentContainer.viewContext.persistentStoreCoordinator,
//                    let id = coordinator.managedObjectID(forURIRepresentation: url),
//                    let folder = persistentContainer.viewContext.object(with: id) as? Folder,
//                    let decodedState = coder.decodeObject(forKey: "NoteTableViewControllerState") as? String {
//
//                    vc.state = NoteTableViewController.ViewControllerState(rawValue: decodedState)
//                    vc.folder = folder
//                    vc.persistentContainer = persistentContainer
//                    vc.resultsController = persistentContainer.viewContext.noteResultsController(folder: folder)
//                    vc.resultsController?.delegate = vc
//                    return vc
//                }
//            case "BlockTableViewController":
//                if let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID) as? BlockTableViewController,
//                    let url = coder.decodeObject(forKey: "noteURI") as? URL,
//                    let coordinator = persistentContainer.viewContext.persistentStoreCoordinator,
//                    let id = coordinator.managedObjectID(forURIRepresentation: url),
//                    let note = persistentContainer.viewContext.object(with: id) as? Note,
//                    let decodedState = coder.decodeObject(forKey: "BlockTableViewControllerState") as? String {
//
//                    vc.state = BlockTableViewController.ViewControllerState(rawValue: decodedState)
//                    vc.note = note
//                    vc.persistentContainer = persistentContainer
//                    vc.resultsController = persistentContainer.viewContext.blockResultsController(note: note)
//                    vc.resultsController?.delegate = vc
//                    return vc
//                }
//            default:
//                return nil
//            }
//        }
//        return nil
//    }
    
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
