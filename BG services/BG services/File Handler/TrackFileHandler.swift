//
//  TrackFileHandler.swift
//  BG services
//
//  Created by Karthik on 20/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

class TrackFileHandler: FileAccessible {
    var fileURL: URL
    
    init(trackURL: URL) {
        fileURL = trackURL
    }
}
