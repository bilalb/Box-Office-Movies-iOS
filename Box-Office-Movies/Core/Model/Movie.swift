//
//  Movie.swift
//  Box-Office-Movies
//

import Foundation

/// Movie.
struct Movie: Codable {
    
    /// Identifier of the movie. For example: `"299537"`.
    let identifier: Int
    
    /// Title of the movie. For example: `"Captain Marvel"`.
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
    }
}
