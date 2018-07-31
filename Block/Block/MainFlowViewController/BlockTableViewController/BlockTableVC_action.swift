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
        let blocks = indexPaths.map { controller.object(at: $0) }
        copy(blocks: blocks)
    }
    
    @IBAction func tapCopyAll(_ sender: Any) {
        guard let blocks = resultsController?.fetchedObjects else { return }
        copy(blocks: blocks)
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
