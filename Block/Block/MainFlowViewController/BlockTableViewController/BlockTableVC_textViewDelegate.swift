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
        return interect(link: URL)
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
            block.text = frontText
            block.modifiedDate = Date()
            block.insertNextBlock(with: behindText, on: resultsController)
            
            var indexPath = indexPath
            indexPath.row += 1
            let selectedRange = NSMakeRange(0, 0)
            cursorCache = (indexPath, selectedRange)
            
            detect(data: frontText, with: textView, using: block)
            
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
        block.text = textView.text
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
    
    private typealias DetectData = (event: Event?, contact: Contact?, address: Address?, link: Link?)
    
    private func detect(data text: String, with textView: UITextView, using block: Block) {
        let types: NSTextCheckingResult.CheckingType = [.date, .phoneNumber, .address, .link]
        let detector = try? NSDataDetector(types:types.rawValue)
        guard let matches = detector?.matches(in: text, options: .reportProgress, range: NSMakeRange(0, text.count)) else {return}
        
        var event = Event(data: nil)
        var contact = Contact(data: nil)
        var address = Address(data: nil)
        var link = Link(data: nil)
        
        for (index, match) in matches.enumerated() {
            var title = (text as NSString).substring(from: match.range.location + match.range.length)
            if title.isEmpty {title = (text as NSString).substring(to: match.range.location)}
            if title.isEmpty {title = " "}
            if match.resultType == .date {
                guard let date = match.date else {return}
                if event.data == nil {event.data = []}
                event.data?.append(Event.Data(title: title, date: date, range: match.range))
            } else if match.resultType == .phoneNumber {
                guard let number = match.phoneNumber else {return}
                if contact.data == nil {contact.data = []}
                contact.data?.append(Contact.Data(name: title, number: number, range: match.range))
            } else if match.resultType == .address {
                if address.data == nil {address.data = []}
                address.data?.append(match.range)
            } else if match.resultType == .link {
                if link.data == nil {link.data = []}
                link.data?.append(match.range)
            }
            guard index == 0 else {continue}
            let detectData = DetectData(event: event, contact: contact, address: address, link: link)
            showRecommandView(detectData, isReminder: block.type == .checklistText, with: textView)
        }
        
        block.event = event
        block.contact = contact
        block.address = address
        block.link = link
    }
    
    private func showRecommandView(_ detectData: DetectData, isReminder: Bool, with textView: UITextView) {
        guard let naviBar = navigationController?.navigationBar else {return}
        guard let naviView = navigationController?.view else {return}
        naviView.subviews.first(where: {$0 is NotificationView})?.removeFromSuperview()
        guard let recoView = naviView.createSubviewIfNeeded(NotificationView.self) else {return}
        let height = naviBar.bounds.height + UIApplication.shared.statusBarFrame.height
        recoView.frame = CGRect(x: 0, y: 0, width: naviView.bounds.width, height: height)
        naviView.addSubview(recoView)
        
        var isSelected = false
        recoView.didSelect = {
            isSelected = true
            self.interact(view: recoView, detectData: detectData, isReminder)
        }
        
        if let event = detectData.event?.data?.first {
            let date = (textView.text as NSString).substring(with: event.range)
            recoView.ibLabel.text = "\(event.title ?? "")\n\(date)"
        } else if let contact = detectData.contact?.data?.first {
            recoView.ibLabel.text = "\(contact.name ?? "")\n\(contact.number)"
        } else if let address = detectData.address?.data?.first {
            recoView.ibLabel.text = "\((textView.text as NSString).substring(with: address))"
        } else if let link = detectData.link?.data?.first {
            recoView.ibLabel.text = "\((textView.text as NSString).substring(with: link))"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard !isSelected else {return}
            UIView.animate(withDuration: 0.3, animations: {
                recoView.frame.origin.y = -height
            }, completion: { finished in
                recoView.removeFromSuperview()
            })
        }
    }
    
    private func hideRecommandView() {
        guard let naviView = navigationController?.view else {return}
        naviView.subviews.first(where: {$0 is NotificationView})?.removeFromSuperview()
    }
    
    private func interact(view: NotificationView, detectData: DetectData, _ isReminder: Bool) {
        if let eventData = detectData.event?.data?.first {
            if !isReminder {
                eventAuth(check: .event) {
                    let eventStore = EKEventStore()
                    let event = EKEvent(eventStore: eventStore)
                    event.title = eventData.title
                    event.startDate = eventData.date
                    event.endDate = eventData.date.addingTimeInterval(3600)
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent, commit: true)
                        view.ibLabel.text = "일정 등록 성공"
                    } catch {
                        view.ibLabel.text = "일정 등록 실패"
                    }
                }
            } else {
                eventAuth(check: .reminder) {
                    let eventStore = EKEventStore()
                    let reminder = EKReminder(eventStore: eventStore)
                    reminder.title = eventData.title
                    reminder.completionDate = eventData.date
                    reminder.calendar = eventStore.defaultCalendarForNewReminders()
                    do {
                        try eventStore.save(reminder, commit: true)
                        view.ibLabel.text = "미리알림 등록 성공"
                    } catch {
                        view.ibLabel.text = "미리알림 등록 실패"
                    }
                }
            }
        } else if let contactData = detectData.contact?.data?.first {
            let contact = CNMutableContact()
            contact.givenName = contactData.name ?? ""
            contact.phoneNumbers.append(CNLabeledValue(label: "", value: CNPhoneNumber(stringValue: contactData.number)))
            let request = CNSaveRequest()
            request.add(contact, toContainerWithIdentifier: nil)
            do {
                try CNContactStore().execute(request)
                view.ibLabel.text = "연락처 등록 성공"
            } catch {
                view.ibLabel.text = "연락처 등록 실패"
            }
        } else if let addressData = detectData.address?.data?.first {
            print("address", addressData)
        } else if let linkData = detectData.link?.data?.first {
            print("link", linkData)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.3, animations: {
                view.frame.origin.y = -view.bounds.height
            }, completion: { finished in
                view.removeFromSuperview()
            })
        }
    }
    
    private func interect(link url: URL) -> Bool {
        let urlData = url.absoluteString.components(separatedBy: "/")
        print("urlData :", urlData)
        
        if urlData[0] == DETECT_EVENT {
            eventAuth(check: .event) {
                let eventStore = EKEventStore()
                let event = EKEvent(eventStore: eventStore)
                event.title = urlData[1].removingPercentEncoding
                event.startDate = urlData[3].isoDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                let eventEditVC = EKEventEditViewController()
                eventEditVC.eventStore = eventStore
                eventEditVC.event = event
                eventEditVC.editViewDelegate = self
                self.navigationController?.pushViewController(eventEditVC, animated: true)
                self.hideRecommandView()
            }
        } else if urlData[0] == DETECT_REMINDER {
            eventAuth(check: .reminder) {
                let alert = UIAlertController(title: nil, message: urlData[2].removingPercentEncoding, preferredStyle: .actionSheet)
                let reminderAction = UIAlertAction(title: "미리알림 등록", style: .default) { _ in
                    let eventStore = EKEventStore()
                    let reminder = EKReminder(eventStore: eventStore)
                    reminder.title = urlData[2].removingPercentEncoding
                    reminder.completionDate = urlData[3].isoDate
                    reminder.calendar = eventStore.defaultCalendarForNewReminders()
                    do {
                        try eventStore.save(reminder, commit: true)
                        self.reminderResult(alert: "미리알림 등록 성공")
                    } catch {
                        self.reminderResult(alert: "미리알림 등록 실패")
                    }
                    self.hideRecommandView()
                }
                let dismissAction = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(reminderAction)
                alert.addAction(dismissAction)
                self.present(alert, animated: true)
            }
        } else if urlData[0] == DETECT_CONTACT {
            let alert = UIAlertController(title: nil, message: urlData[2], preferredStyle: .actionSheet)
            let calAction = UIAlertAction(title: "전화하기", style: .default) { _ in
                UIApplication.shared.open(URL(string: "tel://" + urlData[2])!, options: [:])
                self.hideRecommandView()
            }
            let contactAction = UIAlertAction(title: "연락처 등록", style: .default) { _ in
                let contact = CNMutableContact()
                contact.givenName = urlData[1].removingPercentEncoding ?? ""
                contact.phoneNumbers.append(CNLabeledValue(label: "", value: CNPhoneNumber(stringValue: urlData[2])))
                let contactVC = CNContactViewController(forNewContact: contact)
                contactVC.contactStore = CNContactStore()
                contactVC.delegate = self
                contactVC.allowsActions = false
                self.navigationController?.pushViewController(contactVC, animated: true)
                self.hideRecommandView()
            }
            let dismissAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(calAction)
            alert.addAction(contactAction)
            alert.addAction(dismissAction)
            present(alert, animated: true)
        } else if urlData[0] == DETECT_ADDRESS {
            print("address")
        } else if urlData[0] == DETECT_LINK {
            print("link")
        }
        
        return !(urlData[0] == DETECT_EVENT || urlData[0] == DETECT_REMINDER ||
            urlData[0] == DETECT_CONTACT || urlData[0] == DETECT_ADDRESS || urlData[0] == DETECT_LINK)
    }
    
    private func eventAuth(check type: EKEntityType, _ completion: @escaping (() -> ())) {
        switch EKEventStore.authorizationStatus(for: type) {
        case .notDetermined:
            EKEventStore().requestAccess(to: type) { status, error in
                DispatchQueue.main.async {
                    switch status {
                    case true : completion()
                    case false : self.eventAuth(alert: "\(type == .event ? "달력" : "미리알림") 권한 주세요.")
                    }
                }
            }
        case .authorized: completion()
        case .restricted, .denied: eventAuth(alert: "\(type == .event ? "달력" : "미리알림") 권한 주세요.")
        }
    }
    
    private func eventAuth(alert message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "취소", style: .cancel)
        let settingAction = UIAlertAction(title: "설정", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alert.addAction(settingAction)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    private func reminderResult(alert message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        if action == .canceled {controller.navigationController?.popViewController(animated: true)}
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        if contact == nil {viewController.navigationController?.popViewController(animated: true)}
    }
    
}
