//
//  NoteTableVC_state.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension NoteTableViewController {
    enum ViewControllerState {
        case normal
        case edit
        case deleted
        case locked
    }
    
    internal func updateViews(for state: ViewControllerState) {
        setBarButtonItems(state: state)
        setViews(state: state)
    }
    
    private func setBarButtonItems(state: ViewControllerState) {
        switch state {
        case .normal, .locked:
            setNavbarForNormal()
            setToolbarForNormal()
            
        case .edit:
            setNavbarForEdit()
            setToolbarForEdit()
            
        case .deleted:
            setNavbarForDeleted()
            setToolbarForDeleted()
        }
    }
    
    private func setNavbarForNormal() {
        navigationItem.title = folder.name ?? "이름 없음"
        let editBtn = BarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit(_:)))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    private func setToolbarForNormal() {
        let sortBlockBtn = BarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(tapSortBlock(_:)))
        
        let composeBtn = BarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems(
            [sortBlockBtn, flexibleWidthBtn, composeBtn],
            animated: true)
    }
    
    private func setNavbarForEdit() {
        navigationItem.title = folder.name ?? "이름 없음"
        let doneBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishEdit(_:)))
        let sortNoteBtn = BarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(tapSortNote(_:)))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(sortNoteBtn, animated: true)
        self.navigationItem.setRightBarButton(doneBtn, animated: true)
    }
    
    private func setToolbarForEdit() {
        let moveAllBtn = BarButtonItem(title: "모두 이동", style: .plain, target: self, action: #selector(tapMoveAll(_:)))
        
        let deleteAllBtn = BarButtonItem(title: "모두 삭제", style: .plain, target: self, action: #selector(tapDeleteAll(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([moveAllBtn, flexibleWidthBtn, deleteAllBtn], animated: true)
    }
    
    
    
    private func setNavbarForDeleted() {
        navigationItem.title = folder.name ?? "삭제된 메모"
        let editBtn = BarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit(_:)))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    private func setToolbarForDeleted() {
        let sortBlockBtn = BarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(tapSortBlock(_:)))
        
        self.setToolbarItems(
            [sortBlockBtn], animated: true)
    }
    
    private func setViews(state: ViewControllerState) {
        self.state = state
        
    }
    
    enum RecommandBarState {
        case calendar(title: String, startDate: Date, endDate: Date)
        case reminder(title: String, date: Date)
        case contact(name: String, number: Int)
        case pasteboard(NSAttributedString)
        case restore([(order: Int, Block: Block)])
    }
}
