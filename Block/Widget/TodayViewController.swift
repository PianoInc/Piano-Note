//
//  TodayViewController.swift
//  Widget
//
//  Created by JangDoRi on 2018. 8. 10..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clipLabel: UILabel!
    
    private var expandHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: return 93.5 * 3 + 15
        default: return 74 * 3 + 25
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        clipLabel.text = "widget_clip_00".loc
        guard UIPasteboard.general.hasStrings else {return}
        clipLabel.text = UIPasteboard.general.string
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        preferredContentSize = maxSize
        guard extensionContext?.widgetActiveDisplayMode == .expanded else {return}
        preferredContentSize = CGSize(width: maxSize.width, height: expandHeight)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        tableView.reloadData()
        completionHandler(.newData)
    }
    
    @IBAction func action(clip: UIButton) {
        
    }
    
    @IBAction func action(note: UIButton) {
        
    }
    
}
