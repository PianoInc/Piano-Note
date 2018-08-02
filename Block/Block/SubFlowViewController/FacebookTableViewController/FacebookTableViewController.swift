//
//  FacebookTableViewController.swift
//  Block
//
//  Created by Kevin Kim on 2018. 7. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import Facebook

class FacebookTableViewController: UITableViewController, FacebookPostDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            }.didSelectRowAt = { [weak self] in
                self?.performSegue(withIdentifier: "FacebookDetailTableViewController", sender: $0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? FacebookDetailTableViewController {
            guard let postData = sender as? PostData else { return }
            vc.postData = postData
        }
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
