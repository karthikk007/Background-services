//
//  FetchViewController.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import UIKit

class FetchViewController: UIViewController {
    
    var time: Date? 
    
    let updateButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("UPDATE", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapUpdateButton(sender:)), for: .touchUpInside)
        button.isSelected = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "No Updates Yet!!"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .long
        
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
        
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(resultsLabel)
        view.addSubview(updateButton)
        
        resultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        resultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        resultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        updateButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        updateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func fetchData(_ completion: () -> Void) {
        time = Date()
        completion()
        
        if let time = time {
            print("fetched time = \(dateFormatter.string(from: time))")
        }
    }
    
    @objc func didTapUpdateButton(sender: UIButton) {
        fetchData {
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let time = time {
            resultsLabel.text = dateFormatter.string(from: time)
        } else {
            resultsLabel.text = "No Updates Yet!!"
        }
    }
}
