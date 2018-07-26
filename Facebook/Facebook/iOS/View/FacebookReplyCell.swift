//
//  FacebookReplyCell.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

public class FacebookReplyCell: UITableViewCell, FacebookCell {
    
    @IBOutlet public weak var portrait: UIImageView!
    @IBOutlet public weak var name: UILabel!
    @IBOutlet public weak var message: UILabel!
    @IBOutlet public weak var date: UILabel!
    
    public func configure(_ item: FacebookData, shape: PostRowShape?, at indexPath: IndexPath) {
        guard let data = item as? ReplyData else {return}
        portrait.image = nil
        name.text = "댓댓글 작성자"
        message.text = data.message
        date.text = data.time.group
    }
    
}
