//
//  BlockTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import CoreData

class BlockTableViewController: UIViewController {
    
    //MARK: Data
    
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    internal var persistentContainer: NSPersistentContainer!
    internal var state: ViewControllerState!
    internal var note: Note!
    internal var resultsController: NSFetchedResultsController<Block>?
    private var delayBlockQueue: [() -> Void] = []
    internal var cursorCache: (indexPath: IndexPath, selectedRange: NSRange)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews(for: state)
        fetchData()
        setupTableView()

        //TODO: persistentContainer 가 nil이라는 건 preserve로 왔거나 splitView라는 말임, 따라서 할당해주고, prepare에서 하는 짓을 다시 해줘야함
        if persistentContainer == nil {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unRegisterKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setNoteTitle()
        deleteNoteIfNeeded()
        save()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delayBlockQueue.forEach{ $0() }
        
        let count = resultsController?.sections?.first?.numberOfObjects ?? 0
        if count == 0 {
            tapBackground("firstWriting")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? FolderPickerTableViewController, let barButtonItem = sender as? UIBarButtonItem {
            vc.popoverPresentationController?.barButtonItem = barButtonItem
            
        }
    }

}


extension BlockTableViewController {
    private func fetchData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.resultsController?.performFetch()
            } catch {
                print("BlockTableViewController를 fetch하는 데 에러 발생: \(error.localizedDescription)")
            }
            
            self?.tableView.reloadData()
        }
    }
    
    //50글자를 채워야함. //50글자가 안된다면,
    private func setNoteTitle() {
        guard let controller = resultsController,
            let count = controller.sections?.first?.numberOfObjects,
            count > 0 else { return }
        
        var title = ""
        var subtitle = ""
        for i in 0 ..< count {
            guard subtitle.count < 30 else { break }
            
            let indexPath = IndexPath(row: i, section: 0)
            let block = controller.object(at: indexPath)
            if let text = block.text, text.count != 0 {
                if title.count != 0 {
                    //그 다음 줄 부터는 최대한 많이 보이게 하기 위함
                    subtitle.append(text + "  ")
                } else {
                    //제목같아 보이게 하기 위해 개행
                    title.append(text)
                }
                
            }
        }
        note.title = title.count != 0 ? title : "새로운 메모를 작성해주세요"
        note.subTitle = subtitle.count != 0 ? subtitle : "추가 텍스트 없음"
    }
    
    private func deleteNoteIfNeeded() {
        //블럭이 없거나, 블럭이 1개인데 그게 하필 plain 텍스트 타입이고, 텍스트 카운트가 0인 경우 노트 지우고, 거기에 해당하는 블럭, 연관된 디테일 블럭 지우기
        guard let controller = resultsController,
            let count = controller.fetchedObjects?.count,
            count > 0, (count != 1 || controller.object(at: IndexPath(row: 0, section: 0)).text?.count != 0) else {
                note.deleteWithRelationship()
                return
        }
        
    }
    
    private func setupTableView(){
        tableView.contentInset = tableViewInset
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
    }
    
    private func save() {
        persistentContainer.viewContext.saveIfNeeded()
    }
}





