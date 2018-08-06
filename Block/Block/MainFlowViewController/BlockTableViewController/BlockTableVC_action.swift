//
//  BlockTableViewController_Action.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.

import UIKit
import CoreData

//MARK: Action
extension BlockTableViewController {
    
    @IBAction func tapFinishType(_ sender: Any) {
        updateViews(for: .normal)
        self.view.endEditing(true)
    }
    
    @IBAction func tapEdit(_ sender: Any) {
        updateViews(for: .edit)
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapFinishEdit(_ sender: Any) {
        updateViews(for: .normal)
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapRestore(_ sender: Any) {
        
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        
    }
    
    @IBAction func tapCopyParagraphs(_ sender: Any) {
        guard let controller = resultsController,
            let indexPaths = tableView.indexPathsForSelectedRows else { return }
        showLoadingView()
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            let blocks = indexPaths.enumerated().map({ (arg) -> Block in
                let (offset, indexPath) = arg
                self.changeLoadingView(description: "복사중..", progress: "\(offset) / \(indexPaths.count)")
                return controller.object(at: indexPath)
            })
            
            self.copy(blocks: blocks)
            self.removeLoadingView()
        }
    }
    
    @IBAction func tapSelectAll(_ sender: Any) {
        guard let count = resultsController?.fetchedObjects?.count else { return }
        showLoadingView()
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            for i in 0 ..< count {
                self.changeLoadingView(description: "전체 선택중..", progress: "\(i) / \(count)")
                let indexPath = IndexPath(row: i, section: 0)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            
            self.removeLoadingView()
        }
    }
    
    private func showLoadingView() {
        guard let loadingView = splitViewController?.view.createSubviewIfNeeded(LoadingView.self) else { return }
        splitViewController?.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = loadingView.topAnchor.constraint(equalTo: view.topAnchor)
        let leadingAnchor = loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingAnchor = loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottomAnchor = loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([topAnchor, leadingAnchor, trailingAnchor, bottomAnchor])
    }
    
    private func changeLoadingView(description: String, progress: String) {
        guard let loadingView = splitViewController?.view.subView(LoadingView.self) else { return }
        loadingView.descriptionLabel.text = description
        loadingView.progressLabel.text = progress
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.0001))
    }
    
    
    
    private func removeLoadingView() {
        guard let loadingView = splitViewController?.view.subView(LoadingView.self) else { return }
        loadingView.removeFromSuperview()
    }

    
    
    @IBAction func tapTrash(_ sender: Any) {
        
    }
    
    @IBAction func tapFolder(_ sender: Any) {
        performSegue(withIdentifier: "FolderPickerTableViewController", sender: sender)
    }
    
    @IBAction func tapHighlight(_ sender: Any) {
        updateViews(for: .highlighting)
    }
    
    @IBAction func tapFinishHighlight(_ sender: Any) {
        updateViews(for: .normal)
        
    }
    
    @IBAction func tapTheme(_ sender: Any) {
        
    }
    
    @IBAction func tapCompose(_ sender: Any) {
        
    }
    
    @IBAction func tapDeleteParagraphs(_ sender: Any) {
        //        TODO: 이부분은 어떻게 할 지 고민해봐야함
        //        undoManager.deleteParagraphs(selectedIndexPaths: [IndexPath])
    }
    
    @IBAction func tapPermanentlyDelete(_ sender: Any) {
        
    }
    
    /**
     텍스트 맨 밑에 터치했을 때 마지막 셀이 텍스트 셀이 아니라면, 셀 생성하여 커서 띄우고, 텍스트 셀이라면 맨 마지막에 커서 띄우기
     */
    @IBAction func tapBackground(_ sender: Any) {
        guard !tableView.isEditing else { return }
        createBlockIfNeeded()
    }
}

extension BlockTableViewController {
    
    private func createBlockIfNeeded(){
        guard let count = resultsController?.sections?.first?.numberOfObjects,
            count > 0,
            let lastBlock = resultsController?.object(at: IndexPath(row: count - 1, section: 0)),
            lastBlock.isTextType else {
                createBlockAtLast(controller: resultsController)
                return
        }
        let indexPath = IndexPath(row: count - 1, section: 0)
        let textCount = lastBlock.text?.count ?? 0
        let selectedRange = NSMakeRange(textCount, 0)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TextBlockTableViewCell else { return }
        cell.ibTextView.isEditable = true
        cell.ibTextView.selectedRange = selectedRange
        cell.ibTextView.becomeFirstResponder()
    }
    
    /**
     셀이 하나도 없으면 첫 셀을 만들어주고, 셀이 존재하면 마지막 셀의 order + 1를 해주기
     */
    private func createBlockAtLast(controller: NSFetchedResultsController<Block>?) {
        guard let controller = controller else { return }
        let count = controller.sections?.first?.numberOfObjects ?? 0
        
        
        let context = controller.managedObjectContext
        let order: Double
        
        if count != 0 {
            let lastIndexPath = IndexPath(row: count, section: 0)
            let previousBlock = controller.object(at: lastIndexPath)
            order = previousBlock.order + 1
        } else {
            order = 0
        }
        
        let block = Block(context: context)
        block.order = order
        block.note = note
        
        let plainTextBlock = PlainTextBlock(context: context)
        plainTextBlock.addToBlockCollection(block)
        let indexPath = IndexPath(row: 0, section: 0)
        let selectedRange = NSMakeRange(0, 0)
        cursorCache = (indexPath, selectedRange)
    }
}
