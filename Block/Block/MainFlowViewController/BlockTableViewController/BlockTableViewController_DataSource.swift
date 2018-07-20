//
//  BlockTableViewController_DataSource.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension BlockTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = resultsController?.object(at: indexPath) else { return UITableViewCell() }
        var cell = tableView.dequeueReusableCell(withIdentifier: data.identifier) as! TableDataAcceptable & UITableViewCell
        cell.data = data
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3) ?? UITableViewCellEditingStyle.none
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title1Action = UIContextualAction(style: .normal, title:  "대제목", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let data = self?.resultsController?.object(at: indexPath) else { return }
            
            data.set(textStyle: .title1)
            //TODO: 여기서도 코어데이터의 변화가 일어나므로 저장을 해줘야함(모든지 비동기)
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                success(true)
            }
        })
        //        title1Action.image
        title1Action.backgroundColor = UIColor(red: 255/255, green: 158/255, blue: 78/255, alpha: 1)
        
        let title2Action = UIContextualAction(style: .normal, title:  "소제목", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let data = self?.resultsController?.object(at: indexPath) else { return }
            
            data.set(textStyle: .title2)
            //TODO: 여기서도 코어데이터의 변화가 일어나므로 저장을 해줘야함(모든지 비동기)
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                success(true)
            }
            
            
        })
        //        title1Action.image
        title2Action.backgroundColor = UIColor(red: 253/255, green: 170/255, blue: 86/255, alpha: 1)
        let bodyAction = UIContextualAction(style: .normal, title:  "본문", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let data = self?.resultsController?.object(at: indexPath) else { return }
            
            data.set(textStyle: .body)
            //TODO: 여기서도 코어데이터의 변화가 일어나므로 저장을 해줘야함(모든지 비동기)
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                success(true)
            }
        })
        //        title1Action.image
        bodyAction.backgroundColor = UIColor(red: 255/255, green: 181/255, blue: 119/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [title1Action, title2Action, bodyAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copyAction = UIContextualAction(style: .normal, title:  "복사", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        //        closeAction.image = UIImage(named: "tick")
        let blueColor = UIColor(red: 59/255, green: 141/255, blue: 251/255, alpha: 1)
        copyAction.backgroundColor = blueColor
        
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            guard let block = self?.resultsController?.object(at: indexPath) else { return }
            block.deleteSelf()
            do {
                try block.managedObjectContext?.save()
            } catch {
                print("trailingSwipeActionsConfigurationForRowAt에서 오류: \(error.localizedDescription)")
            }
            
            success(true)
        })
        //        closeAction.image = UIImage(named: "tick")
        let redColor = UIColor(red: 255/255, green: 93/255, blue: 90/255, alpha: 1)
        deleteAction.backgroundColor = redColor
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction, copyAction])
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultsController?.object(at: indexPath).didSelectItem(fromVC: self)
        
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        ()
    }
    
}