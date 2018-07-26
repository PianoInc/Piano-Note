//
//  FacebookCommentCell.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

public class FacebookCommentCell: UITableViewCell, FacebookCell {
    
    @IBOutlet public weak var portrait: UIImageView!
    @IBOutlet public weak var name: UILabel!
    @IBOutlet public weak var message: UILabel!
    @IBOutlet public weak var reply: UIButton!
    @IBOutlet public weak var date: UILabel!
    
    public func configure(_ item: FacebookData, shape: PostRowShape?, at indexPath: IndexPath) {
        guard let data = item as? CommentData else {return}
        portrait.image = nil
        name.text = "댓글 작성자"
        message.text = data.message
        
        reply.isUserInteractionEnabled = false
        reply.isEnabled = data.hasReply
        reply.setTitle("replyNoCount".loc, for: .normal)
        if data.replyCount > 0 {
            reply.setTitle(String(format: "replyCount".loc, data.replyCount), for: .normal)
        }
        date.text = data.time.group
    }
    
}
