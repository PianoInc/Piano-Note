//
//  BlockTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class BlockTableViewController: UITableViewController {
    
    //MARK: Data
    
    internal var persistentContainer: NSPersistentContainer!
    internal var context: NSManagedObjectContext!
    
    internal var state: ViewControllerState!
    internal var resultsController: NSFetchedResultsController<Block>?
    private var delayBlockQueue: [() -> Void] = []
    private var selectedBlocks: [Block] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(for: state)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
        //TODO: persistentContainer 가 nil이라는 건 preserve로 왔거나 splitView라는 말임, 따라서 할당해주고, prepare에서 하는 짓을 다시 해줘야함
        if persistentContainer == nil {
            
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0() }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? FolderPickerTableViewController, let barButtonItem = sender as? UIBarButtonItem {
            vc.popoverPresentationController?.barButtonItem = barButtonItem
            
        }
    }

}

extension BlockTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = resultsController?.object(at: indexPath) else { return UITableViewCell() }
        var cell = tableView.dequeueReusableCell(withIdentifier: data.identifier) as! TableDataAcceptable & UITableViewCell
        cell.data = data
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3) ?? UITableViewCellEditingStyle.none
    }
    
    

    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title1Action = UIContextualAction(style: .normal, title:  "대제목", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let data = self?.resultsController?.object(at: indexPath) else { return }
            
            data.set(textStyle: .title1)
            //TODO: 여기서도 코어데이터의 변화가 일어나므로 저장을 해줘야함(모든지 비동기)
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                success(true)
            }
        })
//        title1Action.image
        title1Action.backgroundColor = UIColor(red: 255/255, green: 158/255, blue: 78/255, alpha: 1)
        
        let title2Action = UIContextualAction(style: .normal, title:  "소제목", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let data = self?.resultsController?.object(at: indexPath) else { return }
            
            data.set(textStyle: .title2)
            //TODO: 여기서도 코어데이터의 변화가 일어나므로 저장을 해줘야함(모든지 비동기)
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                success(true)
            }
            
            
        })
//        title1Action.image
        title2Action.backgroundColor = UIColor(red: 253/255, green: 170/255, blue: 86/255, alpha: 1)
        let bodyAction = UIContextualAction(style: .normal, title:  "본문", handler: {[weak self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            guard let data = self?.resultsController?.object(at: indexPath) else { return }
            
            data.set(textStyle: .body)
            //TODO: 여기서도 코어데이터의 변화가 일어나므로 저장을 해줘야함(모든지 비동기)
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .none)
                success(true)
            }
        })
//        title1Action.image
        bodyAction.backgroundColor = UIColor(red: 255/255, green: 181/255, blue: 119/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [title1Action, title2Action, bodyAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let copyAction = UIContextualAction(style: .normal, title:  "복사", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
//        closeAction.image = UIImage(named: "tick")
        let blueColor = UIColor(red: 59/255, green: 141/255, blue: 251/255, alpha: 1)
        copyAction.backgroundColor = blueColor
        
        let deleteAction = UIContextualAction(style: .normal, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        //        closeAction.image = UIImage(named: "tick")
        let redColor = UIColor(red: 255/255, green: 93/255, blue: 90/255, alpha: 1)
        deleteAction.backgroundColor = redColor
        
        
        return UISwipeActionsConfiguration(actions: [deleteAction, copyAction])
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultsController?.object(at: indexPath).didSelectItem(fromVC: self)
        
    }
    
}

extension BlockTableViewController: NSFetchedResultsControllerDelegate {
    
}

extension BlockTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateViews(for: .typing)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard !isCharacter(over: 10000) else { return false }
        return moveCellIfNeeded(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        reactCellHeight(textView)
        switchKeyboardIfNeeded(textView)
//        formatTextIfNeeded(textView)
//        setTableViewOffSetIfNeeded(textView: textView)
    }
    
    //TODO: 클라우드와 연동시켜야함 -> 코어데이터 클래스로 빼놓은 뒤에 합치기
    
    private func formatTextIfNeeded(_ textView: UITextView) {
        //PlainTextBlock이 아니라면 이 작업을 할 필요가 없음.
        guard let block = (textView.superview?.superview as? TextBlockTableViewCell)?.data as? Block,
            let plainTextBlock = block.plainTextBlock,
            let indexPath = resultsController?.indexPath(forObject: block),
            let bullet = PianoBullet(text: textView.text, selectedRange: textView.selectedRange) else { return }
        
        
        
        switch bullet.type {
        case .orderedlist:
            guard let num = Int(bullet.string),
                !bullet.isOverflow else { return }
            
            let correctNum = modifyNumIfNeeded(num, indexPath: indexPath)
            
        
            
            //1. 타입을 지정하고
            block.type = .orderedText
            
            //2. plainText의 count가 1개이면 자신을 코어데이터에서 삭제
            if let plainTextBlockCollection = plainTextBlock.blockCollection, plainTextBlockCollection.count < 2 {
                context.delete(plainTextBlock)
                do {
                    try context.save()
                } catch {
                    print("에러발생!!")
                }
                
                
                //아래 부분을 하지 않아줘도 되는 지 체크하기 print가 nil이어야함
                print("이거 nil이어야함: \(block.plainTextBlock)")
            }
            
            //3. orderedText를 생성하고
            let orderedTextBlock = OrderedTextBlock(context: context)
            orderedTextBlock.num = correctNum
            orderedTextBlock.frontWhitespaces = bullet.whitespaces.string
            orderedTextBlock.text = (textView.text as NSString).substring(from: bullet.baselineIndex)
            
            //4. 이를 block에 연결시킨다.
            orderedTextBlock.addToBlockCollection(block)
            
            //5. NSFetchedResultsController에서 변화를 감지하여 데이터 변화를 UI에 적용되게 한다.
            //TODO: 우선은 직접 변화시켜보기
            tableView.reloadRows(at: [indexPath], with: .none)
            
            adjustAfterOrderByCurrent()
        case .unOrderedlist:
            ()
        case .checkist:
            ()
        }
    }
    
    //현재 숫자만 정정하는 로직만 있으면 된다.구
    private func modifyNumIfNeeded(_ num: Int, indexPath: IndexPath) -> Int64 {
        guard indexPath.row != 0,
            let block = resultsController?
                .object(at: IndexPath(row: indexPath.row - 1,
                                      section: indexPath.section)),
            let textBlock = block.orderedTextBlock else { return Int64(num) }
        return textBlock.num + 1
    }
    
    
    private func adjustAfterOrderByCurrent() {
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        //        presentAlertController(Block, with: URL)
        return true
    }
    
}




//TODO: 다른 파일로 옮기기

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



extension BlockTableViewController {
    
    internal func setCursor(position: CGPoint) {
        let indexPath = tableView.indexPathForRow(at: position)
    }
    
    private func switchKeyboardIfNeeded(_ textView: UITextView) {
        
        if textView.text.count == 0 && textView.keyboardType == .default {
            textView.keyboardType = .twitter
            textView.reloadInputViews()
        } else if textView.text.count != 0 && textView.keyboardType == .twitter {
            textView.keyboardType = .default
            textView.reloadInputViews()
        }
    }
    
    private func reactCellHeight(_ textView: UITextView) {
        let index = textView.text.count
        guard index > 0 else { return }
        
        let lastLineRect = textView.layoutManager.lineFragmentRect(forGlyphAt: index - 1, effectiveRange: nil)
        let textViewHeight = textView.bounds.height
        guard textView.layoutManager.location(forGlyphAt: index - 1).y == 0
            || textViewHeight - (lastLineRect.origin.y + lastLineRect.height) > 20 else {
            return
        }
        tableView.performBatchUpdates(nil, completion: nil)
        
        
    }
    
    private func setTableViewOffSetIfNeeded(textView: UITextView) {
        //텍스트뷰 좌표계에서 커서 위치를 테이블 뷰로 이동시켜 판단

    }
    
    private func presentAlertController(_ Block: Block, with URL: URL) {
        
    }
    
    private func performAlertController(with: URL) {
        
    }
    
    private func isCharacter(over: Int) -> Bool {
        return over > 10000
    }
    
    private func moveCellIfNeeded(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}

extension BlockTableViewController {
    //MARK: State
    
    enum ViewControllerState {
        case normal
        case edit
        case typing
        case highlighting
        case deleted
    }
    
    private func updateViews(for state: ViewControllerState) {
        setBarButtonItems(state: state)
        setViews(state: state)
    }
        
        
    private func setBarButtonItems(state: ViewControllerState) {
        switch state {
        case .normal:
            setNavbarForNormal()
            setToolbarForNormal()
            
        case .edit:
            setNavbarForEdit()
            setToolbarForEdit()
            
        case .highlighting:
            setNavbarForHighlighting()
            setToolbarForHighlighting()
            
        case .deleted:
            setToolbarForTrash()
            
        case .typing:
            setNavbarForTyping()
        }
    }
    
    private func setNavbarForNormal() {
        navigationItem.title = ""
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapEdit(sender:)))
        self.navigationItem.setRightBarButton(editBtn, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    private func setToolbarForNormal() {
        let trashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapTrash(sender:)))
        let folderBtn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(tapFolder(sender:)))
        let highlightBtn = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(tapHighlight(sender:)))
        let sendBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(tapSend(sender:)))
        let composeBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapCompose(sender:)))
        let flexibleWidthBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems(
            [trashBtn, flexibleWidthBtn, folderBtn, flexibleWidthBtn, highlightBtn,
             flexibleWidthBtn, sendBtn, flexibleWidthBtn, composeBtn],
            animated: true)
    }
    
    private func setNavbarForEdit() {
        navigationItem.title = ""
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishEditing(sender:)))
        let selectAllBtn = UIBarButtonItem(title: "전체 복사", style: .plain, target: self, action: #selector(tapCopyAll(sender:)))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(selectAllBtn, animated: true)
        self.navigationItem.setRightBarButton(doneBtn, animated: true)
    }
    
    private func setToolbarForEdit() {
        let copyBtn = UIBarButtonItem(title: "복사하기", style: .plain, target: self, action: #selector(tapCopyParagraphs(sender:)))
        let deleteBtn = UIBarButtonItem(title: "삭제하기", style: .plain, target: self, action: #selector(tapDeleteParagraphs(sender:)))
        let flexibleWidthBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([deleteBtn, flexibleWidthBtn, copyBtn], animated: true)
    }
    
    private func setNavbarForHighlighting() {
        navigationItem.title = "글자에 손을 대고 형광펜 칠하듯 그어보세요"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.setLeftBarButton(nil, animated: true)
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    private func setToolbarForHighlighting() {
        let finishBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishHighlight(sender:)))
        let flexibleWidthBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([flexibleWidthBtn, finishBtn, flexibleWidthBtn], animated: true)
    }
    
    private func setToolbarForTrash() {
        let deleteBtn = UIBarButtonItem(title: "영구삭제", style: .plain, target: self, action: #selector(tapPermanentlyDelete(sender:)))
        let restoreBtn = UIBarButtonItem(title: "복구하기", style: .plain, target: self, action: #selector(tapRestore(sender:)))
        let flexibleWidthBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setToolbarItems([deleteBtn, flexibleWidthBtn, restoreBtn], animated: true)
    }
    
    private func setNavbarForTyping() {
        let completeBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapFinishTyping(sender:)))
        self.navigationItem.setRightBarButton(completeBtn, animated: true)
    }
    
    private func setViews(state: ViewControllerState) {
        
    }
    
    enum RecommandBarState {
        case calendar(title: String, startDate: Date, endDate: Date)
        case reminder(title: String, date: Date)
        case contact(name: String, number: Int)
        case pasteboard(NSAttributedString)
        case restore([(order: Int, Block: Block)])
    }
}
