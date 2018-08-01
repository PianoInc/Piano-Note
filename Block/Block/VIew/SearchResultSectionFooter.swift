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
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)

        return view
    }()

    lazy var dateFomatter: DateFormatter = {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return fomatter
    }()

    func configure(note: Note) {
        if let date = note.modifiedDate {
            dateLabel.text = dateFomatter.string(from: date)
        }
        let margins = contentView.layoutMarginsGuide
        backgroundView = UIView(frame: self.bounds)
        backgroundView?.backgroundColor = .white

        contentView.addSubview(dateLabel)
        contentView.addSubview(separator)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        separator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
