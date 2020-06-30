//
//  AppDelegate.swift
//  VBPopupViewExample
//
//  Created by SOTSYS098 on 30/06/20.
//  Copyright © 2020 VishvaBhatt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // SET UP FOR CONNECTION
        ConnetivitySetup.shared.checkReachability()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ConnetivitySetup.shared.deinintReachabilityNotification()
    }
    
}

