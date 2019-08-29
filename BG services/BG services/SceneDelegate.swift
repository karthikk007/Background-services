//
//  SceneDelegate.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var shortcutItem: UIApplicationShortcutItem?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        if let shortcutItem = connectionOptions.shortcutItem {
            self.shortcutItem = shortcutItem
        }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        launchTabVC()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

//MARK: handle shortcut
extension SceneDelegate {
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem: shortcutItem))
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem: shortcutItem))
    }
    
    func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var shortcutIdentified = false
        
        guard let type = shortcutItem.type.components(separatedBy: ".").last else {
            return shortcutIdentified
        }
        
        let application = UIApplication.shared
        if let tabBarController = application.keyWindow?.rootViewController as? UITabBarController,
            let shortcutType = ShortcutType(rawValue: type) {
            tabBarController.selectedIndex = shortcutType.selectedIndex
            shortcutIdentified = true
        }
        
        return shortcutIdentified
    }
    
}

extension SceneDelegate {
    
    func launchTabVC() {
        
        window?.rootViewController = HomeController()
        
        window?.makeKeyAndVisible()
    }
    
    private func customizeAppearance() {
        window?.tintColor = Constants.AppColors.Theme.tintColor
        
        UISearchBar.appearance().barTintColor = Constants.AppColors.Theme.tintColor
        
        UINavigationBar.appearance().barTintColor = Constants.AppColors.Theme.tintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
    }
}
