//
//  FavoriteMoviesModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 27.05.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

enum FavoriteMovies {
    
    enum LoadFavoriteMovies {
        
        struct Request { }
        
        struct Response {
            let favoriteMovies: [FavoriteMovie]?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
        }
    }
    
    enum RemoveMovieFromFavorites {
        
        struct Request {
            let indexPathForMovieToRemove: IndexPath
        }
        
        struct Response {
            let favoriteMovies: [FavoriteMovie]?
            let indexPathForMovieToRemove: IndexPath
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
            let indexPathsForRowsToDelete: [IndexPath]
        }
    }
}
