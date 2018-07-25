//
//  FolderTableVC_state.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension FolderTableViewController {
    enum ViewControllerState {
        case normal
        case edit
    }
    
    internal func updateViews(for state: ViewControllerState) {
        setBarButtonItems(state: state)
        setViews(state: state)
    }
    
    private func setBarButtonItems(state: ViewControllerState) {
        switch state {
        case .normal:
            setNavbarForNormal()
            setToolbarForNormal()
            
        case .edit:
            setNavbarForEdit()
            setToolbarForEdit()
        }
    }
    
    private func setNavbarForNormal() {
        navigationItem.title = "Folder"
        let editBtn = BarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit(_:)))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
    }
    
    private func setToolbarForNormal() {
        let shopBtn = BarButtonItem(title: "shop", style: .plain, target: self, action: #selector(tapShop(_:)))
        let facebookBtn = BarButtonItem(title: "facebook", style: .plain, target: self, action: #selector(tapFacebook(_:)))
        
        let newFolderBtn = BarButtonItem(title: "New Folder", style: .plain, target: self, action: #selector(tapNewFolder(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems(
            [shopBtn, facebookBtn, flexibleWidthBtn, newFolderBtn],
            animated: true)
    }
    
    private func setNavbarForEdit() {
        navigationItem.title = "Folder"
        let doneBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishEdit(_:)))
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(doneBtn, animated: true)
    }
    
    private func setToolbarForEdit() {
        let deleteAllBtn = BarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(tapDeleteAll(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([flexibleWidthBtn, deleteAllBtn], animated: true)
    }
    
    private func setViews(state: ViewControllerState) {
        self.state = state
        
    }
}
