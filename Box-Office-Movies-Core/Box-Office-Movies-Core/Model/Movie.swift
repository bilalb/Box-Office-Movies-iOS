//
//  Movie.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// Movie.
struct Movie: Codable {
    
    /// Identifier of the movie. For example: `299537`.
    let identifier: Int
    
    /// Title of the movie. For example: `"Captain Marvel"`.
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
    }
}
