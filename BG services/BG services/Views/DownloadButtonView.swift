//
//  DownloadButtonView.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

//
// MARK: - DownloadButtonView Delegate Protocol
//

protocol DownloadButtonViewDelegate: class {
    func downloadTapped(_ view: DownloadButtonView)
}

class DownloadButtonView: DownloadButtonsBaseView {
    
    //
    // MARK: - Variables And Properties
    //
    
    weak var delegate: DownloadButtonViewDelegate?
    
    let downloadButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("Download", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .right
        
        button.addTarget(self, action: #selector(didTapDownloadButton(sender:)), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func setupViews() {
        self.addSubview(downloadButton)
        
        downloadButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        downloadButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        downloadButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    @objc
    func didTapDownloadButton(sender: UIButton) {
        delegate?.downloadTapped(self)
    }
}
