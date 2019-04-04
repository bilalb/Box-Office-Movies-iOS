//
//  Constants.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Fallback {
        static let languageCode = "en-US"
        static let regionCode = "US"
        static let posterImageSize = "w185"
    }
    
    struct CellIdentifier {
        static let movieTableViewCell = "MovieTableViewCell"
        static let titleTableViewCell = "TitleTableViewCell"
        static let reviewMovieTableViewCell = "ReviewMovieTableViewCell"
        static let synopsisTableViewCell = "SynopsisTableViewCell"
        static let castingTableViewCell =  "CastingTableViewCell"
        static let similarMoviesTableViewCell = "SimilarMoviesTableViewCell"
    }
    
    struct SegueIdentifier {
        static let movieDetails = "MovieDetails"
    }
}
