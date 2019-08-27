//
//  ViewControllerFactory.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

enum ViewControllerCreator: Int, TabBarItemProvider, ViewControllerFactory, CaseIterable {
    
    internal var tabBarItem: UITabBarItem {
        switch self {
        case .download:
            return UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        default:
            let image = UIImage(named: self.imageName())
            return UITabBarItem(title: self.title(), image: image, tag: 0)
        }
    }
    
    case audioPlayback, location, finiteTask, backgroundFetch, download
    
    private func imageName() -> String {
        switch self {
        case .audioPlayback:
            return Constants.ViewControllers.AudioPlayback.imageName
        case .location:
            return Constants.ViewControllers.LocationFetch.imageName
        case .finiteTask:
            return Constants.ViewControllers.FiniteTask.imageName
        case .backgroundFetch:
            return Constants.ViewControllers.BackgroundFetch.imageName
        case .download:
            return Constants.ViewControllers.Download.imageName
        }
    }
    
    private func title() -> String {
        switch self {
        case .audioPlayback:
            return Constants.ViewControllers.AudioPlayback.title
        case .location:
            return Constants.ViewControllers.LocationFetch.title
        case .finiteTask:
            return Constants.ViewControllers.FiniteTask.title
        case .backgroundFetch:
            return Constants.ViewControllers.BackgroundFetch.title
        case .download:
            return Constants.ViewControllers.Download.title
        }
    }
    
    func createViewController() -> UIViewController {
        let viewController: UIViewController
        switch self {
        case .audioPlayback:
            viewController = AudioPlayViewController()
        case .location:
            viewController = LocationViewController()
        case .finiteTask:
            viewController = TaskViewController()
        case .backgroundFetch:
            viewController = FetchViewController()
        case .download:
            viewController = DownloadViewController()
        }
        
        viewController.tabBarItem = tabBarItem
        viewController.title = title()
        
        return viewController
    }
    
    static func createAllViewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        for type in ViewControllerCreator.allCases {
            viewControllers.append(type.createViewController())
        }
        
        return viewControllers
    }
}
