//
//  AudioPlayViewController.swift
//  BG services
//
//  Created by Karthik on 06/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import AVFoundation
import UIKit
import WebKit


class AudioPlayViewController: UIViewController {
    
    lazy var songList: [AVPlayerItem] = {
        let songs = Constants.AudioSongs.list
        return songs.map {
            let url = Bundle.main.url(forResource: $0, withExtension: Constants.AudioSongs.type)!
            return AVPlayerItem(url: url)
        }
    }()
    
    lazy var player: AVQueuePlayer = {
       let player = AVQueuePlayer(items: songList)
        player.actionAtItemEnd = .advance
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial], context: nil)
        return player
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapPlayButton(sender:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "title"
        label.font = UIFont.systemFont(ofSize: 36)
        label.textAlignment = .center
        label.textColor = UIColor.white
//        label.shadowColor = UIColor.black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Press play to start the audio"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.white
//        label.shadowColor = UIColor.black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .orange
        
        setupViews()
        setupPlayback()
    }
    
    func setupPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                mode: .default,
                options: [])
        } catch {
            print("Failed to set audio session category.  Error: \(error)")
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 100), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            
            if UIApplication.shared.applicationState == .active {
                self.timeLabel.text = timeString
            } else {
                print("audio - Background: \(timeString)")
            }
        }
    }
    
    @objc
    func didTapPlayButton(sender: UIButton) {
        sender.toggle()
        if sender.isSelected {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func setupViews() {
        view.addSubview(songTitleLabel)
        view.addSubview(timeLabel)
        view.addSubview(playButton)
        
        songTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        songTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        songTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        songTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        timeLabel.centerXAnchor.constraint(equalTo: songTitleLabel.centerXAnchor, constant: 0).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: songTitleLabel.centerYAnchor, constant: 30).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: songTitleLabel.leftAnchor).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: songTitleLabel.rightAnchor).isActive = true
        
        playButton.centerXAnchor.constraint(equalTo: songTitleLabel.centerXAnchor, constant: 0).isActive = true
        playButton.centerYAnchor.constraint(equalTo: songTitleLabel.centerYAnchor, constant: 80).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

extension AudioPlayViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem",
            let player = object as? AVPlayer,
            let currentItem = player.currentItem?.asset as? AVURLAsset {
            
            songTitleLabel.text = currentItem.url.lastPathComponent
        }
    }
}
