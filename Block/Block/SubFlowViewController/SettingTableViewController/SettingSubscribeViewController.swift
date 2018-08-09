//
//  SettingSubscribeViewController.swift
//  Block
//
//  Created by JangDoRi on 2018. 8. 9..
//  Copyright © 2018년 Piano. All rights reserved.
//

import UIKit

class SettingSubscribeViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label11: UILabel!
    @IBOutlet weak var label12: UILabel!
    @IBOutlet weak var label13: UILabel!
    @IBOutlet weak var label14: UILabel!
    @IBOutlet weak var label15: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = "setting_subscribe_01".loc
        label2.text = "setting_subscribe_02".loc
        label3.text = "setting_subscribe_03".loc
        label4.text = "setting_subscribe_04".loc
        label5.text = "setting_subscribe_05".loc
        label6.text = "setting_subscribe_06".loc
        label7.text = "setting_subscribe_07".loc
        label8.text = "setting_subscribe_08".loc
        label9.text = "setting_subscribe_09".loc
        label10.text = "setting_subscribe_10".loc
        label11.text = "setting_subscribe_11".loc
        label12.text = "setting_subscribe_12".loc
        label13.text = "setting_subscribe_13".loc
        label14.text = "setting_subscribe_14".loc
        label15.text = "setting_subscribe_15".loc
        button2.setTitle("setting_subscribe_16".loc, for: .normal)
        button2.setTitle("setting_subscribe_17".loc, for: .normal)
    }
    
    @IBAction private func action(month: UIButton) {
        
    }
    
    @IBAction private func action(annual: UIButton) {
        
    }
    
    @IBAction private func action(shortcut: UIButton) {
        
    }
    
}
