//
//  DownloadModel.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

//
// MARK: - Download
//
class Download {
    //
    // MARK: - Variables And Properties
    //
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var track: Track
    
    //
    // MARK: - Initialization
    //
    init(track: Track) {
        self.track = track
    }
}
