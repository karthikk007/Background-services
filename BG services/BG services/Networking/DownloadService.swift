//
//  DownloadService.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

//
// MARK: - Download Service
//

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
    //
    // MARK: - Variables And Properties
    //
    var activeDownloads: [URL: Download] = [ : ]
    
    /// DownloadViewController creates downloadsSession
    var downloadsSession: URLSession!
    
    //
    // MARK: - Internal Methods
    //
    func cancelDownload(_ track: Track) {
        guard let download = activeDownloads[track.trackURL] else {
            return
        }
        download.task?.cancel()
        
        activeDownloads[track.trackURL] = nil
    }
    
    func pauseDownload(_ track: Track) {
        guard
            let download = activeDownloads[track.trackURL],
            download.isDownloading
            else {
                return
        }
        
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })
        
        download.isDownloading = false
    }
    
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.trackURL] else {
            return
        }
        
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.track.trackURL)
        }
        
        download.task?.resume()
        download.isDownloading = true
    }
    
    func startDownload(_ track: Track) {
        // 1 create a model
        let download = Download(track: track)
        // 2 create a download task for the track url
        download.task = downloadsSession.downloadTask(with: track.trackURL)
        // 3 let the task begin
        download.task?.resume()
        // 4 set downloading
        download.isDownloading = true
        // 5 add to active downloads
        activeDownloads[download.track.trackURL] = download
    }
}
