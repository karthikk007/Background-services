//
//  DownloadViewController.swift
//  BG services
//
//  Created by Karthik on 07/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class DownloadViewController: UIViewController {
    
    let downloadService = DownloadService()
    let queryService = QueryService()
    
    var searchResults: [Track] = [] {
        didSet {
            for track in self.searchResults {
                let trackHandler = TrackFileHandler(trackURL: track.trackURL)
                if trackHandler.fileExists() {
                    track.downloaded = true
                }
            }
        }
    }
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    //
    // MARK: - Variables And Properties
    //
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "com.karthik.BG-Service.bgSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "Song name or artist"
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = Constants.AppColors.Theme.tintColor
        
        setupViews()
        
        tableView.tableFooterView = UIView()
        downloadService.downloadsSession = downloadsSession
        
        searchBar.text = "Kannada"
        searchBarSearchButtonClicked(searchBar)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10).isActive = true
    }
    
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        playerViewController.exitsFullScreenWhenPlaybackEnds = true
        present(playerViewController, animated: true, completion: nil)
        
        let trackHandler = TrackFileHandler(trackURL: track.trackURL)
        let player = AVPlayer(url: trackHandler.localFilePath())
        
        playerViewController.player = player
        player.play()
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

//
// MARK: - Track Cell Delegate
//
extension DownloadViewController: TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
}

// MARK: - Table View DataSource
extension DownloadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var style: DownloadButtonsViewStyle = .download
        let track = searchResults[indexPath.row]
        let download: Download? = downloadService.activeDownloads[track.trackURL]
        
        if track.downloaded {
            style = .downloaded
        } else if let _ = download {
            style = .downloading
        }
        
        let cell: TrackCell = TrackCell(style: style, reuseIdentifier: TrackCell.identifier)
        
        cell.configure(track: track, download: download)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - Table View Delegate
extension DownloadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = searchResults[indexPath.row]
        
        if track.downloaded {
            playDownload(track)
        }
        
    }
}

// MARK: - URL Session Delegate
extension DownloadViewController: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

// MARK: - URL Session Download Delegate
extension DownloadViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        // 1
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        let trackOfflineHandler = TrackFileHandler(trackURL: sourceURL)
        trackOfflineHandler.moveFileToDocumentsPath(sourcePath: location) {
            download?.track.downloaded = true
            
            if let index = download?.track.index {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        // 1
        guard
            let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]  else {
                return
        }
        
        // 2
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // 3
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        // 4
        DispatchQueue.main.async {
            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
                                                                       section: 0)) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
}

// MARK: - Search Bar Delegate
extension DownloadViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                self?.searchResults = results
                
                UIView.animate(withDuration: 0.5, animations: {
                    self?.tableView.setContentOffset(CGPoint.zero, animated: false)
                }) { (finished) in
                    self?.tableView.reloadData()
                }
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}
