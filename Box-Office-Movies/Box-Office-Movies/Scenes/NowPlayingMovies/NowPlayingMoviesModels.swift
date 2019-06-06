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
    
    enum ToggleFavoriteMoviesEdition {
        
        struct Request {
            let toggleFavoriteMoviesEditionBarButtonItemTarget: Any?
            let toggleFavoriteMoviesEditionBarButtonItemAction: Selector?
            let toggleFavoriteMoviesDisplayBarButtonItem: UIBarButtonItem
        }
        
        struct Response {
            let isEditingFavoriteMovies: Bool
            let toggleFavoriteMoviesEditionBarButtonItemTarget: Any?
            let toggleFavoriteMoviesEditionBarButtonItemAction: Selector?
            let toggleFavoriteMoviesDisplayBarButtonItem: UIBarButtonItem
        }
        
        struct ViewModel {
            let isEditingTableView: Bool
            let shouldAnimateEditingModeTransition: Bool
            
            let leftBarButtonItem: UIBarButtonItem
            let shouldAnimateLeftBarButtonItemTransition: Bool
            
            let rightBarButtonItem: UIBarButtonItem?
            let shouldAnimateRightBarButtonItemTransition: Bool
        }
    }
    
    enum ToggleFavoriteMoviesDisplay {
        
        struct Request {
            let toggleFavoriteMoviesEditionBarButtonItem: UIBarButtonItem
        }
        
        struct Response {
            let state: State
            let toggleFavoriteMoviesEditionBarButtonItem: UIBarButtonItem
        }
        
        struct ViewModel {
            let canEditRows: Bool
            let leftBarButtonItem: UIBarButtonItem?
            let shouldAnimateLeftBarButtonItemTransition: Bool
        }
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
