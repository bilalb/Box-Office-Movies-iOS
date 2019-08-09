//
//  Video.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 09/08/2019.
//  Copyright © 2019 Boxotop. All rights reserved.
//

import Foundation

struct VideoResponse: Codable {
    
    let videos: [Video]
    
    private enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}

public struct Video: Codable {
    
    public let key: String
    public let site: Site
    public let type: VideoType
    
    public init(key: String, site: Site, type: VideoType) {
        self.key = key
        self.site = site
        self.type = type
    }
}

public extension Video {
    
    enum VideoType: String, Codable {
        case trailer = "Trailer"
        case teaser = "Teaser"
        case clip = "Clip"
        case featurette = "Featurette"
        case behindTheScenes = "Behind the Scenes"
        case bloopers = "Bloopers"
    }
}

public extension Video {
    
    enum Site: String, Codable {
        case youTube = "YouTube"
    }
}
