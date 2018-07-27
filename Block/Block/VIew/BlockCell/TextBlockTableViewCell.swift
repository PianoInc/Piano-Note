//
//  TextBlockTableViewCell.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class TextBlockTableViewCell: UITableViewCell, TableDataAcceptable {
    @IBOutlet weak var ibButton: UIButton!
    @IBOutlet weak var ibLabel: UILabel!
    @IBOutlet weak var ibTextView: BlockTextView!
    @IBOutlet weak var ibTextViewLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var ibButtonLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var ibLabelLeadingAnchor: NSLayoutConstraint!
    
    var data: TableDatable? {
        didSet {
            guard let block = data as? Block else { return }
            switch block.type {
            case .plainText:
                guard let plainTextBlock = block.plainTextBlock else { return }
                ibLabel.isHidden = true
                ibButton.isHidden = true
                
                ibTextView.font = plainTextBlock.font
                ibTextView.text = plainTextBlock.text ?? ""
                ibTextViewLeadingAnchor.constant = 0
                /*
                 //이미지, json, detector은 전부 비동기
                 DispatchQueue.global().async {
                 //
                 }
                 */
            case .checklistText:
                guard let checklistTextBlock = block.checklistTextBlock else { return }
                ibLabel.isHidden = true
                ibButton.isHidden = false
                
                let font = checklistTextBlock.font
                ibTextView.font = font
                ibLabel.font = ibLabel.font.withSize(font.pointSize)
                ibTextView.text = checklistTextBlock.text ?? ""
                ibTextViewLeadingAnchor.constant = ibButton.frame.width + 8
                ibButtonLeadingAnchor.constant = 0
                ibLabelLeadingAnchor.constant = 0
                
                self.ibButton.isSelected = checklistTextBlock.isSelected
                
                if let whitespaceStr = checklistTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        ibTextViewLeadingAnchor.constant += width
                        ibButtonLeadingAnchor.constant += width
                        ibLabelLeadingAnchor.constant += width
                    }
                }
                
                /*
                 //이미지, json은 전부 비동기
                 DispatchQueue.main.async { [weak self] in
                 //TODO: JSON 로직
                 }
                 */
                
            case .orderedText:
                guard let orderedTextBlock = block.orderedTextBlock else { return }
                ibLabel.isHidden = false
                ibButton.isHidden = true
                
                let font = orderedTextBlock.font
                ibTextView.font = font
                ibLabel.font = ibLabel.font.withSize(font.pointSize)
                ibTextView.text = orderedTextBlock.text ?? ""
                ibLabel.text = "\(orderedTextBlock.num)."
                ibLabel.sizeToFit()
                ibTextViewLeadingAnchor.constant = ibLabel.frame.width + 8
                ibButtonLeadingAnchor.constant = 0
                ibLabelLeadingAnchor.constant = 0
                
                
                if let whitespaceStr = orderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        ibTextViewLeadingAnchor.constant += width
                        ibButtonLeadingAnchor.constant += width
                        ibLabelLeadingAnchor.constant += width
                    }
                }
                
                /*
                 //이미지, json은 전부 비동기
                 DispatchQueue.main.async { [weak self] in
                 //TODO: JSON 로직
                 }
                 */
                
            case .unOrderedText:
                guard let unOrderedTextBlock = block.unOrderedTextBlock else { return }
                ibLabel.isHidden = false
                ibButton.isHidden = true
                
                let font = unOrderedTextBlock.font
                ibTextView.font = font
                ibLabel.font = ibLabel.font.withSize(font.pointSize)
                ibTextView.text = unOrderedTextBlock.text ?? ""
                ibLabel.text = "• "  //TODO: 이거 나중에 얼마든지 바뀔 수 있기 때문에 리펙토링 할 것
                ibLabel.sizeToFit()
                ibTextViewLeadingAnchor.constant = ibLabel.frame.width + 8
                ibButtonLeadingAnchor.constant = 0
                ibLabelLeadingAnchor.constant = 0
                
                
                if let whitespaceStr = unOrderedTextBlock.frontWhitespaces as NSString? {
                    let width = whitespaceStr.size(withAttributes: [.font : font]).width
                    if width > 0 {
                        ibTextViewLeadingAnchor.constant += width
                        ibButtonLeadingAnchor.constant += width
                        ibLabelLeadingAnchor.constant += width
                    }
                }
                
                /*
                 //이미지, json은 전부 비동기
                 DispatchQueue.main.async { [weak self] in
                 //TODO: JSON 로직
                 }
                 */
                
            default:
                print("cannot invoked")
            }
            detect(link: block)
        }
    }
    
    private func detect(link block: Block) {
        guard !ibTextView.text.isEmpty else {return}
        let mAttr = NSMutableAttributedString(string: ibTextView.text, attributes: [.font : ibTextView.font!, .foregroundColor : ibTextView.textColor!])
        if let event = block.event?.data {
            event.forEach {
                var url = URL(string: (block.type == .checklistText) ? DETECT_REMINDER : DETECT_EVENT)!
                url.appendPathComponent($0.title ?? "")
                url.appendPathComponent((ibTextView.text as NSString).substring(with: $0.range))
                url.appendPathComponent($0.date.isoString)
                mAttr.addAttributes([.link : url], range: $0.range)
            }
        }
        if let contact = block.contact?.data {
            contact.forEach {
                var url = URL(string: DETECT_CONTACT)!
                url.appendPathComponent($0.name ?? "")
                url.appendPathComponent($0.number)
                mAttr.addAttributes([.link : url], range: $0.range)
            }
        }
        if let address = block.address?.data {
            address.forEach {
                var url = URL(string: DETECT_ADDRESS)!
                url.appendPathComponent((ibTextView.text as NSString).substring(with: $0))
                mAttr.addAttributes([.link : url], range: $0)
            }
        }
        if let link = block.link?.data {
            link.forEach {
                var url = URL(string: DETECT_LINK)!
                url.appendPathComponent((ibTextView.text as NSString).substring(with: $0))
                mAttr.addAttributes([.link : url], range: $0)
            }
        }
        guard mAttr.attributes(at: 0, effectiveRange: nil).contains(where: {$0.key == .link}) else {return}
        ibTextView.attributedText = mAttr
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let block = data as? Block,
            let checklistTextBlock = block.checklistTextBlock else { return }
        checklistTextBlock.isSelected = sender.isSelected
    }
    
}
