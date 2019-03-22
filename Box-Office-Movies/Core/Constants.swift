//
//  Constants.swift
//  Box-Office-Movies
//

import Foundation

struct Constants {
    
    struct Environment {
        static let theMovieDatabaseAPIBaseUrl = "https://api.themoviedb.org/3"
        static let apiKey = "6fe58cfe35fd07801b2de4f97e7cd1c8"
        static let apiKeyParameter = "api_key=%@"
    }
    
    struct NowPlayingMoviesNetworkRequest {
        static let path = "/movie/now_playing?language=%@&region=%@&page=%d"
    }
    
    struct MovieDetailsNetworkRequest {
        static let path = "/movie/%d?language=%@&region=%@"
    }
}
