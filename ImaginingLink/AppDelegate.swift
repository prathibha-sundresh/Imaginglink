//
//  AppDelegate.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 12/27/17.
//  Copyright © 2017 Imaginglink Inc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        Thread.sleep(forTimeInterval: 1.5)
        if UserDefaults.standard.bool(forKey: kLoggedIn){
            openDashBoardScreen()
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
    
    func openDashBoardScreen() {

        let storyboard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let tabBarController : UITabBarController = storyboard.instantiateViewController(withIdentifier: "ILTabViewController") as! ILTabViewController
        //let tabbar : [UITabBarItem] = tabBarController.tabBar.items!
        tabBarController.selectedIndex = 1
//        for tabbarItems in tabbar {
//            let items : UITabBarItem = tabbarItems
//            items.title = ""
//            items.imageInsets = UIEdgeInsetsMake(6,0,-6,0)
//        }
        self.window!.rootViewController = tabBarController

    }
    
    func openRegularSignIn() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC : UINavigationController = storyboard.instantiateViewController(withIdentifier: "SignInBaseNavigationController") as! UINavigationController
        self.window!.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
    }


}

