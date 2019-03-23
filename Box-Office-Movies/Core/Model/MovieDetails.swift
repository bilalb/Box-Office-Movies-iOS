//
//  MovieDetails.swift
//  Box-Office-Movies
//

import Foundation

struct MovieDetails: Codable {
    
    let identifier: Int
    let title: String
    let releaseDate: String
    let voteAverage: Double
    let synopsis: String?
    let posterPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case synopsis = "overview"
        case posterPath = "poster_path"
    }
}
