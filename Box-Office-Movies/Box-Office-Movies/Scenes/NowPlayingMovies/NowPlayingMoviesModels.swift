//
//  NowPlayingMoviesModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

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
    
    enum LoadTableViewBackgroundView {
        
        struct Request {
            let searchText: String?
        }
        
        struct Response {
            let state: NowPlayingMoviesInteractor.State
            let searchText: String?
            let movies: [Movie]?
        }
        
        struct ViewModel {
            let backgroundView: UIView?
        }
    }
}

// MARK: - Favorite movies

extension NowPlayingMovies {
    
    enum LoadFavoriteMovies {
        
        struct Request {
            let editButtonItem: UIBarButtonItem
        }
        
        struct Response {
            let movies: [Movie]?
            let editButtonItem: UIBarButtonItem?
        }
        
        struct ViewModel {
            let movieItems: [MovieItem]?
            let rightBarButtonItem: UIBarButtonItem?
            let refreshControl: UIRefreshControl?
        }
    }

    enum RefreshFavoriteMovies {

        struct Request {
            let refreshSource: RefreshSource
            let editButtonItem: UIBarButtonItem
            let searchText: String?
            let isSearchControllerActive: Bool

            enum RefreshSource {
                case movie(Movie)
                case indexPathForMovieToRemove(IndexPath)
            }
        }

        struct Response {
            let movies: [Movie]?
            let refreshType: RefreshType
            let state: NowPlayingMoviesInteractor.State
            let editButtonItem: UIBarButtonItem?

            enum RefreshType {
                case insertion(index: Int)
                case deletion(index: Int)
                case none
            }
        }

        struct ViewModel {
            let shouldSetMovieItems: Bool
            let movieItems: [MovieItem]?
            let indexPathsForRowsToDelete: [IndexPath]?
            let indexPathsForRowsToInsert: [IndexPath]?
            let shouldSetRightBarButtonItem: Bool
            let rightBarButtonItem: UIBarButtonItem?
        }
    }
}

struct MovieItem {
    let title: String?
}

enum SegmentedControlSegmentIndex: Int {
    case all
    case favorites
}

enum NowPlayingMoviesError: Error {
    case nothingToFetch
}
