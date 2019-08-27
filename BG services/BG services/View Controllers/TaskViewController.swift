//
//  TaskViewController.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation
import UIKit

class TaskViewController: UIViewController {
    
    var fibGenerator = FibonacciSeriesGenerator()
    var updateTimer: Timer?
    
    var backgroundTaskHandler = BackgroundTaskHandler()
    
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapPlayButton(sender:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Fibonacchi Computations"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1.0)
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        view.addSubview(playButton)
        view.addSubview(resultsLabel)
        
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        resultsLabel.topAnchor.constraint(equalTo: playButton.topAnchor, constant: 50).isActive = true
        resultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        resultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        resultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc
    func didTapPlayButton(sender: UIButton) {
        sender.toggle()
        if sender.isSelected {
            resetCalculation()
            updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                               selector: #selector(calculateNextNumber), userInfo: nil, repeats: true)
            // register background task
            backgroundTaskHandler.registerBackgroundTask()
        } else {
            updateTimer?.invalidate()
            updateTimer = nil
            // end background task
            if backgroundTaskHandler.backgroundTask != .invalid {
                backgroundTaskHandler.endBackgroundTask()
            }
        }
    }
    
    @objc func calculateNextNumber() {
        let (result, position) = fibGenerator.nextNumber()
        
        let bigNumber = NSDecimalNumber(mantissa: 1, exponent: 40, isNegative: false)
        if result.compare(bigNumber) == .orderedDescending {
            // This is just too much.... Start over.
            resetCalculation()
        }
        
        let resultsMessage = "Position \(position) = \(result)"
        switch UIApplication.shared.applicationState {
        case .active:
            resultsLabel.text = resultsMessage
        case .background:
            print("App is backgrounded. Next number = \(resultsMessage)")
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        default:
            break
        }
        
    }
    
    func resetCalculation() {
        fibGenerator.reset()
    }
    
    @objc func reinstateBackgroundTask() {
        if updateTimer != nil && backgroundTaskHandler.backgroundTask == .invalid {
            backgroundTaskHandler.registerBackgroundTask()
        }
    }
}


