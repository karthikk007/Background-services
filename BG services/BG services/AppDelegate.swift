//
//  AppDelegate.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit
import UserNotifications
import BackgroundTasks
import SafariServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //
    // MARK: - Variables And Properties
    //
    var notificationhandler = PushNotificationHandler()
    var backgroundSessionCompletionHandler: (() -> Void)?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        notificationhandler.handleLaunchOption(options: launchOptions)
        registerBackgroundFetch()
        registerNotification()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("performing background fetch")
        
        performBackgroundFetch { (result) in
            completionHandler(result)
        }
    }
    
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession handleEventsForBackgroundURLSessionidentifier: String,
                     completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
}

//MARK: background fetch
extension AppDelegate {
    
    func registerBackgroundFetch() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        checkBackgroundFetchStatus()
    }
    
    func checkBackgroundFetchStatus() {
        let status = UIApplication.shared.backgroundRefreshStatus
        
        switch status {
        case .available:
            print("backgroundRefreshStatus = available")
        case .denied:
            print("backgroundRefreshStatus = denied")
        case .restricted:
            print("backgroundRefreshStatus = restricted")
        @unknown default:
            fatalError()
        }
        
    }
    
    func performBackgroundFetch(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let application = UIApplication.shared
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        if let tabBarController = application.keyWindow?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers {
            for viewController in viewControllers {
                if let fetchController = viewController as? FetchViewController {
                    fetchController.fetchData {
                        fetchController.updateUI()
                        notificationhandler.postNotification("new data available")
                        completionHandler(.noData)
                    }
                }
            }
        }
    }
}

//MARK: Handle Notifications
extension AppDelegate {
    
    func registerNotification() {
        UNUserNotificationCenter.current().delegate = self
        notificationhandler.registerForPushNotifications()
    }
    
    func scheduleNotifications() {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationhandler.deviceToken(from: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
         print("didReceiveRemoteNotification xxx")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification")
        
        guard let _ = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
    
        performBackgroundFetch(completionHandler: completionHandler)
        notificationhandler.handleNotification(notification: userInfo)
    }
    
}

//MARK: Handle UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceive response")
        
        let userInfo = response.notification.request.content.userInfo
        
        notificationhandler.handleNotification(notification: userInfo)
        
        if response.actionIdentifier == Identifiers.viewAction,
            let aps = userInfo["aps"] as? [String: AnyObject],
            let url = aps["link_url"] as? String,
            let link = URL(string: url),
            let win = UIApplication.shared.keyWindow {
            print("didReceive response view tapped")
            let safari = SFSafariViewController(url: link)
            win.rootViewController?.present(safari, animated: true,
                                             completion: nil)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent notification")
        completionHandler(.alert)
    }
}
