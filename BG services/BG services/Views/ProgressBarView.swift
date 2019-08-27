//
//  ProgressBarView.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

class ProgressBarView: DownloadButtonsBaseView {
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        
        progressBar.progressViewStyle = .default
        progressBar.setProgress(0.0, animated: true)
        progressBar.trackTintColor = .systemOrange
        progressBar.tintColor = .systemRed
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        return progressBar
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        
        label.text = "100% of 35MB"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
//        label.backgroundColor = .blue
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func setupViews() {
        switch style {
        case .downloading:
            addSubview(progressBar)
            addSubview(progressLabel)
            
            progressBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
            //        progressBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
            progressBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
            
            progressLabel.leftAnchor.constraint(equalTo: progressBar.rightAnchor, constant: 4).isActive = true
            progressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            progressLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            progressLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            
            progressLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3, constant: 0).isActive = true
        default:
            
            self.heightAnchor.constraint(equalToConstant: 0).isActive = true
            break;
        }
    }
    
    func configure(string: String) {
        progressLabel.text = string
    }
    
    func updateDisplay(progress: Float, totalSize : String) {
        progressBar.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}
