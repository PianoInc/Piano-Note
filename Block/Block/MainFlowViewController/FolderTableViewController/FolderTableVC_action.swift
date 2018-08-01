//
//  FolderTableVC_action.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension FolderTableViewController {
    @IBAction func tapEdit(_ sender: Any) {
        updateViews(for: .edit)
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapFinishEdit(_ sender: Any) {
        updateViews(for: .normal)
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapDeleteAll(_ sender: Any) {
        
    }
    
    @IBAction func tapNewFolder(_ sender: Any) {
        showCreateFolderAlertVC()
    }
    
    @IBAction func tapFacebook(_ sender: Any) {
        performSegue(withIdentifier: "FacebookSplitViewController", sender: nil)
    }
    
    @IBAction func tapSetting(_ sender: Any) {
        performSegue(withIdentifier: "SettingSplitViewController", sender: nil)
    }
    
    
    
}

extension FolderTableViewController {
    @objc func textChanged(sender: AnyObject) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[1].isEnabled = (tf.text != "")
    }
    
    func showCreateFolderAlertVC() {
        let alert = UIAlertController(title: "Add Folder".localized, message: "AddFolderMessage".localized, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Create".localized, style: .default) { [weak self](action) in
            guard let `self` = self,
                let text = alert.textFields?.first?.text else { return }
            
            let lastOrder = self.resultsController?.fetchedObjects?.filter{ $0.typeInteger == 1 }.count ?? 0
            
            let context = self.persistentContainer.viewContext
            let newFolder = Folder(context: context)
            newFolder.name = text
            newFolder.order = Double(lastOrder)
            newFolder.folderType = .custom
        }
        
        ok.isEnabled = false
        alert.addAction(cancel)
        alert.addAction(ok)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Folder Name".localized
            textField.returnKeyType = .done
            textField.enablesReturnKeyAutomatically = true
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        
        present(alert, animated: true, completion: nil)
    }
    

}
