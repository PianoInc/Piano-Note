//
//  MarkTableViewController.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 1..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

protocol MarkDelegates: NSObjectProtocol {
    func action(_ data: String)
}

class MarkTableViewController: UITableViewController {
    
    private let data = ["Change the sign style to emoji", "Ordered list",
                        "Unordered list", "Check",
                        "Uncheck", "", "Reset All Settings"]
    private var sIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sign Style"
        tableView.contentInset.bottom = 55
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func KeyboardWillHide() {
        guard let blackView = navigationController?.view.subviews.first(where: {$0 is UIScrollView}) else {return}
        guard let textView = view.subviews.first(where: {$0 is UITextView}) else {return}
        UIView.animate(withDuration: 0.2, animations: {
            blackView.alpha = 0
        }, completion: { _ in
            blackView.removeFromSuperview()
            textView.removeFromSuperview()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MarkTableViewController: MarkDelegates {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 55
        case 5: return 33
        default: return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkTableViewCell") as! MarkTableViewCell
        cell.configure(with: data[indexPath.row], index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 6 {
            
        } else {
            sIndexPath = indexPath
            let textView = UITextView()
            view.addSubview(textView)
            
            let customInputView = CustomInputView()
            customInputView.delegates = self
            textView.inputView = customInputView
            textView.becomeFirstResponder()
            
            guard let naviView = navigationController?.view else {return}
            let blackView = UIScrollView(frame: naviView.bounds)
            blackView.contentSize = CGSize(width: blackView.bounds.width, height: blackView.bounds.height * 2)
            blackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            blackView.showsVerticalScrollIndicator = false
            blackView.keyboardDismissMode = .interactive
            blackView.alpha = 0
            naviView.addSubview(blackView)
            UIView.animate(withDuration: 0.2) {blackView.alpha = 1}
        }
    }
    
    func action(_ data: String) {
        switch data {
        case "hide": KeyboardWillHide()
        case "more": break
        case "subscript": break
        default: update(data)
        }
    }
    
    private func update(_ emoji: String) {
        guard let indexPath = sIndexPath else {return}
        guard let cell = tableView.cellForRow(at: indexPath) as? MarkTableViewCell else {return}
        cell.emoji.text = emoji
        KeyboardWillHide()
        sIndexPath = nil
    }
    
}

extension MarkTableViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.text = ""
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textdid :", textView.text)
    }
    
}

