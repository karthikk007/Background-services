//
//  BackgroundTaskHandler.swift
//  BG services
//
//  Created by Karthik on 21/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

protocol Backgrounder {
    var backgroundTask: UIBackgroundTaskIdentifier { get set }
    
    func registerBackgroundTask()
    func endBackgroundTask()
}

class BackgroundTaskHandler: Backgrounder {
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundTask()
        })
        
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("background task ended.")
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}
