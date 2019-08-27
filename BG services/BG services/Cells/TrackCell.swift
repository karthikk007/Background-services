//
//  TrackCell.swift
//  BG services
//
//  Created by Karthik on 07/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - Track Cell Delegate Protocol
//

protocol TrackCellDelegate: class {
    func cancelTapped(_ cell: TrackCell)
    func downloadTapped(_ cell: TrackCell)
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
}

class TrackCell: BaseCell {
    
    //
    // MARK: - Variables And Properties
    //

    weak var delegate: TrackCellDelegate?
    
    var style = DownloadButtonsViewStyle.downloaded
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "TITLE"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
//        label.backgroundColor = .systemFill
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "sub title"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
//        label.backgroundColor = .systemRed
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var downloadButtonsView: DownloadButtonsView = {
        let view = DownloadButtonsView(style: self.style)
        
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var progressBarView: ProgressBarView = {
        let progressBarView = ProgressBarView(style: self.style)
        
//        progressBarView.backgroundColor = .black
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressBarView
    }()
    
    required init(style: DownloadButtonsViewStyle, reuseIdentifier: String?) {
        self.style = style
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(downloadButtonsView)
        addSubview(progressBarView)
        
//        titleLabel.trailingAnchor.constraint(equalTo: downloadButtonsView.leadingAnchor, constant: -10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        
        progressBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        progressBarView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        progressBarView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        progressBarView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 4).isActive = true
        
        downloadButtonsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        downloadButtonsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        downloadButtonsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        downloadButtonsView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4).isActive = true
        
        downloadButtonsView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.3, constant: 0).isActive = true
        
        self.selectionStyle = .none
        
        registerDelegates()
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        progressBarView.updateDisplay(progress: progress, totalSize: totalSize)
    }
    
    func registerDelegates() {
        downloadButtonsView.delegate = self
    }
    
    func configure(track: Track, download: Download?) {
        titleLabel.text = (track.trackName != nil) ? track.trackName : track.collectionName
        subTitleLabel.text = track.artistName
        
        if let download = download {
            progressBarView.updateDisplay(progress: download.progress, totalSize: "Downloading...")
            progressBarView.configure(string: download.isDownloading ? "Downloading..." : "Paused")
            
            downloadButtonsView.configurePauseResumeButtonView(with: download.isDownloading ? .pause : .resume)
        }
    }
}

// MARK: - PauseResumeButtonView Delegate
extension TrackCell: DownloadButtonsViewDelegate {
    func cancelTapped(_ view: DownloadButtonsView) {
        delegate?.cancelTapped(self)
    }
    
    func downloadTapped(_ view: DownloadButtonsView){
        delegate?.downloadTapped(self)
    }
    
    func pauseTapped(_ view: DownloadButtonsView){
        delegate?.pauseTapped(self)
    }
    
    func resumeTapped(_ view: DownloadButtonsView){
        delegate?.resumeTapped(self)
    }
    
}

