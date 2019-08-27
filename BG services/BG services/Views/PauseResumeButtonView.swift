//
//  PauseResumeButtonView.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

//
// MARK: - PauseResumeButtonView Delegate Protocol
//

protocol PauseResumeButtonViewDelegate: class {
    func pauseTapped(_ view: PauseResumeButtonView)
    func resumeTapped(_ view: PauseResumeButtonView)
    func cancelTapped(_ view: PauseResumeButtonView)
}

enum PauseResumeButtonType: Int {
    case pause, resume
}

class PauseResumeButtonView: DownloadButtonsBaseView {
    
    //
    // MARK: - Variables And Properties
    //
    
    weak var delegate: PauseResumeButtonViewDelegate?
    
    var buttonStyle: PauseResumeButtonType = .pause {
        didSet {
            pauseButton.setTitle(buttonStyle == .pause ? "Pause" : "Resume", for: .normal)
        }
    }
    
    let pauseButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("Pause", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(.red, for: .normal)
        
        button.addTarget(self, action: #selector(didTapPauseButton(sender:)), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(.red, for: .normal)
        
        button.addTarget(self, action: #selector(didTapCancelButton(sender:)), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func setupViews() {        
        self.addSubview(pauseButton)
        self.addSubview(cancelButton)
        
        pauseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        pauseButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -4).isActive = true
        
        cancelButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: pauseButton.widthAnchor, constant: 0).isActive = true
    }
    
    func configureButton(with style: PauseResumeButtonType) {
        buttonStyle = style
    }
    
    @objc
    func didTapPauseButton(sender: UIButton) {
        if buttonStyle == .resume {
            delegate?.resumeTapped(self)
        } else {
            delegate?.pauseTapped(self)
        }
    }
    
    @objc
    func didTapCancelButton(sender: UIButton) {
        delegate?.cancelTapped(self)
    }
}
