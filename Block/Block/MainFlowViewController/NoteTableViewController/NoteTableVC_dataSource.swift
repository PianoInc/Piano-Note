//
//  NoteTableVC_dataSource.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 27..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension NoteTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = resultsController?.object(at: indexPath) else { return UITableViewCell() }
        var cell = tableView.dequeueReusableCell(withIdentifier: data.identifier) as! NoteTableDataAcceptable & UITableViewCell
        cell.folder = folder
        cell.data = data
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3) ?? UITableViewCellEditingStyle.none
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !tableView.isEditing else { return }
        resultsController?.object(at: indexPath).didSelectItem(fromVC: self)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let note = resultsController?.object(at: indexPath) else { return nil }
        //normal이면 버튼 두개 생성(고정, 공유)
        //shared이면 버튼 한 개 생성(공유 취소)
        //pinned이면 버튼 한 개 생성(고정 취소)
        var contextualAction: [UIContextualAction] = []
        
        switch note.type {
        case .normal:
            let pinned = UIContextualAction(style: .normal, title:  "고정", handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                note.type = .pinned
            })
            //        title1Action.image
            pinned.backgroundColor = UIColor(red: 255/255, green: 158/255, blue: 78/255, alpha: 1)
            
            let shared = UIContextualAction(style: .normal, title:  "공유", handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                success(true)
                note.type = .shared
            })
            //        title1Action.image
            shared.backgroundColor = UIColor(red: 253/255, green: 170/255, blue: 86/255, alpha: 1)
            
            contextualAction.append(contentsOf: [pinned, shared])
            
        case .pinned:
            let unPinned = UIContextualAction(style: .normal, title:  "고정 취소", handler: {(ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                success(true)
                note.type = .normal
            })
            //        title1Action.image
            unPinned.backgroundColor = UIColor(red: 255/255, green: 158/255, blue: 78/255, alpha: 1)
            contextualAction.append(unPinned)
            
        case .shared:
            let unShared = UIContextualAction(style: .normal, title:  "공유 취소", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                guard let `self` = self,
                    let note = self.resultsController?.object(at: indexPath) else { return }
                success(true)
                note.type = .normal
                //TODO: 공유기능도 여기서 끄도록 해야함
            })
            //        title1Action.image
            unShared.backgroundColor = UIColor(red: 255/255, green: 158/255, blue: 78/255, alpha: 1)
            contextualAction.append(unShared)
        
        }
        
        return UISwipeActionsConfiguration(actions: contextualAction)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let note = resultsController?.object(at: indexPath) else { return nil }
        //내보내기, 삭제
        let export = UIContextualAction(style: .normal, title:  "내보내기", handler: {[weak self](ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            self?.export(note: note)
            
        })
        //        closeAction.image = UIImage(named: "tick")
        let blueColor = UIColor(red: 59/255, green: 141/255, blue: 251/255, alpha: 1)
        export.backgroundColor = blueColor
        
        let delete = UIContextualAction(style: .normal, title:  "삭제", handler: {[weak self](ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            note.deleteWithRelationshipIfNeeded()
            
            
            
            success(true)
        })
        //        closeAction.image = UIImage(named: "tick")
        let redColor = UIColor(red: 255/255, green: 93/255, blue: 90/255, alpha: 1)
        delete.backgroundColor = redColor
        
        
        return UISwipeActionsConfiguration(actions: [delete, export])
    }
    
    
    
}

extension NoteTableViewController {
    private func export(note: Note) {
        
    }
}

extension NoteTableViewController: UIDataSourceModelAssociation {

    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        guard let resultsController = resultsController, !idx.isEmpty else { return nil }

        let id = resultsController.object(at: idx).objectID
            .uriRepresentation()
            .absoluteString
        return id
    }

    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        if let url = URL(string: identifier),
            let id = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url),
            let note = persistentContainer.viewContext.object(with: id) as? Note {
            return resultsController?.indexPath(forObject: note)
        }
        return nil
    }
}


