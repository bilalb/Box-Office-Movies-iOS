//
//  Constants.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Environment {
        static let theMovieDatabaseAPIBaseUrl = "https://api.themoviedb.org/3/"
        static let theMovieDatabaseAPIKey = "6fe58cfe35fd07801b2de4f97e7cd1c8"
    }
    
    struct Network {
        static let timeoutIntervalForRequest: TimeInterval = 3
        static let timeoutIntervalForResource: TimeInterval = 5
    }
    
    struct NowPlayingMoviesNetworkRequest {
        static let path = "movie/now_playing?language=%@&region=%@&page=%d&api_key=%@"
    }
    
    struct MovieDetailsNetworkRequest {
        static let path = "movie/%d?language=%@&region=%@&api_key=%@"
    }
    
    struct TheMovieDatabaseAPIConfigurationNetworkRequest {
        static let path = "configuration?api_key=%@"
    }
    
    struct PosterNetworkRequest {
        static let path = "%@%@%@"
    }
    
    struct CastingNetworkRequest {
        static let path = "movie/%d/credits?api_key=%@"
    }
    
    struct SimilarMoviesNetworkRequest {
        static let path = "movie/%d/similar?language=%@&page=%d&api_key=%@"
    }
    
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