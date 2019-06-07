//
//  MovieDetailsInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import UIKit

protocol MovieDetailsDataStore {
     var movieIdentifier: Int? { get set }
}

protocol MovieDetailsBusinessLogic {
    func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request)
    func loadMovieReviews(request: MovieDetailsScene.LoadMovieReviews.Request)
    func reviewMovie(request: MovieDetailsScene.ReviewMovie.Request)
    func loadFavoriteToggle(request: MovieDetailsScene.LoadFavoriteToggle.Request)
    func toggleFavorite(request: MovieDetailsScene.ToggleFavorite.Request)
}

class MovieDetailsInteractor: MovieDetailsDataStore {
    // MARK: Instance Properties
    var presenter: MovieDetailsPresentationLogic?
    
    var movieIdentifier: Int?
    var similarMoviePage = 1
    
    // TODO: still useful ? if not, to remove
    var paginatedSimilarMovieLists = [PaginatedMovieList]()
    
    var movieDetails: MovieDetails?
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
                self?.movieDetails = movieDetails
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
    
    func loadFavoriteToggle(request: MovieDetailsScene.LoadFavoriteToggle.Request) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        let isFavorite = ManagerProvider.shared.favoritesManager.favoriteMovies()?.contains(where: { $0.identifier == movieIdentifier })
        let response = MovieDetailsScene.LoadFavoriteToggle.Response(isFavorite: isFavorite)
        presenter?.presentFavoriteToggle(response: response)
    }
    
    func toggleFavorite(request: MovieDetailsScene.ToggleFavorite.Request) {
        guard let movieDetails = movieDetails else {
            return
        }
        var isMovieAddedToFavorite: Bool
        if let movie = ManagerProvider.shared.favoritesManager.favoriteMovies()?.first(where: { $0.identifier == movieDetails.identifier }) {
            _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(movie)
            isMovieAddedToFavorite = false
        } else {
            isMovieAddedToFavorite = ManagerProvider.shared.favoritesManager.addMovieToFavorites(movieDetails.relatedMovie)
        }
        
        let response = MovieDetailsScene.ToggleFavorite.Response(isMovieAddedToFavorite: isMovieAddedToFavorite)
        presenter?.presentToggleFavorite(response: response)
    }
}

extension MovieDetailsInteractor {
    
    func fetchAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?) {
        ManagerProvider.shared.movieManager.theMovieDatabaseAPIConfiguration(completionHandler: completionHandler)
    }
    
    func fetchDetails(completionHandler: MovieDetailsCompletionHandler?) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        let regionCode = Locale.current.regionCode ?? Constants.Fallback.regionCode
        ManagerProvider.shared.movieManager.movieDetails(identifier: movieIdentifier, languageCode: languageCode, regionCode: regionCode, completionHandler: completionHandler)
    }
    
    func fetchCasting(completionHandler: CastingCompletionHandler?) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        ManagerProvider.shared.movieManager.casting(identifier: movieIdentifier, completionHandler: completionHandler)
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
        ManagerProvider.shared.movieManager.similarMovies(identifier: movieIdentifier, languageCode: languageCode, page: similarMoviePage, completionHandler: completionHandler)
    }
    
    func fetchPosterImage(imageSecureBaseURLPath: String, posterSize: String = Constants.Fallback.posterImageSize, posterPath: String, completionHandler: PosterCompletionHandler?) {
        ManagerProvider.shared.movieManager.poster(imageSecureBaseURL: imageSecureBaseURLPath, posterSize: posterSize, posterPath: posterPath, completionHandler: completionHandler)
    }
}

// TODO: To move to FavoriteMovie.swift
extension FavoriteMovie {
    
    var relatedMovie: Movie? {
        guard let title = title else {
            return nil
        }
        return Movie()
    }
}

extension FavoriteMovie {
    
    static let entityName = String(describing: FavoriteMovie.self)
}

extension FavoriteMovie {
    
    struct Key {
        
        static let identifier = "identifier"
        static let title = "title"
    }
}
