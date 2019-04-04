//
//  TheMovieDatabaseAPIConfiguration.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct TheMovieDatabaseAPIConfiguration: Codable {

    let imageData: ImageData
    
    private enum CodingKeys: String, CodingKey {
        case imageData = "images"
    }
}

extension TheMovieDatabaseAPIConfiguration {
    
    struct ImageData: Codable {
        
        let secureBaseUrl: String
        let posterSizes: [String]
        
        private enum CodingKeys: String, CodingKey {
            case secureBaseUrl = "secure_base_url"
            case posterSizes = "poster_sizes"
        }
    }
}
