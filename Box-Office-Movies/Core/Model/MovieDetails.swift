//
//  MovieDetails.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
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
