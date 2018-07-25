//
//  FacebookDetailTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import Facebook

class FacebookDetailTableViewController: UITableViewController, FacebookCommentDelegate {

    var postData: PostData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let postData = self.postData else {return}
        delegate(postData: postData) { [weak self] in self?.dismiss(animated: true)}
    }
    
    @IBAction func tapWrite(_ sender: UIBarButtonItem) {
        
    }
    
}
