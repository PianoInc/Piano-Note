//
//  BlockTableViewControlle_state.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import Foundation

extension BlockTableViewController {
    enum ViewControllerState: String {
        case normal
        case edit
        case typing
        case highlighting
        case deleted
    }
    
    internal func updateViews(for state: ViewControllerState?) {
        guard let state = state else { return }
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
        let editBtn = BarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit(_:)))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
    }
    
    private func setToolbarForNormal() {
        let trashBtn = BarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapTrash(_:)))
        let folderBtn = BarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(tapFolder(_:)))
        let highlightBtn = BarButtonItem(title: "형광펜", style: .plain, target: self, action: #selector(tapHighlight(_:)))
        let themeBtn = BarButtonItem(title: "테마", style: .plain, target: self, action: #selector(tapTheme(_:)))
        let composeBtn = BarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems(
            [trashBtn, flexibleWidthBtn, folderBtn, flexibleWidthBtn, highlightBtn,
             flexibleWidthBtn, themeBtn, flexibleWidthBtn, composeBtn],
            animated: true)
    }
    
    private func setNavbarForEdit() {
        navigationItem.title = ""
        let cancelBtn = BarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapFinishEdit(_:)))
        let selectAllBtn = BarButtonItem(title: "전체 선택", style: .plain, target: self, action: #selector(tapSelectAll(_:)))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(selectAllBtn, animated: true)
        self.navigationItem.setRightBarButton(cancelBtn, animated: true)
    }
    
    private func setToolbarForEdit() {
        let copyBtn = BarButtonItem(title: "복사하기", style: .plain, target: self, action: #selector(tapCopyParagraphs(_:)))
        
        let deleteBtn = BarButtonItem(title: "삭제하기", style: .plain, target: self, action: #selector(tapDeleteParagraphs(_:)))
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
        let finishBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishHighlight(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([flexibleWidthBtn, finishBtn, flexibleWidthBtn], animated: true)
    }
    
    private func setToolbarForDeleted() {
        let deleteBtn = BarButtonItem(title: "영구삭제", style: .plain, target: self, action: #selector(tapPermanentlyDelete(_:)))
        let restoreBtn = BarButtonItem(title: "복구하기", style: .plain, target: self, action: #selector(tapRestore(_:)))
        let flexibleWidthBtn = BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([deleteBtn, flexibleWidthBtn, restoreBtn], animated: true)
    }
    
    private func setNavbarForTyping() {
        let completeBtn = BarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishType(_:)))
        self.navigationItem.setRightBarButton(completeBtn, animated: true)
    }
    
    
    //TODO: 여기서 visibleCell 처리해주기
    private func setViews(state: ViewControllerState) {
        self.state = state
        
        switch state {
        case .normal, .typing:
            tapGestureRecognizer.isEnabled = true
        case .deleted, .edit, .highlighting:
            tapGestureRecognizer.isEnabled = false
        }
        
        tableView.visibleCells.forEach { (cell) in
            //TODO: 나중에 이미지, 파일 등등일 때에도 처리해줘야함
            guard let cell = cell as? TextBlockTableViewCell else { return }
            cell.state = state
        }
    }
    
    enum RecommandBarState {
        case calendar(title: String, startDate: Date)
        case reminder(title: String, date: Date)
        case contact(name: String, number: String)
        case pasteboard(NSAttributedString)
        case restore([(order: Int, Block: Block)])
    }
    
}
