//
//  NowPlayingMoviesInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
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
    func refreshFavoriteMovies(request: NowPlayingMovies.RefreshFavoriteMovies.Request)
}

final class NowPlayingMoviesInteractor: NowPlayingMoviesDataStore {
    // MARK: Instance Properties
    var presenter: NowPlayingMoviesPresentationLogic?
    
    var page = 1
    var paginatedMovieLists = [PaginatedMovieList]()
    
    var movies: [Movie]?
    var favoriteMovies: [Movie]?
    var filteredMovies: [Movie]?

    var error: Error?
    
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
        func presentNowPlayingMovies() {
            let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: movies, error: error)
            presenter?.presentNowPlayingMovies(response: response)
        }

        state = .allMovies
        if movies?.isEmpty == false {
            presentNowPlayingMovies()
        } else {
            fetchNowPlayingMovies {
                presentNowPlayingMovies()
            }
        }
    }
    
    func fetchNextPage(request: NowPlayingMovies.FetchNextPage.Request) {
        guard shouldFetchNextPage else {
            let error = NowPlayingMoviesError.nothingToFetch
            let response = NowPlayingMovies.FetchNextPage.Response(movies: movies, error: error)
            presenter?.presentNextPage(response: response)
            return
        }
        
        fetchNowPlayingMovies { [weak self] in
            let response = NowPlayingMovies.FetchNextPage.Response(movies: self?.movies, error: self?.error)
            self?.presenter?.presentNextPage(response: response)
        }
    }
    
    func filterMovies(request: NowPlayingMovies.FilterMovies.Request) {
        let isFiltering = self.isFiltering(for: request.isSearchControllerActive, searchText: request.searchText)

        if isFiltering {
            filteredMovies = currentMovies?.filter { movie -> Bool in
                return movie.title.lowercased().contains(request.searchText.lowercased())
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
        
        fetchNowPlayingMovies { [weak self] in
            let response = NowPlayingMovies.RefreshMovies.Response(movies: self?.movies, error: self?.error)
            self?.presenter?.presentRefreshMovies(response: response)
        }
    }
    
    func loadTableViewBackgroundView(request: NowPlayingMovies.LoadTableViewBackgroundView.Request) {
        let movies = request.searchText?.isEmpty == true ? currentMovies : filteredMovies
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: state, searchText: request.searchText, movies: movies, error: error)
        presenter?.presentTableViewBackgroundView(response: response)
    }
}

extension NowPlayingMoviesInteractor {

    func fetchNowPlayingMovies(completionHandler: (() -> Void)?) {
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

            if let error = error {
                switch mode {
                case .fetchFirstPage:
                    self?.fetchNowPlayingMoviesError = FetchNowPlayingMoviesError.fetchFirstPageError(error)
                case .fetchNextPage:
                    self?.fetchNowPlayingMoviesError = FetchNowPlayingMoviesError.fetchNextPageError(error)
                case .refreshMovieList:
                    self?.fetchNowPlayingMoviesError = FetchNowPlayingMoviesError.refreshMovieListError(error)
                }
            } else {
                self?.fetchNowPlayingMoviesError = nil
            }

            self?.presentNowPlayingMovies(mode: mode)
        }
    }

    func isFiltering(for isSearchControllerActive: Bool, searchText: String?) -> Bool {
        return isSearchControllerActive && searchText?.isEmpty == false
    }
}

// MARK: - Favorite Movies

typealias RefreshSource = NowPlayingMovies.RefreshFavoriteMovies.Request.RefreshSource
typealias RefreshType = NowPlayingMovies.RefreshFavoriteMovies.Response.RefreshType

extension NowPlayingMoviesInteractor {
    
    func loadFavoriteMovies(request: NowPlayingMovies.LoadFavoriteMovies.Request) {
        state = .favorites
        favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()
        let response = NowPlayingMovies.LoadFavoriteMovies.Response(movies: favoriteMovies, editButtonItem: request.editButtonItem)
        presenter?.presentFavoriteMovies(response: response)
    }

    func refreshFavoriteMovies(request: NowPlayingMovies.RefreshFavoriteMovies.Request) {
        refreshPersistedData(with: request.refreshSource)

        let refreshType: RefreshType = {
            switch state {
            case .allMovies:
                return .none
            case .favorites:
                return refreshMovieLists(with: request.refreshSource,
                                         isSearchControllerActive: request.isSearchControllerActive,
                                         searchText: request.searchText)
            }
        }()

        let movies: [Movie]? = {
            let isFiltering = self.isFiltering(for: request.isSearchControllerActive, searchText: request.searchText)
            return isFiltering ? filteredMovies : currentMovies
        }()

        let response = NowPlayingMovies.RefreshFavoriteMovies.Response(movies: movies,
                                                                       refreshType: refreshType,
                                                                       state: state,
                                                                       editButtonItem: request.editButtonItem)
        presenter?.presentRefreshFavoriteMovies(response: response)
    }
}

// MARK: Favorite Movies Private Methods

extension NowPlayingMoviesInteractor {

    func refreshPersistedData(with refreshSource: RefreshSource) {
        switch refreshSource {
        case .movie(let movie):
            let favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()
            if let movie = favoriteMovies?.first(where: { $0.identifier == movie.identifier }) {
                _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(movie)
            } else {
                _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(movie)
            }
        case .indexPathForMovieToRemove(let indexPathForMovieToRemove):
            if let favoriteMovieToRemove = favoriteMovies?[safe: indexPathForMovieToRemove.row] {
                _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(favoriteMovieToRemove)
            }
        }
    }

    func refreshMovieLists(with refreshSource: RefreshSource,
                           isSearchControllerActive: Bool,
                           searchText: String?) -> RefreshType {
        let favoriteMoviesRefreshType = refreshFavoriteMovies(with: refreshSource)
        let filteredMoviesRefreshType = refreshFilteredMovies(with: refreshSource,
                                                              isSearchControllerActive: isSearchControllerActive,
                                                              searchText: searchText)

        // `filteredMoviesRefreshType` takes precedence over `favoriteMoviesRefreshType`
        let refreshType = filteredMoviesRefreshType ?? favoriteMoviesRefreshType

        return refreshType
    }

    func refreshFavoriteMovies(with refreshSource: RefreshSource) -> RefreshType {
        var refreshType: RefreshType = .none

        switch refreshSource {
        case .movie(let movie):
            if let index = removalIndex(for: movie, in: favoriteMovies) {
                refreshType = removeMovieFrom(&favoriteMovies, at: index)
            } else {
                refreshType = append(movie, to: &favoriteMovies)
            }
        case .indexPathForMovieToRemove(let indexPathForMovieToRemove):
            if favoriteMovies?.indices.contains(indexPathForMovieToRemove.row) == true {
                refreshType = removeMovieFrom(&favoriteMovies, at: indexPathForMovieToRemove.row)
            }
        }

        return refreshType
    }

    func refreshFilteredMovies(with refreshSource: RefreshSource,
                               isSearchControllerActive: Bool,
                               searchText: String?) -> RefreshType? {
        var refreshType: RefreshType?

        switch refreshSource {
        case .movie(let movie):
            let isFilteringFavorites: Bool = {
                let isFiltering = self.isFiltering(for: isSearchControllerActive, searchText: searchText)
                return isFiltering && state == .favorites
            }()

            if isFilteringFavorites {
                if let index = removalIndex(for: movie, in: filteredMovies) {
                    refreshType = removeMovieFrom(&filteredMovies, at: index)
                } else if let searchText = searchText, movie.title.lowercased().contains(searchText.lowercased()) {
                    refreshType = append(movie, to: &filteredMovies)
                } else {
                    refreshType = RefreshType.none
                }
            }
        default:
            break
        }

        return refreshType
    }

    func removalIndex(for movie: Movie, in movies: [Movie]?) -> Int? {
        // When a movie is removed from Core Data, it becomes a fault in the favoriteMovies.
        let faultIndex = movies?.firstIndex(where: { $0.isFault })

        // When a movie is added to Core Data, it's not a fault and we have to look for its identifier.
        let matchingIdentifierIndex = movies?.firstIndex(where: { $0.identifier == movie.identifier })

        return faultIndex ?? matchingIdentifierIndex
    }

    func removeMovieFrom(_ movies: inout [Movie]?, at index: Int) -> RefreshType {
        _ = movies?.remove(at: index)
        return .deletion(index: index)
    }

    func append(_ movie: Movie, to movies: inout [Movie]?) -> RefreshType {
        movies?.append(movie)
        return .insertion(index: (movies?.count ?? 0) - 1)
    }
}
