//
//  AppDelegate.swift
//  Birthday Countdown
//
//  Created by Anna Stavropoulos on 8/4/17.
//  Copyright © 2017 Jetmax. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        print(Bundle.main.bundlePath)
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        // Override point for customization after application launch.
        
        
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"), let configDict = NSDictionary(contentsOfFile: path) else  {
            return false
        }
        
        #if BIRTHDAY
            GADMobileAds.configure(withApplicationID: "ca-app-pub-5594325776314197~1097607605")
            let userDefaults = UserDefaults.standard
            if let date = userDefaults.object(forKey: "Date") as? Date {
                var storyboard = UIStoryboard(name: "DateCountdown", bundle: nil)
                let diff = Calendar.current.dateComponents([.day], from: Date(), to: date )

                if diff.day! < 0 {
                    let newDate = Calendar.current.date(byAdding: .year, value: 1, to: date)
                    userDefaults.set(newDate, forKey: "Date")
                }
                
                if diff.day == 0 {
                    storyboard = UIStoryboard(name: "Birthday", bundle: nil)
                }
                self.window?.rootViewController = storyboard.instantiateInitialViewController()
            } else {
                return true
            }
            #endif 
            let applicationId = configDict["AppId"] as! String
            GADMobileAds.configure(withApplicationID: applicationId)
            let storyboard = UIStoryboard(name: "DateCountdown", bundle: nil)
            self.window?.rootViewController = storyboard.instantiateInitialViewController()

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

