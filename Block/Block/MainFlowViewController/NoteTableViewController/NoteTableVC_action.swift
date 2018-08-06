//
//  NoteTableVC_action.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension NoteTableViewController {
    @IBAction func tapEdit(_ sender: Any) {
        updateViews(for: .edit)
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapSortBlock(_ sender: Any) {
        performSegue(withIdentifier: "AttachTypeTableViewController", sender: self)
    }
    
    @IBAction func tapSortNote(_ sender: Any) {
        
    }
    
    @IBAction func tapFinishEdit(_ sender: Any) {
        updateViews(for: .normal)
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapCompose(_ sender: Any) {
        guard let context = resultsController?.managedObjectContext else { return }
        let note = Note(context: context)
        note.folder = folder
        note.type = .normal
        note.createdDate = Date()
        note.modifiedDate = Date()
        note.title = "새로운 메모를 작성해주세요"
        
        performSegue(withIdentifier: "BlockNavigationController", sender: note)
    }
    
    @IBAction func tapMoveAll(_ sender: Any) {
        
    }
    
    @IBAction func tapDeleteAll(_ sender: Any) {
        //노트의 카테고리가 이미 삭제된 노트 폴더라면 영구적으로 지우기
    }
    
}
