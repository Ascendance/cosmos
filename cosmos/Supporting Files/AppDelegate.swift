//
//  AppDelegate.swift
//  cosmos
//
//  Created by William Yang on 12/10/18.
//  Copyright © 2018 nibbit. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // see apple documentation
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // see apple documentation
    func applicationWillResignActive(_ application: UIApplication) {
        NSLog("app will become inactive!")
    }

    // see apple documentation
    func applicationDidEnterBackground(_ application: UIApplication) {
        NSLog("app will enter background!")
    }

    // see apple documentation
    func applicationWillEnterForeground(_ application: UIApplication) {
        NSLog("app will enter foreground!")
    }

    // see apple documentation
    func applicationDidBecomeActive(_ application: UIApplication) {
        NSLog("app has become active!")
    }

    // see apple documentation
    func applicationWillTerminate(_ application: UIApplication) {
        NSLog("app is about to terminate!")
    }
}

