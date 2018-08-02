//
//  AppDelegate.swift
//  Game2048
//
//  Created by kokozu on 21/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UMConfigure.initWithAppkey("55f8fe4de0f55a0ca400480c", channel: "App Store")
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx75fdaa951085d59e", appSecret: "188b8615405a97303c829b752171c572", redirectURL: "http://mobile.umeng.com/social")
    
        return true
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        return result
    }


}

