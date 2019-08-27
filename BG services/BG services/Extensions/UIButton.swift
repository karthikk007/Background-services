//
//  UIButton.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

extension UIButton: Togglable {
    func toggle() {
        self.isSelected = !self.isSelected
    }
}
