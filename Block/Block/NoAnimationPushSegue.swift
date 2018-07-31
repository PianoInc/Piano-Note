//
//  NoAnimationPushSegue.swift
//  Block
//
//  Created by hoemoon on 31/07/2018.
//  Copyright © 2018 Piano. All rights reserved.
//

import UIKit

class NoAnimationPushSegue: UIStoryboardSegue {
    override func perform() {
        self.source.navigationController?.pushViewController(destination, animated: false)
    }
}
