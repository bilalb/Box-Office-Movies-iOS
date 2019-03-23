//
//  TheMovieDatabaseAPIConfiguration.swift
//  Box-Office-Movies
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
