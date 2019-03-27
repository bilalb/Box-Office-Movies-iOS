//
//  MovieDetailsInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol MovieDetailsDataStore {
     var movieIdentifier: Int? { get set }
}

protocol MovieDetailsBusinessLogic {
    func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request)
    func fetchCasting(request: MovieDetailsScene.FetchCasting.Request)
    func fetchSimilarMovies(request: MovieDetailsScene.FetchSimilarMovies.Request)
    func loadMovieReviews(request: MovieDetailsScene.LoadMovieReviews.Request)
    func reviewMovie(request: MovieDetailsScene.ReviewMovie.Request)
}

class MovieDetailsInteractor: MovieDetailsDataStore {
    // MARK: Instance Properties
    var presenter: MovieDetailsPresentationLogic?
    
    var movieIdentifier: Int?
    var similarMoviePage = 1
    var paginatedMovieLists = [PaginatedMovieList]()
}

extension MovieDetailsInteractor: MovieDetailsBusinessLogic {
    
    func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        ManagerProvider.sharedInstance.movieManager.theMovieDatabaseAPIConfiguration { (apiConfiguration, _) in
            let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
            let regionCode = Locale.current.regionCode ?? Constants.Fallback.regionCode
            ManagerProvider.sharedInstance.movieManager.movieDetails(identifier: movieIdentifier, languageCode: languageCode, regionCode: regionCode) { [weak self] (movieDetails, _) in
                let response = MovieDetailsScene.FetchMovieDetails.Response(apiConfiguration: apiConfiguration, movieDetails: movieDetails)
                self?.presenter?.presentMovieDetails(response: response)
            }
        }
    }
    
    func fetchCasting(request: MovieDetailsScene.FetchCasting.Request) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        ManagerProvider.sharedInstance.movieManager.casting(identifier: movieIdentifier) { [weak self] (casting, _) in
            let response = MovieDetailsScene.FetchCasting.Response(casting: casting)
            self?.presenter?.presentCasting(response: response)
        }
    }
    
    func fetchSimilarMovies(request: MovieDetailsScene.FetchSimilarMovies.Request) {
        var shouldFetch = paginatedMovieLists.isEmpty
        if let totalPages = paginatedMovieLists.last?.totalPages {
            shouldFetch = similarMoviePage <= totalPages
        }
        
        guard shouldFetch,
            let movieIdentifier = movieIdentifier
        else {
            return
        }
        
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        ManagerProvider.sharedInstance.movieManager.similarMovies(identifier: movieIdentifier, languageCode: languageCode, page: similarMoviePage) { [weak self] (paginatedMovieList, error) in
            if let paginatedMovieList = paginatedMovieList, error == nil {
                self?.paginatedMovieLists.append(paginatedMovieList)
                self?.similarMoviePage += 1
            }
            let response = MovieDetailsScene.FetchSimilarMovies.Response(paginatedMovieLists: self?.paginatedMovieLists)
            self?.presenter?.presentSimilarMovies(response: response)
        }
    }
    
    func loadMovieReviews(request: MovieDetailsScene.LoadMovieReviews.Request) {
        let response = MovieDetailsScene.LoadMovieReviews.Response(movieReviews: MovieReview.allCases)
        presenter?.presentMovieReviews(response: response)
    }
    
    func reviewMovie(request: MovieDetailsScene.ReviewMovie.Request) {
        // TODO: to implement
        let response = MovieDetailsScene.ReviewMovie.Response(movieReview: request.movieReview)
        presenter?.presentReviewMovie(response: response)
    }
}
