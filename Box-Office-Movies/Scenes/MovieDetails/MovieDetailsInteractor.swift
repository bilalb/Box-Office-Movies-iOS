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
        fetchAPIConfiguration { [weak self] (apiConfiguration, _) in
            self?.fetchDetails { [weak self] (movieDetails, _) in
                self?.fetchCasting { [weak self] (casting, _) in
                    self?.fetchSimilarMovies { [weak self] (paginatedMovieList, _) in
                        if let paginatedMovieList = paginatedMovieList {
                            self?.paginatedMovieLists.append(paginatedMovieList)
                            self?.similarMoviePage += 1
                        }
                        let response = MovieDetailsScene.FetchMovieDetails.Response(apiConfiguration: apiConfiguration,
                                                                                    movieDetails: movieDetails,
                                                                                    casting: casting,
                                                                                    paginatedMovieLists: self?.paginatedMovieLists)
                        self?.presenter?.presentMovieDetails(response: response)
                    }
                }
            }
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

extension MovieDetailsInteractor {
    
    func fetchAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?) {
        ManagerProvider.sharedInstance.movieManager.theMovieDatabaseAPIConfiguration(completionHandler: completionHandler)
    }
    
    func fetchDetails(completionHandler: MovieDetailsCompletionHandler?) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        let regionCode = Locale.current.regionCode ?? Constants.Fallback.regionCode
        ManagerProvider.sharedInstance.movieManager.movieDetails(identifier: movieIdentifier, languageCode: languageCode, regionCode: regionCode, completionHandler: completionHandler)
    }
    
    func fetchCasting(completionHandler: CastingCompletionHandler?) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        ManagerProvider.sharedInstance.movieManager.casting(identifier: movieIdentifier, completionHandler: completionHandler)
    }
    
    func fetchSimilarMovies(completionHandler: SimilarMoviesCompletionHandler?) {
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
        ManagerProvider.sharedInstance.movieManager.similarMovies(identifier: movieIdentifier, languageCode: languageCode, page: similarMoviePage, completionHandler: completionHandler)
    }
}
