//
//  BlockTableViewController_DataSource.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension BlockTableViewController: TableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = resultsController?.object(at: indexPath) else { return UITableViewCell() }
        var cell = tableView.dequeueReusableCell(withIdentifier: data.identifier) as! BlockTableDataAcceptable & UITableViewCell
        cell.data = data
        cell.state = state
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3) ?? UITableViewCellEditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let title1Action = UIContextualAction(style: .normal, title:  "대제목", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let `self` = self,
                let block = self.resultsController?.object(at: indexPath) else { return }
            
            success(true)
            block.modifiedDate = Date()
            block.textStyle = .title1
            
        })
        
        //        title1Action.image
        title1Action.backgroundColor = UIColor(red: 255/255, green: 158/255, blue: 78/255, alpha: 1)
        
        let title2Action = UIContextualAction(style: .normal, title:  "소제목", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let `self` = self,
                let block = self.resultsController?.object(at: indexPath) else { return }
            success(true)
            block.textStyle = .title2
            
            
        })
        //        title1Action.image
        title2Action.backgroundColor = UIColor(red: 253/255, green: 170/255, blue: 86/255, alpha: 1)
        let bodyAction = UIContextualAction(style: .normal, title:  "본문", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let `self` = self,
                let block = self.resultsController?.object(at: indexPath) else { return }
            success(true)
            block.textStyle = .body
            
        })
        //        title1Action.image
        bodyAction.backgroundColor = UIColor(red: 255/255, green: 181/255, blue: 119/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [title1Action, title2Action, bodyAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copyAction = UIContextualAction(style: .normal, title:  "복사", handler: { [weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            guard let block = self?.resultsController?.object(at: indexPath) else { return }
            self?.copy(blocks: [block])
            
        })
        //        closeAction.image = UIImage(named: "tick")
        let blueColor = UIColor(red: 59/255, green: 141/255, blue: 251/255, alpha: 1)
        copyAction.backgroundColor = blueColor
        
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let `self` = self,
                let block = self.resultsController?.object(at: indexPath) else { return }
            
            block.deleteWithRelationship()
            
            
            
            success(true)
        })
        //        closeAction.image = UIImage(named: "tick")
        let redColor = UIColor(red: 255/255, green: 93/255, blue: 90/255, alpha: 1)
        deleteAction.backgroundColor = redColor
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction, copyAction])
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let state = self.state else { return false }
        return state != .normal ? false : true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row != destinationIndexPath.row else {return}
        guard let sourceBlock = resultsController?.object(at: sourceIndexPath) else {return}
        guard let destBlock = resultsController?.object(at: destinationIndexPath) else {return}
        guard let count = resultsController?.sections?.first?.numberOfObjects else {return}
        
        if destinationIndexPath.row <= 0 {
            sourceBlock.order = destBlock.order - 1
        } else if destinationIndexPath.row >= count - 1 {
            sourceBlock.order = destBlock.order + 1
        } else {
            if sourceIndexPath.row < destinationIndexPath.row {
                var nextIndexPath = destinationIndexPath
                nextIndexPath.row += 1
                guard let nextBlock = resultsController?.object(at: nextIndexPath) else {return}
                sourceBlock.order = (nextBlock.order + destBlock.order) / 2
            } else {
                var prevIndexPath = destinationIndexPath
                prevIndexPath.row -= 1
                guard let prevBlock = resultsController?.object(at: prevIndexPath) else {return}
                sourceBlock.order = (prevBlock.order + destBlock.order) / 2
            }
        }
    }
    
}

extension BlockTableViewController: TableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultsController?.object(at: indexPath).didSelectItem(fromVC: self)
        
    }
}

extension BlockTableViewController {
    func copy(blocks: [Block]) {
        //TODO: 이거 paste로직 만들어서 block 돌아가면서 제대로 타입 붙여야함
        UIPasteboard.general.string = blocks.first?.text
        navigationController?.appearCopyNotificationView()
    }
}

extension BlockTableViewController: UIDataSourceModelAssociation {

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
            let block = persistentContainer.viewContext.object(with: id) as? Block {
            print(resultsController?.indexPath(forObject: block), "🐶")
            return resultsController?.indexPath(forObject: block)
        }
        return nil
    }
}

