//
//  NoteTavleVC_search.swift
//  Block
//
//  Created by hoemoon on 01/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit

extension NoteTableViewController: UISearchResultsUpdating {
    struct SearchResult {
        let note: Note
        var arributedStrings: [NSAttributedString] = []
    }

    internal func setupSearchViewController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        searchResultsViewController?.tableView.dataSource = searchResultsDelegate
        searchResultsViewController?.tableView.delegate = searchResultsDelegate
        searchResultsViewController?.tableView.rowHeight = UITableViewAutomaticDimension
        searchResultsViewController?.tableView.estimatedRowHeight = 140
        searchResultsViewController?.tableView.register(SearchResultSectionHeader.self, forHeaderFooterViewReuseIdentifier: "SearchResultSectionHeader")
        searchResultsViewController?.tableView.register(SearchResultSectionFooter.self, forHeaderFooterViewReuseIdentifier: "SearchResultSectionFooter")
        searchResultsViewController?.tableView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text,
            let notes = resultsController?.fetchedObjects,
            searchController.isActive else { return }

        searchResultsDelegate.searchResults = notes.map { convert(note: $0, with: keyword) }
            .filter { $0 != nil }
            .map { $0! }
        searchResultsViewController?.tableView.reloadData()
    }

    private func convert(note: Note, with keyword: String) -> SearchResult? {
        guard let blocks = note.blockCollection?.allObjects as? [Block] else { return nil }
        var result = SearchResult(note: note, arributedStrings: [])

        for block in blocks {
            if let plain = block.plainTextBlock,
                let text = plain.text,
                let range = text.lowercased().range(of: keyword.lowercased()) {
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttributes([NSAttributedStringKey.foregroundColor : self.view.tintColor], range: NSRange(range, in: text))
                result.arributedStrings.append(attributedString)
            }
        }
        if result.arributedStrings.isEmpty {
            return nil
        }
        return result
    }
}

