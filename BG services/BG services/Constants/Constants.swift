//
//  ColorConstants.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit


enum Constants {
    enum AppColors {
        enum Theme {
            static let tintColor = UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
        }
    }
    
    enum ViewControllers {
        enum AudioPlayback {
            static let title = "Audio"
            static let imageName = "music"
        }
        
        enum LocationFetch {
            static let title = "Location"
            static let imageName = "map"
        }
        
        enum FiniteTask {
            static let title = "What ever"
            static let imageName = "fib"
        }
        
        enum BackgroundFetch {
            static let title = "Fetch"
            static let imageName = "fetch"
        }
        
        enum Download {
            static let title = "Download"
            static let imageName = "fetch"
        }
    }
    
    enum AudioSongs {
        static let list = ["FeelinGood", "IronBacon", "WhatYouWant"]
        static let type = "mp3"
    }
    
    enum LocationAccuracy {
        static let list = ["Nav", "Best", "10 m", "100 m", "1 km", "3 km"]
    }
}
