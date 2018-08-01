//
//  SearchResultSectionHeader.swift
//  Block
//
//  Created by hoemoon on 01/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit

class SearchResultSectionHeader: UITableViewHeaderFooterView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    func configure(note: Note) {
        let margins = contentView.layoutMarginsGuide
        backgroundColor = .white
        backgroundView?.backgroundColor = .clear
        titleLabel.text = note.title

        contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: margins.leftAnchor)
        titleLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        titleLabel.sizeToFit()
    }
}
