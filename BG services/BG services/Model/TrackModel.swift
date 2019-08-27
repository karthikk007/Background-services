//
//  TrackModel.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit

//
// MARK: - Track
//

/// Query service creates Track objects
class Track: Codable {
    //
    // MARK: - Constants
    //
    let artistName: String
    let trackName: String?
    let previewUrl: String
    let collectionName: String
    
    //
    // MARK: - Variables And Properties
    //
    var downloaded = false
    var index = -1;
    
    var trackURL: URL {
        return URL(string: previewUrl)!
    }
    
    //
    // MARK: - Codable
    //
    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case previewUrl
        case collectionName
    }
}

class TrackList: Codable {
    let tracks: [Track] 
    
    //
    // MARK: - Codable
    //
    enum CodingKeys: String, CodingKey {
        case tracks = "results"
    }
    
}
