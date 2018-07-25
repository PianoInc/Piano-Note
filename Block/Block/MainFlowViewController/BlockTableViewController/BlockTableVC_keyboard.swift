//
//  BlockTableViewController_Keyboard.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 25..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

extension BlockTableViewController {
    internal func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    internal func unRegisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}

extension BlockTableViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let kbHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            else { return }
        
        tableView.contentInset.bottom = kbHeight
        tableView.scrollIndicatorInsets.bottom = kbHeight
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        tableView.contentInset.bottom = tableViewInset.bottom
    }
}
