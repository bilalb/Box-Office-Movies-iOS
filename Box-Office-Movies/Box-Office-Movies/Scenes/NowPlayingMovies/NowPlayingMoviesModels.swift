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
        
        struct Request {
            let mode: Mode

            enum Mode {
                case fetchFirstPage
                case fetchNextPage
                case refreshMovieList
            }
        }
        
        struct Response {
            let movies: [Movie]?
            let networkError: NetworkError?
            let mode: NowPlayingMovies.FetchNowPlayingMovies.Request.Mode?
        }
        
        struct ViewModel {
            let movieItems: [MovieListItem]?
        }
    }

    enum LoadNowPlayingMovies {

        struct Request { }
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
            let movieItems: [MovieListItem]?
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
            let networkError: NetworkError?
        }
        
        struct ViewModel {
            let backgroundView: UIView?
            let isSearchBarEnabled: Bool
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
            let movieItems: [MovieListItem]?
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
            let movieItems: [MovieListItem]?
            let indexPathsForRowsToDelete: [IndexPath]?
            let indexPathsForRowsToInsert: [IndexPath]?
            let shouldSetRightBarButtonItem: Bool
            let rightBarButtonItem: UIBarButtonItem?
        }
    }
}

extension NowPlayingMovies {

    enum NetworkError {
        case fetchFirstPageError(_ error: Error)
        case fetchNextPageError(_ error: Error)
        case refreshMovieListError(_ error: Error)
    }
}

extension NowPlayingMovies {

    enum MovieListItem {
        case movie(title: String?)
        case error(description: String?, mode: NowPlayingMovies.FetchNowPlayingMovies.Request.Mode)
        case loader

        var cellIdentifier: String {
            switch self {
            case .movie:
                return MovieTableViewCell.identifier
            case .error:
                return ErrorTableViewCell.identifier
            case .loader:
                return LoaderTableViewCell.identifier
            }
        }
    }
}

extension NowPlayingMovies {

    enum SegmentedControlSegmentIndex: Int {
        case all
        case favorites
    }
}
