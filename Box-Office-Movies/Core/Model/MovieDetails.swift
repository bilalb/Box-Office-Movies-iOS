//
//  MovieDetails.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// Primary information about a movie.
struct MovieDetails: Codable {
    
    let identifier: Int
    let title: String
    
    /// Release date of the movie in the format of the region code given to the MovieDetailsNetworkRequest. For example: `"1999-10-12"`
    let releaseDate: String
    
    /// Vote average of the movie from 0 to 10. For example: `7.8`
    let voteAverage: Double
    let synopsis: String?
    
    /// Path to the poster of the movie. For example: `"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg"`
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
