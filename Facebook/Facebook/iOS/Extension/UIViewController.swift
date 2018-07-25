//
//  UIViewController.swift
//  Facebook_iOS
//
//  Created by JangDoRi on 2018. 7. 24..
//  Copyright © 2018년 piano. All rights reserved.
//

import FBSDKLoginKit

internal extension UIViewController {
    
    /**
     - parameter viewCtrl : ViewController context.
     - parameter isReady : 로그인 결과.
     */
    internal func facebookLogin(_ isReady: @escaping ((Bool) -> ())) {
        if FBSDKAccessToken.current() != nil {
            isReady(true)
            return
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: ["public_profile"], from: self) { result, _ in
            if let result = result, !result.isCancelled {
                isReady(true)
            } else {
                isReady(false)
            }
        }
    }
    
}
