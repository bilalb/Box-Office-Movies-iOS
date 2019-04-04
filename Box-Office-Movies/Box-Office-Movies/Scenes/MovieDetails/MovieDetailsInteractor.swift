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
    var paginatedSimilarMovieLists = [PaginatedMovieList]()
}

extension MovieDetailsInteractor: MovieDetailsBusinessLogic {
    
    func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request) {
        guard movieIdentifier != nil else {
            return
        }
        fetchAPIConfiguration { [weak self] (apiConfiguration, error) in
            
            func presentMovieDetails(movieDetails: MovieDetails?, casting: Casting?, paginatedSimilarMovieLists: [PaginatedMovieList]?, posterImage: UIImage?, error: Error?) {
                let response = MovieDetailsScene.FetchMovieDetails.Response(movieDetails: movieDetails,
                                                                            casting: casting,
                                                                            paginatedSimilarMovieLists: paginatedSimilarMovieLists,
                                                                            posterImage: posterImage,
                                                                            error: error)
                self?.presenter?.presentMovieDetails(response: response)
            }
            
            guard error == nil else {
                presentMovieDetails(movieDetails: nil, casting: nil, paginatedSimilarMovieLists: nil, posterImage: nil, error: error)
                return
            }
            
            self?.fetchDetails { [weak self] (movieDetails, error) in
                guard error == nil else {
                    presentMovieDetails(movieDetails: movieDetails, casting: nil, paginatedSimilarMovieLists: nil, posterImage: nil, error: error)
                    return
                }
                
                self?.fetchCasting { [weak self] (casting, error) in
                    guard error == nil else {
                        presentMovieDetails(movieDetails: movieDetails, casting: casting, paginatedSimilarMovieLists: nil, posterImage: nil, error: error)
                        return
                    }
                    
                    self?.fetchSimilarMovies { [weak self] (paginatedSimilarMovieList, error) in
                        if let paginatedSimilarMovieList = paginatedSimilarMovieList {
                            self?.paginatedSimilarMovieLists.append(paginatedSimilarMovieList)
                            self?.similarMoviePage += 1
                        }
                        
                        guard let imageSecureBaseURLPath = apiConfiguration?.imageData.secureBaseUrl,
                            let posterPath = movieDetails?.posterPath
                        else {
                            presentMovieDetails(movieDetails: movieDetails,
                                                casting: casting,
                                                paginatedSimilarMovieLists: self?.paginatedSimilarMovieLists,
                                                posterImage: nil,
                                                error: error)
                            return
                        }
                        self?.fetchPosterImage(imageSecureBaseURLPath: imageSecureBaseURLPath, posterPath: posterPath) { [weak self] (posterImage, error) in
                            presentMovieDetails(movieDetails: movieDetails,
                                                casting: casting,
                                                paginatedSimilarMovieLists: self?.paginatedSimilarMovieLists,
                                                posterImage: posterImage,
                                                error: error)
                        }
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
        var shouldFetch = paginatedSimilarMovieLists.isEmpty
        if let totalPages = paginatedSimilarMovieLists.last?.totalPages {
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
    
    func fetchPosterImage(imageSecureBaseURLPath: String, posterSize: String = Constants.Fallback.posterImageSize, posterPath: String, completionHandler: PosterCompletionHandler?) {
        ManagerProvider.sharedInstance.movieManager.poster(imageSecureBaseURL: imageSecureBaseURLPath, posterSize: posterSize, posterPath: posterPath, completionHandler: completionHandler)
    }
}