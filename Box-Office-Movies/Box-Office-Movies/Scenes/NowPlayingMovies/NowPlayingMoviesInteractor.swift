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
    var movies: [Movie]? { get }
    var favoriteMovies: [Movie]? { get }
    var filteredMovies: [Movie]? { get }
    var state: NowPlayingMoviesInteractor.State { get }
}

protocol NowPlayingMoviesBusinessLogic {
    func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request)
    var shouldFetchNextPage: Bool { get }
    func fetchNextPage(request: NowPlayingMovies.FetchNextPage.Request)
    func filterMovies(request: NowPlayingMovies.FilterMovies.Request)
    func refreshMovies(request: NowPlayingMovies.RefreshMovies.Request)
    func loadTableViewBackgroundView(request: NowPlayingMovies.LoadTableViewBackgroundView.Request)
    
    func loadFavoriteMovies(request: NowPlayingMovies.LoadFavoriteMovies.Request)
    func removeMovieFromFavorites(request: NowPlayingMovies.RemoveMovieFromFavorites.Request)    
}

class NowPlayingMoviesInteractor: NowPlayingMoviesDataStore {
    // MARK: Instance Properties
    var presenter: NowPlayingMoviesPresentationLogic?
    
    var page = 1
    var paginatedMovieLists = [PaginatedMovieList]()
    
    var movies: [Movie]?
    var favoriteMovies: [Movie]?
    var filteredMovies: [Movie]?
    
    var currentMovies: [Movie]? {
        switch state {
        case .allMovies:
            return movies
        case .favorites:
            return favoriteMovies
        }
    }
    
    var state = State.allMovies

    var shouldFetchNextPage: Bool {
        var shouldFetchNextPage = paginatedMovieLists.isEmpty
        if let totalPages = paginatedMovieLists.last?.totalPages {
            shouldFetchNextPage = page <= totalPages
        }
        return shouldFetchNextPage && state == .allMovies
    }
}

extension NowPlayingMoviesInteractor {

    enum State {
        case allMovies
        case favorites
    }
}

extension NowPlayingMoviesInteractor: NowPlayingMoviesBusinessLogic {
    
    func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request) {
        state = .allMovies
        if movies == nil {
            fetchNowPlayingMovies { [weak self] error in
                let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: self?.movies, error: error)
                self?.presenter?.presentNowPlayingMovies(response: response)
            }
        } else {
            let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: movies, error: nil)
            presenter?.presentNowPlayingMovies(response: response)
        }
    }
    
    func fetchNextPage(request: NowPlayingMovies.FetchNextPage.Request) {
        guard shouldFetchNextPage else {
            let error = NowPlayingMoviesError.nothingToFetch
            let response = NowPlayingMovies.FetchNextPage.Response(movies: movies, error: error)
            presenter?.presentNextPage(response: response)
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
            filteredMovies = currentMovies?.filter { movie -> Bool in
                return movie.title.lowercased().contains(request.searchText.lowercased()) == true
            }
        } else {
            filteredMovies = currentMovies
        }
        
        let response = NowPlayingMovies.FilterMovies.Response(movies: filteredMovies)
        presenter?.presentFilterMovies(response: response)
    }
    
    func refreshMovies(request: NowPlayingMovies.RefreshMovies.Request) {
        page = 1
        paginatedMovieLists.removeAll()
        movies?.removeAll()
        filteredMovies?.removeAll()
        state = .allMovies
        
        fetchNowPlayingMovies { [weak self] error in
            let response = NowPlayingMovies.RefreshMovies.Response(movies: self?.movies, error: error)
            self?.presenter?.presentRefreshMovies(response: response)
        }
    }
    
    func loadTableViewBackgroundView(request: NowPlayingMovies.LoadTableViewBackgroundView.Request) {
        let movies = request.searchText?.isEmpty == true ? currentMovies : filteredMovies
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: state, searchText: request.searchText, movies: movies)
        presenter?.presentTableViewBackgroundView(response: response)
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
            self?.movies = []
            self?.paginatedMovieLists.forEach { (paginatedMovieList) in
                self?.movies?.append(contentsOf: paginatedMovieList.movies)
            }
            completionHandler?(error)
        }
    }
}

// MARK: - Favorite movies

extension NowPlayingMoviesInteractor {
    
    func loadFavoriteMovies(request: NowPlayingMovies.LoadFavoriteMovies.Request) {
        state = .favorites
        favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies() ?? []
        let response = NowPlayingMovies.LoadFavoriteMovies.Response(movies: favoriteMovies, editButtonItem: request.editButtonItem)
        presenter?.presentFavoriteMovies(response: response)
    }
    
    func removeMovieFromFavorites(request: NowPlayingMovies.RemoveMovieFromFavorites.Request) {
        guard
            favoriteMovies?.indices.contains(request.indexPathForMovieToRemove.row) == true,
            let favoriteMovieToRemove = favoriteMovies?.remove(at: request.indexPathForMovieToRemove.row)
        else {
            return
        }
        
        _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(favoriteMovieToRemove)
        
        let response = NowPlayingMovies.RemoveMovieFromFavorites.Response(movies: favoriteMovies, indexPathForMovieToRemove: request.indexPathForMovieToRemove, editButtonItem: request.editButtonItem)
        presenter?.presentRemoveMovieFromFavorites(response: response)
    }
}
