//
//  AppDelegate.swift
//  Trivia Challenge
//
//  Created by Josh Juster on 5/10/16.
//  Copyright © 2016 Wild Village LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: UIViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let nav = UINavigationController()
        nav.navigationBarHidden = true
        
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        let am = AssetManager.sharedInstance
        let game = am.loadGame()
        
        if (game == nil) {
            AssetManager.sharedInstance.load("FIRSTLOAD", success: { (game : JSON) in
                AssetManager.sharedInstance.saveGame(game, success: {
                    AssetManager.sharedInstance.loadGame()
                    self.viewController = SettingsController()
                    nav.pushViewController(self.viewController!, animated: false)
                }, failure: { (error) in
                    print("ERROR", error)
                })
            }, failure: { (error) in
                print("ERROR", error)
            })
        } else {
            if (am.gameCode()! == "FIRSTLOAD") {
                self.viewController = SettingsController()
            } else {
                am.reloadGameState()
                self.viewController = StartController()
            }
            nav.pushViewController(self.viewController!, animated: false)
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
