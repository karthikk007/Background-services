//
//  Protocols.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

protocol TabBarItemProvider {
    var tabBarItem: UITabBarItem { get }
}

protocol ViewControllerFactory {
    func createViewController() -> UIViewController
}

protocol Togglable {
    mutating func toggle()
}
