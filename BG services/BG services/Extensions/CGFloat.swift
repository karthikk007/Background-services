//
//  CGFloat.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return (CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}
