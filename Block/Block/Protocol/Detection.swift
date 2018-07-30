//
//  Detection.swift
//  Block
//
//  Created by JangDoRi on 2018. 7. 30..
//  Copyright © 2018년 Piano. All rights reserved.
//

import ContactsUI
import EventKitUI

struct Address: Codable {
    var ranges: [NSRange]
}

struct Contact: Codable {
    var ranges: [NSRange]
}

struct Event: Codable {
    var ranges: [NSRange]
}

struct Link: Codable {
    var ranges: [NSRange]
}

let DETECT_ADDRESS = "DETECT_ADDRESS_" + UUID().uuidString
let DETECT_CONTACT = "DETECT_CONTACT_" + UUID().uuidString
let DETECT_EVENT = "DETECT_EVENT_" + UUID().uuidString
let DETECT_LINK = "DETECT_LINK_" + UUID().uuidString
let DETECT_REMINDER = "DETECT_REMINDER_" + UUID().uuidString

let GOOGLE_URL = URL(string: "http://www.google.com/maps/place")!

protocol Detection {}

extension Detection where Self: BlockTableViewController {
    
    func detect(data text: String, using block: Block) {
        let types: NSTextCheckingResult.CheckingType = [.date, .phoneNumber, .address, .link]
        let detector = try? NSDataDetector(types:types.rawValue)
        
        var address = Address(ranges: [])
        var event = Event(ranges: [])
        var contact = Contact(ranges: [])
        var link = Link(ranges: [])
        
        if let matches = detector?.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count)) {
            for match in matches {
                var title = (text as NSString).substring(from: match.range.location + match.range.length)
                if title.isEmpty {title = (text as NSString).substring(to: match.range.location)}
                if title.isEmpty {title = " "}
                
                switch match.resultType {
                case .address: address.ranges.append(match.range)
                case .date: event.ranges.append(match.range)
                case .phoneNumber: contact.ranges.append(match.range)
                case .link: link.ranges.append(match.range)
                default: break
                }
            }
        }
        
        block.address = address.ranges.isEmpty ? nil : address
        block.event = event.ranges.isEmpty ? nil : event
        block.contact = contact.ranges.isEmpty ? nil : contact
        block.link = link.ranges.isEmpty ? nil : link
    }
    
    func interact(_ textView: UITextView, url: URL, range: NSRange) -> Bool {
        guard let text = textView.text, !text.isEmpty else {return true}
        var title = (text as NSString).substring(from: range.location + range.length)
        if title.isEmpty {title = (text as NSString).substring(to: range.location)}
        let target = (text as NSString).substring(with: range)
        
        guard let dataDetector = target.dataDetector else {return true}
        if let _ = dataDetector as? [NSTextCheckingKey : String] {
            let url = GOOGLE_URL.appendingPathComponent(target)
            guard UIApplication.shared.canOpenURL(url) else {return true}
            UIApplication.shared.open(url, options: [:])
        } else if let phoneNumber = dataDetector as? String {
            let actionSheet = UIAlertController(title: nil, message: phoneNumber, preferredStyle: .actionSheet)
            let callAction = UIAlertAction(title: "전화하기", style: .default) { _ in
                guard let url = URL(string: "tel://" + phoneNumber), UIApplication.shared.canOpenURL(url) else {return}
                UIApplication.shared.open(url, options: [:])
            }
            let contactAction = UIAlertAction(title: "연락처 등록", style: .default) { _ in
                let contact = CNMutableContact()
                contact.familyName = title
                contact.phoneNumbers.append(CNLabeledValue(label: "", value: CNPhoneNumber(stringValue: phoneNumber)))
                let contactVC = CNContactViewController(forNewContact: contact)
                contactVC.contactStore = CNContactStore()
                contactVC.delegate = self
                contactVC.allowsActions = false
                self.navigationController?.pushViewController(contactVC, animated: true)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            actionSheet.addAction(callAction)
            actionSheet.addAction(contactAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
        } else if let eventDate = dataDetector as? Date {
            eventAuth(check: url.absoluteString) {
                switch url.absoluteString {
                case DETECT_EVENT:
                    let eventStore = EKEventStore()
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = eventDate
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    let eventEditVC = EKEventEditViewController()
                    eventEditVC.eventStore = eventStore
                    eventEditVC.event = event
                    eventEditVC.editViewDelegate = self
                    self.navigationController?.pushViewController(eventEditVC, animated: true)
                case DETECT_REMINDER:
                    let actionSheet = UIAlertController(title: nil, message: target + title, preferredStyle: .actionSheet)
                    let reminderAction = UIAlertAction(title: "미리알림 등록", style: .default) { _ in
                        let eventStore = EKEventStore()
                        let reminder = EKReminder(eventStore: eventStore)
                        reminder.title = title
                        reminder.addAlarm(EKAlarm(absoluteDate: eventDate))
                        reminder.calendar = eventStore.defaultCalendarForNewReminders()
                        do {
                            try eventStore.save(reminder, commit: true)
                            self.reminderResult(alert: "미리알림 등록 성공")
                        } catch {
                            self.reminderResult(alert: "미리알림 등록 실패")
                        }
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    actionSheet.addAction(reminderAction)
                    actionSheet.addAction(cancelAction)
                    self.present(actionSheet, animated: true)
                default: break
                }
            }
        } else if let linkURL = dataDetector as? URL {
            guard UIApplication.shared.canOpenURL(linkURL) else {return true}
            UIApplication.shared.open(linkURL, options: [:])
        }
        
        return false
    }
    
    private func eventAuth(check type: String, _ completion: @escaping (() -> ())) {
        let type: EKEntityType = (type == DETECT_EVENT) ? .event : .reminder
        let message = (type == .event) ? "달력 권한 주세요." : "미리알림 권한 주세요."
        switch EKEventStore.authorizationStatus(for: type) {
        case .notDetermined:
            EKEventStore().requestAccess(to: type) { status, error in
                DispatchQueue.main.async {
                    switch status {
                    case true : completion()
                    case false : self.eventAuth(alert: message)
                    }
                }
            }
        case .authorized: completion()
        case .restricted, .denied: eventAuth(alert: message)
        }
    }
    
    private func eventAuth(alert message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let settingAction = UIAlertAction(title: "설정", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        present(alert, animated: true)
    }
    
    private func reminderResult(alert message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
}

extension Detection where Self: TextBlockTableViewCell {
    
    func detectToAttribute(using block: Block) {
        guard !ibTextView.text.isEmpty else {return}
        let mAttr = NSMutableAttributedString(string: ibTextView.text, attributes: [.font : ibTextView.font!,
                                                                                    .foregroundColor : ibTextView.textColor!])
        if let address = block.address?.ranges {
            address.forEach {mAttr.addAttributes([.link : URL(string: DETECT_ADDRESS)!], range: $0)}
        }
        if let contact = block.contact?.ranges {
            contact.forEach {mAttr.addAttributes([.link : URL(string: DETECT_CONTACT)!], range: $0)}
        }
        if let event = block.event?.ranges {
            let url = URL(string: (block.type == .checklistText) ? DETECT_REMINDER : DETECT_EVENT)!
            event.forEach {mAttr.addAttributes([.link : url], range: $0)}
        }
        if let link = block.link?.ranges {
            link.forEach {mAttr.addAttributes([.link : URL(string: DETECT_LINK)!], range: $0)}
        }
        
        ibTextView.attributedText = mAttr
    }
    
}
