//
//  SearchResultSectionFooter.swift
//  Block
//
//  Created by hoemoon on 01/08/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit

class SearchResultSectionFooter: UITableViewHeaderFooterView {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func configure(note: Note) {
        let margins = contentView.layoutMarginsGuide
        backgroundColor = .white
        backgroundView?.backgroundColor = .clear
        dateLabel.text = "footer"

        contentView.addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: margins.leftAnchor)
        dateLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        dateLabel.sizeToFit()

    }
}
