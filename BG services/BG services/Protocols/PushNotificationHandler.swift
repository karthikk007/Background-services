//
//  PushNotificationHandler.swift
//  BG services
//
//  Created by Karthik on 21/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit
import UserNotifications

protocol NotificationProcessor: LocalPushNotificationProtocol {
    func handleLaunchOption(options: [UIApplication.LaunchOptionsKey: Any]?)
    func processContent(notificationContent: [String: AnyObject])
    func handleNotification(notification: [AnyHashable: Any])
}

extension NotificationProcessor {
    func handleLaunchOption(options: [UIApplication.LaunchOptionsKey: Any]?) {
        let notificationOption = options?[.remoteNotification]
        
        if let notification = notificationOption as? [String: AnyObject] {
            handleNotification(notification: notification)
        }
    }
    
    func handleNotification(notification: [AnyHashable: Any]) {
        if let notificatinContent = notification["aps"] as? [String: AnyObject] {
            
            if notificatinContent["content-available"] as? Int == 1 {
                postNotification("Content Available")
                print("Content Available")
            } 
            
            processContent(notificationContent: notificatinContent)
        }
    }
    
    func processContent(notificationContent: [String: AnyObject]) {
        print(notificationContent)
    }
}

protocol LocalPushNotificationProtocol {
    func postNotification(_ message: String)
}

extension LocalPushNotificationProtocol {
    func postNotification(_ message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Background fetch"
        content.body = message
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notification)
    }
}

protocol RemotePushNotificationProtocol {
    func registerForPushNotifications()
    func getNotificationSettings()
    func deviceToken(from deviceToken: Data)
}

extension RemotePushNotificationProtocol {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                
                let viewAction = UNNotificationAction(
                    identifier: Identifiers.viewAction, title: "View",
                    options: [.foreground])
                
                let newsCategory = UNNotificationCategory(
                    identifier: Identifiers.newsCategory, actions: [viewAction],
                    intentIdentifiers: [], options: [])
                
                UNUserNotificationCenter.current()
                    .setNotificationCategories([newsCategory])
                
                self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            self.registerForRemoteNotifications()
        }
    }
    
    private func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func deviceToken(from deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
}

class PushNotificationHandler: RemotePushNotificationProtocol, LocalPushNotificationProtocol, NotificationProcessor {
    
}

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let newsCategory = "NEWS_CATEGORY"
}
