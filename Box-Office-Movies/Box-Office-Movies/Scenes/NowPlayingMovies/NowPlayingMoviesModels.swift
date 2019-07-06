//
//  NowPlayingMoviesModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

// TODO: rename to MovieList?
enum NowPlayingMovies {
    
    enum FetchNowPlayingMovies {
        
        struct Request { }
        
        struct Response {
            let movies: [Movie]?
            let error: Error?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
            let shouldHideErrorView: Bool
            let errorDescription: String?
        }
    }
    
    enum FetchNextPage {
        
        struct Request { }
        
        struct Response {
            let movies: [Movie]?
            let error: Error?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
            let shouldPresentErrorAlert: Bool
            let errorAlertTitle: String?
            let errorAlertMessage: String?
            let errorAlertStyle: UIAlertController.Style
            let errorAlertActions: [UIAlertAction]
        }
    }
    
    enum FilterMovies {
        
        struct Request {
            let searchText: String
            let isSearchControllerActive: Bool
        }
        
        struct Response {
            let movies: [Movie]?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
        }
    }
    
    enum RefreshMovies {
        
        struct Request { }
        
        struct Response {
            let movies: [Movie]?
            let error: Error?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
            let shouldPresentErrorAlert: Bool
            let errorAlertTitle: String?
            let errorAlertMessage: String?
            let errorAlertStyle: UIAlertController.Style
            let errorAlertActions: [UIAlertAction]
        }
    }
}

// MARK: - Favorite movies

extension NowPlayingMovies {
    
    enum LoadFavoriteMovies {
        
        struct Request { }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    enum RemoveMovieFromFavorites {
        
        struct Request {
            let indexPathForMovieToRemove: IndexPath
        }
        
        struct Response {
            let movies: [Movie]?
            let indexPathForMovieToRemove: IndexPath
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
            let indexPathsForRowsToDelete: [IndexPath]
        }
    }
}

struct MovieItem {
    let title: String?
}
