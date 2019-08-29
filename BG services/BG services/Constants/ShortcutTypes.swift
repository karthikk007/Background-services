//
//  ShortcutTypes.swift
//  BG services
//
//  Created by Karthik on 29/08/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

enum ShortcutType: String {
    case audio, map, whatever, fetch, downloads
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "audio":
            self = ShortcutType.audio
        case "map":
            self = ShortcutType.map
        case "whatever":
            self = ShortcutType.whatever
        case "fetch":
            self = ShortcutType.fetch
        case "downloads":
            self = ShortcutType.downloads
        default:
            return nil
        }
    }
    
    var selectedIndex: Int {
        var index: Int = -1
        
        switch self {
        case .audio:
            index = 0
        case .map:
            index = 1
        case .whatever:
            index = 2
        case .fetch:
            index = 3
        case .downloads:
            index = 4
        }
        
        return index
    }
}
