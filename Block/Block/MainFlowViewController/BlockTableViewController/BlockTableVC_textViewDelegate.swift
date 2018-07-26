//
//  BlockTableViewController_TextViewDelegate.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 19..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData
import EventKitUI
import ContactsUI

extension BlockTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        switchKeyboardIfNeeded(textView)
        
        if state != .typing {
            updateViews(for: .typing)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        guard let cell = textView.superview?.superview as? TextBlockTableViewCell,
            let block = cell.data as? Block else { return }
        block.text = textView.text
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !isCharacter(over: 10000) else { return false }
        return moveCellIfNeeded(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reactCellHeight(textView)
        //        switchKeyboardIfNeeded(textView)
        formatTextIfNeeded(textView)
        //        setTableViewOffSetIfNeeded(textView: textView)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        //presentAlertController(Block, with: URL)
        return interact(data: URL)
    }
    
    internal func moveCellIfNeeded(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let block = (textView.superview?.superview as? TableDataAcceptable)?.data as? Block,
            let indexPath = resultsController?.indexPath(forObject: block)
            else { return true }
        
        switch typingSituation(textView, block: block, replacementText: text) {
        case .resetForm:
            block.revertToPlain()
            moveCursorForResetForm(in: indexPath)
            return false
        case .movePrevious:
            guard let resultsController = resultsController, indexPath.row > 0 else { return false }
            
            var indexPath = indexPath
            indexPath.row -= 1
            let previousBlock = resultsController.object(at: indexPath)
            
            if !previousBlock.isTextType {
                //TODO: 이미지, 파일, 등등의 타입이므로 해당 block을 지울 것인지 물어보는 얼럿 창을 띄워줘야함
                print("TODO: 이미지, 파일, 등등의 타입이므로 해당 block을 지울 것인지 물어보는 얼럿 창을 띄워줘야함")
                return false
            }
            
            moveCursorTo(previousBlock, prevIndexPath: indexPath)
            
            let text = textView.text ?? ""
            previousBlock.append(text: text)
            previousBlock.modifiedDate = Date()
            block.deleteWithRelationship()
            
            return false
        case .stayCurrent:
            return true
        case .moveNext:
            //TODO: 이렇게 되면 형광펜이 깨짐, attributed로 만들어야함
            let (frontText, behindText) = textView.splitTextByCursor()
            block.text = data(detector: frontText)
            block.modifiedDate = Date()
            block.insertNextBlock(with: behindText, on: resultsController)
            
            var indexPath = indexPath
            indexPath.row += 1
            let selectedRange = NSMakeRange(0, 0)
            cursorCache = (indexPath, selectedRange)
            
            data(detector: frontText, with: textView, using: block)
            
            return false
        }
    }
    
    enum TypingSituation {
        case resetForm
        case movePrevious
        case stayCurrent
        case moveNext
    }
    
    private func data(detector text: String) -> String {
        return text
    }
    
    private func typingSituation(_ textView: UITextView, block: Block, replacementText text: String) -> TypingSituation {
        
        if textView.selectedRange == NSMakeRange(0, 0) && text.count == 0 {
            //문단 맨 앞에 커서가 있으면서 백스페이스 눌렀을 때
            return block.hasFormat ? .resetForm : .movePrevious
        } else if textView.selectedRange == NSMakeRange(0, 0)
            && text == "\n" && block.hasFormat {
            //문단 맨 앞에 커서가 있으면서 개행을 눌렀고, 포멧이 있을 때
            return .resetForm
        } else if text == "\n" {
            //개행을 눌렀을 때
            return .moveNext
        } else {
            return .stayCurrent
        }
    }
    
}

extension BlockTableViewController {
    /**
     PlainTextBlock이 아니라면 이 작업을 할 필요가 없음.
     */
    private func formatTextIfNeeded(_ textView: UITextView) {
        guard let block = (textView.superview?.superview as? TextBlockTableViewCell)?.data as? Block,
            let bullet = PianoBullet(text: textView.text, selectedRange: textView.selectedRange),
            block.plainTextBlock != nil,
            let indexPath = resultsController?.indexPath(forObject: block) else { return }
        
        var selectedRange = textView.selectedRange
        textView.textStorage.replaceCharacters(in: NSMakeRange(0, bullet.baselineIndex), with: "")
        block.replacePlainWith(bullet, on: resultsController, selectedRange: &selectedRange)
        cursorCache = (indexPath, selectedRange)
    }
    
    private func moveCursorForResetForm(in indexPath: IndexPath) {
        let selectedRange = NSMakeRange(0, 0)
        cursorCache = (indexPath, selectedRange)
    }
    
    private func moveCursorTo(_ previousBlock: Block, prevIndexPath indexPath: IndexPath) {
        let selectedRange = NSMakeRange(previousBlock.text?.count ?? 0, 0)
        cursorCache = (indexPath, selectedRange)
    }
}

extension BlockTableViewController: EKEventEditViewDelegate, CNContactViewControllerDelegate {
    
    private func data(detector text: String, with textView: UITextView, using block: Block) {
        let types: NSTextCheckingResult.CheckingType = [.date, .phoneNumber]
        let detector = try? NSDataDetector(types:types.rawValue)
        let matches = detector?.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
        guard let strongMatches = matches else {return}
        
        for match in strongMatches {
            let title = (text as NSString).substring(from: match.range.location + match.range.length)
            if match.resultType == .date {
                guard let date = match.date else {continue}
                if block.type == .checklistText {
                    let state = RecommandBarState.reminder(title: title, date: date)
                    block.detect = Detect(type: .reminder, state: state, range: match.range)
                    appearRecommandView(state)
                } else {
                    let state = RecommandBarState.calendar(title: title, startDate: date)
                    block.detect = Detect(type: .calendar, state: state, range: match.range)
                    appearRecommandView(state)
                }
            } else if match.resultType == .phoneNumber {
                guard let phoneNumber = match.phoneNumber else {continue}
                let state = RecommandBarState.contact(name: title, number: phoneNumber)
                block.detect = Detect(type: .contact, state: state, range: match.range)
                appearRecommandView(state)
            }
        }
    }
    
    internal func appearRecommandView(_ state: RecommandBarState) {
        guard let naviBar = navigationController?.navigationBar else {return}
        guard let naviView = navigationController?.view else {return}
        naviView.subviews.first(where: {$0 is NotificationView})?.removeFromSuperview()
        
        guard let recoView = naviView.createSubviewIfNeeded(NotificationView.self) else {return}
        recoView.didSelect = {self.register(recomand: state)}
        naviView.addSubview(recoView)
        
        switch state {
        case .calendar(let title, let startDate):
            recoView.ibLabel.text = title + " \(DateFormatter.sharedInstance.string(from: startDate))"
        case .reminder(let title, let date):
            recoView.ibLabel.text = title + " \(DateFormatter.sharedInstance.string(from: date))"
        case .contact(let name, let number):
            recoView.ibLabel.text = name + " \(number)"
        case .pasteboard(_): break
        case .restore(_): break
        }
        
        recoView.labelHeightAnchor.constant = naviBar.bounds.height
        recoView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchor = recoView.topAnchor.constraint(equalTo: naviView.topAnchor)
        let leadingAnchor = recoView.leadingAnchor.constraint(equalTo: naviView.leadingAnchor)
        let trailingAnchor = recoView.trailingAnchor.constraint(equalTo: naviView.trailingAnchor)
        let height = naviBar.bounds.height + UIApplication.shared.statusBarFrame.height
        let heightAnchor = recoView.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([topAnchor, leadingAnchor, trailingAnchor, heightAnchor])
        naviView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseInOut, animations: {
            topAnchor.constant = -height
            naviView.layoutIfNeeded()
        }, completion: { finished in
            recoView.removeFromSuperview()
        })
    }
    
    private func disappearRecommandView() {
        guard let naviView = navigationController?.view else {return}
        guard let recoView = naviView.subviews.first(where: {$0 is NotificationView}) else {return}
        recoView.removeFromSuperview()
    }
    
    private func register(recomand state: RecommandBarState) {
        print("action:", state)
        switch state {
        case .calendar(let title, let startDate): break
        case .reminder(let title, let date): break
        case .contact(let name, let number): break
        case .pasteboard(_): break
        case .restore(_): break
        }
        
    }
    
    private func interact(data url: URL) -> Bool {
        let detect = url.absoluteString.components(separatedBy: "/")
        let title = detect[2].removingPercentEncoding ?? ""
        switch detect[1] {
        case DetectType.calendar.rawValue:
            checkCalendarAuth(.event) {
                let eventStore = EKEventStore()
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = detect[3].isoDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                let eventEditVC = EKEventEditViewController()
                eventEditVC.eventStore = eventStore
                eventEditVC.event = event
                eventEditVC.editViewDelegate = self
                self.navigationController?.pushViewController(eventEditVC, animated: true)
                self.disappearRecommandView()
            }
        case DetectType.reminder.rawValue:
            checkCalendarAuth(.reminder) {
                let alert = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
                let reminderAction = UIAlertAction(title: "미리알림 등록", style: .default) { _ in
                    let eventStore = EKEventStore()
                    let reminder = EKReminder(eventStore: eventStore)
                    reminder.title = title
                    reminder.calendar = eventStore.defaultCalendarForNewReminders()
                    do {
                        try eventStore.save(reminder, commit: true)
                        self.reminderAlert(message: "미리알림 등록 성공")
                    } catch {
                        self.reminderAlert(message: "미리알림 등록 실패")
                    }
                }
                let dismissAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(reminderAction)
                alert.addAction(dismissAction)
                self.present(alert, animated: true)
            }
        case DetectType.contact.rawValue:
            let alert = UIAlertController(title: nil, message: detect[3], preferredStyle: .actionSheet)
            let calAction = UIAlertAction(title: "전화하기", style: .default) { _ in
                UIApplication.shared.open(URL(string: "tel://" + detect[3])!, options: [:])
                self.disappearRecommandView()
            }
            let contactAction = UIAlertAction(title: "연락처 등록", style: .default) { _ in
                let contact = CNMutableContact()
                contact.givenName = title
                contact.phoneNumbers.append(CNLabeledValue(label: "", value: CNPhoneNumber(stringValue: detect[3])))
                let contactVC = CNContactViewController(forNewContact: contact)
                contactVC.contactStore = CNContactStore()
                contactVC.delegate = self
                contactVC.allowsActions = false
                self.navigationController?.pushViewController(contactVC, animated: true)
                self.disappearRecommandView()
            }
            let dismissAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(calAction)
            alert.addAction(contactAction)
            alert.addAction(dismissAction)
            present(alert, animated: true)
        default: break
        }
        return detect[0] != DETECT_LINK
    }
    
    private func reminderAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    private func checkCalendarAuth(_ type: EKEntityType, _ completion: @escaping (() -> ())) {
        switch EKEventStore.authorizationStatus(for: type) {
        case .notDetermined:
            EKEventStore().requestAccess(to: type) { status, error in
                DispatchQueue.main.async {
                    switch status {
                    case true : completion()
                    case false : self.eventAuthDeniedAlert(message: "\(type == .event ? "달력" : "미리알림") 권한 주세요.")
                    }
                }
            }
        case .authorized:
            completion()
        case .restricted, .denied:
            eventAuthDeniedAlert(message: "\(type == .event ? "달력" : "미리알림") 권한 주세요.")
        }
    }
    
    private func eventAuthDeniedAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "취소", style: .cancel)
        let settingAction = UIAlertAction(title: "설정", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alert.addAction(settingAction)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        guard action != .canceled else {
            controller.navigationController?.popViewController(animated: true)
            return
        }
        print("EKEventEditViewController didCompleteWith", action)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        guard contact != nil else {
            viewController.navigationController?.popViewController(animated: true)
            return
        }
        print("CNContactViewController didCompleteWith", contact ?? "nil")
    }
    
}
