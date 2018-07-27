//
//  BlockTableViewControlle_state.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BlockTableViewController {
    enum ViewControllerState {
        case normal
        case edit
        case typing
        case highlighting
        case deleted
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
            
        case .highlighting:
            setNavbarForHighlighting()
            setToolbarForHighlighting()
            
        case .deleted:
            setToolbarForDeleted()
            
        case .typing:
            setNavbarForTyping()
        }
    }
    
    private func setNavbarForNormal() {
        navigationItem.title = ""
        let editBtn = BarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit(sender:)))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    private func setToolbarForNormal() {
        let trashBtn = BarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapTrash(sender:)))
        let folderBtn = BarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(tapFolder(sender:)))
        let highlightBtn = BarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(tapHighlight(sender:)))
        let sendBtn = BarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(tapSend(sender:)))
        let composeBtn = BarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose(sender:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems(
            [trashBtn, flexibleWidthBtn, folderBtn, flexibleWidthBtn, highlightBtn,
             flexibleWidthBtn, sendBtn, flexibleWidthBtn, composeBtn],
            animated: true)
    }
    
    private func setNavbarForEdit() {
        navigationItem.title = ""
        let doneBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishEdit(sender:)))
        let selectAllBtn = BarButtonItem(title: "전체 복사", style: .plain, target: self, action: #selector(tapCopyAll(sender:)))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(selectAllBtn, animated: true)
        self.navigationItem.setRightBarButton(doneBtn, animated: true)
    }
    
    private func setToolbarForEdit() {
        let copyBtn = BarButtonItem(title: "복사하기", style: .plain, target: self, action: #selector(tapCopyParagraphs(sender:)))
        let deleteBtn = BarButtonItem(title: "삭제하기", style: .plain, target: self, action: #selector(tapDeleteParagraphs(sender:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([deleteBtn, flexibleWidthBtn, copyBtn], animated: true)
    }
    
    private func setNavbarForHighlighting() {
        navigationItem.title = "글자에 손을 대고 형광펜 칠하듯 그어보세요"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    private func setToolbarForHighlighting() {
        let finishBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishHighlight(sender:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([flexibleWidthBtn, finishBtn, flexibleWidthBtn], animated: true)
    }
    
    private func setToolbarForDeleted() {
        let deleteBtn = BarButtonItem(title: "영구삭제", style: .plain, target: self, action: #selector(tapPermanentlyDelete(sender:)))
        let restoreBtn = BarButtonItem(title: "복구하기", style: .plain, target: self, action: #selector(tapRestore(sender:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([deleteBtn, flexibleWidthBtn, restoreBtn], animated: true)
    }
    
    private func setNavbarForTyping() {
        let completeBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishType(sender:)))
        self.navigationItem.setRightBarButton(completeBtn, animated: true)
    }
    
    private func setViews(state: ViewControllerState) {
        self.state = state
    }
    
    enum RecommandBarState {
        case calendar(title: String, startDate: Date)
        case reminder(title: String, date: Date)
        case contact(name: String, number: String)
        case pasteboard(NSAttributedString)
        case restore([(order: Int, Block: Block)])
    }
    
}
