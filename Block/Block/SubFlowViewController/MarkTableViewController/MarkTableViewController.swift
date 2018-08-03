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
    private var canEmojiKeyboard: Bool {
        return UITextInputMode.activeInputModes.contains(where: {$0.primaryLanguage == "emoji"})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sign Style"
        tableView.contentInset.bottom = 55
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func KeyboardWillHide(_ instant: Bool = false) {
        guard let indexPaths = self.tableView.indexPathsForVisibleRows else {return}
        indexPaths.forEach {self.tableView.deselectRow(at: $0, animated: false)}
        guard let textView = view.subviews.first(where: {$0 is UITextView}) else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + (instant ? 0 : 0.2)) {
            textView.removeFromSuperview()
        }
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
        if indexPath.row == 6 {
            KeyboardWillHide(true)
            reset()
        } else {
            sIndexPath = indexPath
            if StoreService.share.hasReceipt {
                if canEmojiKeyboard {
                    let emojiTextView = EmojiTextView()
                    emojiTextView.delegate = self
                    view.addSubview(emojiTextView)
                    emojiTextView.becomeFirstResponder()
                } else {
                    custom(InputView: .payed)
                }
            } else {
                custom(InputView: .nonPayed)
            }
        }
    }
    
    private func custom(InputView type: InputViewType) {
        guard !view.subviews.contains(where: {$0 is UITextView}) else {return}
        let textView = UITextView()
        view.addSubview(textView)
        let customInputView = CustomInputView(type)
        customInputView.delegates = self
        textView.inputView = customInputView
        textView.becomeFirstResponder()
    }
    
    private func reset() {
        (1...4).forEach {
            guard let cell = tableView.cellForRow(at: IndexPath(item: $0, section: 0)) as? MarkTableViewCell else {return}
            cell.emoji.text = ""
        }
    }
    
    func action(_ data: String) {
        switch data {
        case "hide": KeyboardWillHide(true)
        case "more": break
        case "subscript": break
        default: update(data)
        }
    }
    
    private func update(_ emoji: String) {
        guard let indexPath = sIndexPath else {return}
        guard let cell = tableView.cellForRow(at: indexPath) as? MarkTableViewCell else {return}
        cell.emoji.text = emoji
    }
    
}

extension MarkTableViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.text = ""
        guard let containsEmoji = (text as AnyObject).value(forKey: "_containsEmoji") as? Bool else {return true}
        return containsEmoji
    }
    
    func textViewDidChange(_ textView: UITextView) {
        update(textView.text)
    }
    
}
