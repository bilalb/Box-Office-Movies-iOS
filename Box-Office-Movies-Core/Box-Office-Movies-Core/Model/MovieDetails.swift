//
//  MovieDetails.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

/// Primary information about a movie.
public struct MovieDetails: Codable {
    
    let identifier: Int
    public let title: String
    
    /// The String representation of the release date of the movie. For example: `"1999-10-12"`.
    public let releaseDate: String
    
    /// Vote average of the movie from 0 to 10. For example: `7.8`.
    public let voteAverage: Double
    public let synopsis: String?
    
    /// Path to the poster of the movie. For example: `"/AtsgWhDnHTq68L0lLsUrCnM7TjG.jpg"`.
    public let posterPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case synopsis = "overview"
        case posterPath = "poster_path"
    }
    
    public init(identifier: Int, title: String, releaseDate: String, voteAverage: Double, synopsis: String?, posterPath: String?) {
        self.identifier = identifier
        self.title = title
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.synopsis = synopsis
        self.posterPath = posterPath
    }
}
