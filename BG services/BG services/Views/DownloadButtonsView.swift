//
//  DownloadButtonsView.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - DownloadButtonsView Delegate Protocol
//

protocol DownloadButtonsViewDelegate: class {
    func cancelTapped(_ view: DownloadButtonsView)
    func downloadTapped(_ view: DownloadButtonsView)
    func pauseTapped(_ view: DownloadButtonsView)
    func resumeTapped(_ view: DownloadButtonsView)
}

class DownloadButtonsView: DownloadButtonsBaseView {
    
    //
    // MARK: - Variables And Properties
    //
    
    weak var delegate: DownloadButtonsViewDelegate?
    
    let downloadButtonView: DownloadButtonView = {
        let view = DownloadButtonView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    let pauseResumeButtonView: PauseResumeButtonView = {
        let view = PauseResumeButtonView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    override func setupViews() {
//        self.backgroundColor = UIColor.green
        
        switch style {
        case .download:
            addSubview(downloadButtonView)
            
            downloadButtonView.isHidden = false
            
            downloadButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            downloadButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            downloadButtonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            downloadButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            
        case .downloading:
            addSubview(pauseResumeButtonView)
            
            pauseResumeButtonView.isHidden = false
            
            pauseResumeButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            pauseResumeButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            pauseResumeButtonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            pauseResumeButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            
        case .downloaded:
            self.widthAnchor.constraint(lessThanOrEqualToConstant: 0).isActive = true
            break;
        }
        
        registerDelegates()
    }
    
    func registerDelegates() {
        downloadButtonView.delegate = self
        pauseResumeButtonView.delegate = self
    }
    
    func configurePauseResumeButtonView(with style: PauseResumeButtonType) {
        pauseResumeButtonView.configureButton(with: style)
    }
}

// MARK: - DownloadButtonViewDelegate Delegate
extension DownloadButtonsView: DownloadButtonViewDelegate {
    func downloadTapped(_ view: DownloadButtonView) {
        delegate?.downloadTapped(self)
    }
}

// MARK: - PauseResumeButtonView Delegate
extension DownloadButtonsView: PauseResumeButtonViewDelegate {
    func pauseTapped(_ view: PauseResumeButtonView) {
        delegate?.pauseTapped(self)
    }
    
    func resumeTapped(_ view: PauseResumeButtonView) {
        delegate?.resumeTapped(self)
    }
    
    func cancelTapped(_ view: PauseResumeButtonView) {
        delegate?.cancelTapped(self)
    }
}




