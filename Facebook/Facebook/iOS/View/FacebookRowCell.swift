//
//  FacebookRowCell.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

public class FacebookRowCell: UITableViewCell, FacebookCell {
    
    @IBOutlet public weak var title: UILabel!
    
    public func configure(_ item: FacebookData, shape: PostRowShape?, at indexPath: IndexPath) {
        title.text = item.message
    }
    
}
