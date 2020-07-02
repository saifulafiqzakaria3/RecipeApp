//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Saiful Afiq  on 29/06/2020.
//  Copyright © 2020 Fourtitude. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// Show main screen which consists of 4 tab views.
    ///
    /// - Parameter activeTabIndex: To set active tab [Optional]
    static func showMainScreen() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            //If main controller already exist
                if delegate.window == nil {
                    delegate.window = UIWindow(frame: UIScreen.main.bounds)
                    delegate.window?.backgroundColor = .white
                }
                //Main controller not exist. Proceed to create it.
                let mainController = RecipeListController()
                //Set main controller to window root view.
                delegate.window?.rootViewController = mainController
                delegate.window?.makeKeyAndVisible()
        }
    }


}

