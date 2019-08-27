//
//  QueryService.swift
//  BG services
//
//  Created by Karthik on 08/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

//
// MARK: - Query Service
//

/// Runs query data task, and stores results in array of Tracks
class QueryService {
    //
    // MARK: - Constants
    //
    let defaultSession = URLSession(configuration: .default)
    
    //
    // MARK: - Variables And Properties
    //
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var trackList: TrackList?
    
    //
    // MARK: - Type Alias
    //
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Track]?, String) -> Void
    
    //
    // MARK: - Internal Methods
    //
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        // 1
        dataTask?.cancel()
        
        // 2
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "country=IN&media=music&entity=song&term=\(searchTerm)"
            
            // 3
            guard let url = urlComponents.url else {
                return
            }
            
            // 4
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                // 5
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.updateSearchResults(data)
                    
                    // 6
                    DispatchQueue.main.async {
                        completion(self?.trackList?.tracks, self?.errorMessage ?? "")
                    }
                }
            }
            
            // 7
            dataTask?.resume()
        }
    }
    
    //
    // MARK: - Private Methods
    //
    private func updateSearchResults(_ data: Data) {
        trackList = nil
        
        do {
            let decoder = JSONDecoder()
            self.trackList = try decoder.decode(TrackList.self, from: data)
            for (index, track) in self.trackList!.tracks.enumerated() {
                track.index = index
            }
        } catch let error {
            print(error)
        }
        
    }
}
