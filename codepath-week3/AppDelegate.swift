//
//  AppDelegate.swift
//  codepath-week3
//
//  Created by Phuong Nguyen on 9/26/17.
//  Copyright © 2017 Roostertech. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if User.currentUser != nil {
            print("There is a current user")
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let hamburgerVC = storyBoard.instantiateViewController(withIdentifier: "HamburgerViewController") as! HamburgerViewController

            window?.rootViewController = hamburgerVC
            window?.makeKeyAndVisible()

            let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuVC.hamburgerViewController = hamburgerVC
            hamburgerVC.menuViewController = menuVC

        } else {
            print("No current user")
        }
        
//        let hamburgerVC = window!.rootViewController as! HamburgerViewController
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userDidLogout), object: nil, queue: OperationQueue.main) { (Notification) in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateInitialViewController()
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Launched with \(url.description)")
        TwitterClient.sharedInstance.handleOpenUrl(url: url)
        return true
    }
}

