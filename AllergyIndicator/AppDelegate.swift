//
//  AppDelegate.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/21/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import Firebase
import Clarifai_Apple_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure Firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        // Launch Clarifai SDK
        let apikey = ConstantsAPI.clarifaiapi.key
        Clarifai.sharedInstance().start(apiKey: apikey)

        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = attributes

        IAPHelper.shared.getProducts()

        // Configure LoginViewController
        configureInitialRootViewController(for: window)
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


}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        let initialPicturesCount = 20
        
        if let _ = Auth.auth().currentUser,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = try? JSONDecoder().decode(User.self, from: userData) {
            if let pictureData = defaults.object(forKey: Constants.UserDefaults.currentPicture) as? Data,
                let picture = try? JSONDecoder().decode(Pictures.self, from: pictureData) {
                Pictures.setCurrent(picture)
            } else {
                let pictureCount = initialPicturesCount
                Pictures.setCurrent(Pictures(numpictures: pictureCount), writeToUserDefaults: true)
            }
            // initialize the current user everytime the app loads
            User.setCurrent(user)
            print("Pictures the current user has \(Pictures.current.numpictures)")
            initialViewController = UIStoryboard.initializeViewController(for: .main)
        } else {
            if let pictureData = defaults.object(forKey: Constants.UserDefaults.currentPicture) as? Data,
                let picture = try? JSONDecoder().decode(Pictures.self, from: pictureData) {
                Pictures.setCurrent(picture)
            } else {
                let pictureCount = initialPicturesCount
                Pictures.setCurrent(Pictures(numpictures: pictureCount), writeToUserDefaults: true)
            }
            initialViewController = UIStoryboard.initializeViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

