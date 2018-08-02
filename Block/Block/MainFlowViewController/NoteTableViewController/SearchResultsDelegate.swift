//
//  SearchResultsDataSource.swift
//  Block
//
//  Created by hoemoon on 01/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsDelegate: NSObject {
    weak var noteTableViewController: NoteTableViewController?
    weak var resultsController: NSFetchedResultsController<Note>?
    var searchResults = [NoteTableViewController.SearchResult]()
    var selectedBlock: Block?
}

extension SearchResultsDelegate: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults[section].arributedStrings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultBlockCell", for: indexPath) as? SearchResultBlockCell {
            let attributedString = searchResults[indexPath.section].arributedStrings[indexPath.row]
            cell.label.attributedText = attributedString
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchResultsDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let noteTableVC = noteTableViewController else { return }
        let note = searchResults[indexPath.section].note
        let block = searchResults[indexPath.section].blocks[indexPath.row]
        selectedBlock = block
        note.didSelectItem(fromVC: noteTableVC)
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchResultSectionHeader") as? SearchResultSectionHeader {
            header.configure(note: searchResults[section].note)
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchResultSectionFooter") as? SearchResultSectionFooter {
            footer.configure(note: searchResults[section].note)

            return footer
        }
        return nil
    }

}
