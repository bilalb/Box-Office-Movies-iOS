//
//  NowPlayingMoviesInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol NowPlayingMoviesDataStore {
    var movies: [Movie] { get }
    var filteredMovies: [Movie] { get }
    var state: State { get }
}

protocol NowPlayingMoviesBusinessLogic {
    func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request)
    func fetchNextPage(request: NowPlayingMovies.FetchNextPage.Request)
    func filterMovies(request: NowPlayingMovies.FilterMovies.Request)
    func refreshMovies(request: NowPlayingMovies.RefreshMovies.Request)
    
    func toggleFavoriteMoviesEdition(request: NowPlayingMovies.ToggleFavoriteMoviesEdition.Request)
    func toggleFavoriteMoviesDisplay(request: NowPlayingMovies.ToggleFavoriteMoviesDisplay.Request)
    func removeMovieFromFavorites(request: NowPlayingMovies.RemoveMovieFromFavorites.Request)
}

class NowPlayingMoviesInteractor: NowPlayingMoviesDataStore {
    // MARK: Instance Properties
    var presenter: NowPlayingMoviesPresentationLogic?
    
    var page = 1
    var paginatedMovieLists = [PaginatedMovieList]()
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    var state = State.allMovies {
        didSet {
            switch state {
            case .allMovies:
                // TODO: only fetch movies when needed
                fetchNowPlayingMovies()
            case .searching:
                // TODO: to refactor ?
                break
            case .favorites:
                loadFavoriteMovies()
            }
        }
    }
    var isEditingFavoriteMovies = false
}

enum State {
    case allMovies
    case searching
    case favorites
}

extension NowPlayingMoviesInteractor: NowPlayingMoviesBusinessLogic {
    
    func fetchNowPlayingMovies() {
        let request = NowPlayingMovies.FetchNowPlayingMovies.Request()
        fetchNowPlayingMovies(request: request)
    }
    
    func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request) {
        fetchNowPlayingMovies { [weak self] error in
            let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: self?.movies, error: error)
            self?.presenter?.presentNowPlayingMovies(response: response)
        }
    }
    
    func fetchNextPage(request: NowPlayingMovies.FetchNextPage.Request) {
        var shouldFetch = paginatedMovieLists.isEmpty
        if let totalPages = paginatedMovieLists.last?.totalPages {
            shouldFetch = page <= totalPages
        }
        
        guard shouldFetch, state == .allMovies else {
            return
        }
        
        fetchNowPlayingMovies { [weak self] error in
            let response = NowPlayingMovies.FetchNextPage.Response(movies: self?.movies, error: error)
            self?.presenter?.presentNextPage(response: response)
        }
    }
    
    func filterMovies(request: NowPlayingMovies.FilterMovies.Request) {
        let isFiltering = request.isSearchControllerActive && !request.searchText.isEmpty
        
        if isFiltering {
            state = .searching
            filteredMovies = movies.filter { movie -> Bool in
                return movie.title.lowercased().contains(request.searchText.lowercased()) == true
            }
        } else {
            filteredMovies = movies
        }
        
        let response = NowPlayingMovies.FilterMovies.Response(movies: filteredMovies)
        presenter?.presentFilterMovies(response: response)
    }
    
    func refreshMovies(request: NowPlayingMovies.RefreshMovies.Request) {
        page = 1
        paginatedMovieLists.removeAll()
        movies.removeAll()
        filteredMovies.removeAll()
        state = .allMovies
        
        fetchNowPlayingMovies { [weak self] error in
            let response = NowPlayingMovies.RefreshMovies.Response(movies: self?.movies, error: error)
            self?.presenter?.presentRefreshMovies(response: response)
        }
    }
}

extension NowPlayingMoviesInteractor {
    
    typealias MoviesCompletionHandler = (_ error: Error?) -> Void

    func fetchNowPlayingMovies(completionHandler: MoviesCompletionHandler?) {
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        let regionCode = Locale.current.regionCode ?? Constants.Fallback.regionCode
        ManagerProvider.shared.movieManager.nowPlayingMovies(languageCode: languageCode, regionCode: regionCode, page: page) { [weak self] (paginatedMovieList, error) in
            if let paginatedMovieList = paginatedMovieList {
                self?.paginatedMovieLists.append(paginatedMovieList)
                self?.page += 1
            }
            self?.movies.removeAll()
            self?.paginatedMovieLists.forEach({ (paginatedMovieList) in
                self?.movies.append(contentsOf: paginatedMovieList.movies)
            })
            completionHandler?(error)
        }
    }
}

// MARK: - Favorite movies

extension NowPlayingMoviesInteractor {
    
    func toggleFavoriteMoviesEdition(request: NowPlayingMovies.ToggleFavoriteMoviesEdition.Request) {
        isEditingFavoriteMovies = !isEditingFavoriteMovies
        
        let response = NowPlayingMovies.ToggleFavoriteMoviesEdition.Response(isEditingFavoriteMovies: isEditingFavoriteMovies,
                                                                             toggleFavoriteMoviesEditionBarButtonItemTarget: request.toggleFavoriteMoviesEditionBarButtonItemTarget,
                                                                             toggleFavoriteMoviesEditionBarButtonItemAction: request.toggleFavoriteMoviesEditionBarButtonItemAction,
                                                                             toggleFavoriteMoviesDisplayBarButtonItem: request.toggleFavoriteMoviesDisplayBarButtonItem)
        presenter?.presentToggleFavoriteMoviesEdition(response: response)
    }
    
    func toggleFavoriteMoviesDisplay(request: NowPlayingMovies.ToggleFavoriteMoviesDisplay.Request) {
        // TODO: to refactor in order not to call multiple presenter methods
        switch state {
        case .allMovies:
            state = .favorites
        case .searching:
            break
        case .favorites:
            state = .allMovies
        }
        let response = NowPlayingMovies.ToggleFavoriteMoviesDisplay.Response(state: state, toggleFavoriteMoviesEditionBarButtonItem: request.toggleFavoriteMoviesEditionBarButtonItem)
        presenter?.presentToggleFavoriteMoviesDisplay(response: response)
    }
    
    func loadFavoriteMovies() {
        let favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()
        filteredMovies = favoriteMovies ?? []
        let response = NowPlayingMovies.FilterMovies.Response(movies: filteredMovies)
        presenter?.presentFilterMovies(response: response)
    }
    
    func removeMovieFromFavorites(request: NowPlayingMovies.RemoveMovieFromFavorites.Request) {
        guard filteredMovies.indices.contains(request.indexPathForMovieToRemove.row) else {
            return
        }
        
        let favoriteMovieToDelete = filteredMovies.remove(at: request.indexPathForMovieToRemove.row)
        _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(favoriteMovieToDelete)
        
        let response = NowPlayingMovies.RemoveMovieFromFavorites.Response(movies: filteredMovies, indexPathForMovieToRemove: request.indexPathForMovieToRemove)
        presenter?.presentRemoveMovieFromFavorites(response: response)
    }
}
