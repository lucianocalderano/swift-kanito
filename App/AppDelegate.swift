//
//  AppDelegate.swift
//  Kanito
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanito. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let fb = FBSDKApplicationDelegate.sharedInstance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return fb!.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return fb!.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

