//
//  BlockTableViewController_Action.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.

import UIKit

//MARK: Action
extension BlockTableViewController {
    @IBAction func tapTableViewBackground(_ sender: UITapGestureRecognizer) {
        setCursor(position: sender.location(in: tableView))
    }
    
    @IBAction func tapFinishTyping(sender: UIBarButtonItem) {
        updateViews(for: .normal)
        self.view.endEditing(true)
    }
    
    @IBAction func tapEdit(sender: UIBarButtonItem) {
        updateViews(for: .edit)
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapFinishEditing(sender: UIBarButtonItem) {
        updateViews(for: .normal)
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapRestore(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapSearch(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapCopyParagraphs(sender: UIBarButtonItem) {
        PasteboardManager.copyParagraphs(Blocks: selectedBlocks)
    }
    
    @IBAction func tapCopyAll(sender: UIBarButtonItem) {
        
    }
    
    
    
    @IBAction func tapTrash(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapFolder(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "FolderPickerTableViewController", sender: sender)
    }
    
    @IBAction func tapHighlight(sender: UIBarButtonItem) {
        updateViews(for: .highlighting)
    }
    
    @IBAction func tapFinishHighlight(sender: UIBarButtonItem) {
        updateViews(for: .normal)
        
    }
    
    @IBAction func tapSend(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapCompose(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapDeleteParagraphs(sender: UIBarButtonItem) {
        //        TODO: 이부분은 어떻게 할 지 고민해봐야함
        //        undoManager.deleteParagraphs(selectedIndexPaths: [IndexPath])
    }
    
    @IBAction func tapPermanentlyDelete(sender: UIBarButtonItem) {
        
    }
}
