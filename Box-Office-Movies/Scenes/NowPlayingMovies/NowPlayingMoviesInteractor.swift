//
//  NowPlayingMoviesInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol NowPlayingMoviesDataStore {
    var movies: [Movie] { get }
    var filteredMovies: [Movie] { get }
    var isFiltering: Bool { get }
}

protocol NowPlayingMoviesBusinessLogic {
    func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request)
    func filterMovies(request: NowPlayingMovies.FilterMovies.Request)
}

class NowPlayingMoviesInteractor: NowPlayingMoviesDataStore {
    // MARK: Instance Properties
    var presenter: NowPlayingMoviesPresentationLogic?
    
    var page = 1
    var paginatedMovieLists = [PaginatedMovieList]()
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    var isFiltering = false
}

extension NowPlayingMoviesInteractor: NowPlayingMoviesBusinessLogic {
    
    func fetchNowPlayingMovies(request: NowPlayingMovies.FetchNowPlayingMovies.Request) {
        var shouldFetch = paginatedMovieLists.isEmpty
        if let totalPages = paginatedMovieLists.last?.totalPages {
            shouldFetch = page <= totalPages
        }
        
        guard shouldFetch else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return
        }
        
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        let regionCode = Locale.current.regionCode ?? Constants.Fallback.regionCode
        ManagerProvider.sharedInstance.movieManager.nowPlayingMovies(languageCode: languageCode, regionCode: regionCode, page: page) { [weak self] (paginatedMovieList, error) in
            if let paginatedMovieList = paginatedMovieList, error == nil {
                self?.paginatedMovieLists.append(paginatedMovieList)
                self?.page += 1
            }
            self?.movies.removeAll()
            self?.paginatedMovieLists.forEach({ (paginatedMovieList) in
                self?.movies.append(contentsOf: paginatedMovieList.movies)
            })
            let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: self?.movies)
            self?.presenter?.presentNowPlayingMovies(response: response)
        }
    }
    
    func filterMovies(request: NowPlayingMovies.FilterMovies.Request) {
        isFiltering = request.isSearchControllerActive && !request.searchText.isEmpty
        
        if isFiltering {
            filteredMovies = movies.filter { movie -> Bool in
                return movie.title.lowercased().contains(request.searchText.lowercased()) == true
            }
        } else {
            filteredMovies = movies
        }
        
        let response = NowPlayingMovies.FilterMovies.Response(movies: filteredMovies)
        presenter?.presentFilterMovies(response: response)
    }
}
