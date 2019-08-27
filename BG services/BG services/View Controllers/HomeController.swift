//
//  HomeController.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        viewControllers = ViewControllerCreator.createAllViewControllers()
        
        tabBar.barStyle = .black
        
        self.selectedIndex = 4
    }
}
