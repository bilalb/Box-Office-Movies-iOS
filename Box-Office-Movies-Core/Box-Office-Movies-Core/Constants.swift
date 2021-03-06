//
//  Constants.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct Constants {

    struct InfoDictionaryKey {
        static let theMovieDatabaseAPIBaseUrl = "THE_MOVIE_DATABASE_API_BASE_URL"
        static let theMovieDatabaseAPIKey = "THE_MOVIE_DATABASE_API_KEY"
    }
    
    struct Network {
        static let timeoutIntervalForRequest: TimeInterval = 3
        static let timeoutIntervalForResource: TimeInterval = 5
    }
    
    struct CoreData {
        static let dataModelName = "Box-Office-Movies-Core"
        static let managedObjectModelFileExtension = "momd"
    }
    
    // MARK: - Network requests
    
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
    
    struct VideosNetworkRequest {
        static let path = "movie/%d/videos?language=%@&api_key=%@"
    }
}
