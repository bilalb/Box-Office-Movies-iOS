//
//  NowPlayingMoviesModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import UIKit

enum NowPlayingMovies {
    
    enum FetchNowPlayingMovies {
        
        struct Request { }
        
        struct Response {
            let paginatedMovieLists: [PaginatedMovieList]?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
        }
    }
}

extension NowPlayingMovies.FetchNowPlayingMovies.ViewModel {
    
    struct MovieItem {
        let title: String?
    }
}
