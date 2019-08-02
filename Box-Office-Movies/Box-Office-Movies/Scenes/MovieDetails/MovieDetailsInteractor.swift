//
//  MovieDetailsInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core

protocol MovieDetailsDataStore {
    var movieIdentifier: Int? { get set }
    var posterData: Data? { get }
    var imageSecureBaseURLPath: String? { get }
    var posterPath: String? { get }
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
    
    var movieDetails: MovieDetails?
    var casting: Casting?
    var paginatedSimilarMovieLists = [PaginatedMovieList]()
    var posterData: Data?
    var error: Error?
    
    var imageSecureBaseURLPath: String?
    var posterPath: String?
}

extension MovieDetailsInteractor: MovieDetailsBusinessLogic {
    
    func fetchMovieDetails(request: MovieDetailsScene.FetchMovieDetails.Request) {
        let dispatchGroup = DispatchGroup()
        
        fetchDetails(dispatchGroup: dispatchGroup)
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            self?.fetchCasting()
            self?.fetchSimilarMovies()
            self?.fetchPosterData()
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
        let favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()
        let isFavorite = favoriteMovies?.contains(where: { $0.identifier == movieIdentifier })
        let response = MovieDetailsScene.LoadFavoriteToggle.Response(isFavorite: isFavorite)
        presenter?.presentFavoriteToggle(response: response)
    }
    
    func toggleFavorite(request: MovieDetailsScene.ToggleFavorite.Request) {
        guard let movieDetails = movieDetails else {
            return
        }
        var isMovieAddedToFavorite: Bool
        let favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies()
        if let movie = favoriteMovies?.first(where: { $0.identifier == movieDetails.identifier }) {
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
    
    func presentMovieDetails() {
        let response = MovieDetailsScene.FetchMovieDetails.Response(movieDetails: movieDetails,
                                                                    casting: casting,
                                                                    paginatedSimilarMovieLists: paginatedSimilarMovieLists,
                                                                    posterData: posterData,
                                                                    error: error)
        presenter?.presentMovieDetails(response: response)
    }
    
    func fetchDetails(dispatchGroup: DispatchGroup) {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        dispatchGroup.enter()
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        let regionCode = Locale.current.regionCode ?? Constants.Fallback.regionCode
        ManagerProvider.shared.movieManager.movieDetails(identifier: movieIdentifier, languageCode: languageCode, regionCode: regionCode) { [weak self] (movieDetails, error) in
            self?.movieDetails = movieDetails
            self?.posterPath = movieDetails?.posterPath
            self?.error = error
            self?.presentMovieDetails()
            dispatchGroup.leave()
        }
    }
    
    func fetchCasting() {
        guard let movieIdentifier = movieIdentifier else {
            return
        }
        ManagerProvider.shared.movieManager.casting(identifier: movieIdentifier) { [weak self] (casting, error) in
            self?.casting = casting
            self?.error = error
            self?.presentMovieDetails()
        }
    }
    
    func fetchSimilarMovies() {
        var shouldFetch = paginatedSimilarMovieLists.isEmpty
        if let totalPages = paginatedSimilarMovieLists.last?.totalPages {
            shouldFetch = similarMoviePage <= totalPages
        }
        
        guard shouldFetch, let movieIdentifier = movieIdentifier else {
            return
        }
        
        let languageCode = Locale.current.languageCode ?? Constants.Fallback.languageCode
        ManagerProvider.shared.movieManager.similarMovies(identifier: movieIdentifier, languageCode: languageCode, page: similarMoviePage) { [weak self] (paginatedSimilarMovieList, error) in
            if let paginatedSimilarMovieList = paginatedSimilarMovieList {
                self?.paginatedSimilarMovieLists.append(paginatedSimilarMovieList)
                self?.similarMoviePage += 1
            }
            self?.error = error
            self?.presentMovieDetails()
        }
    }
    
    func fetchPosterData() {
        var apiConfiguration: TheMovieDatabaseAPIConfiguration?
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        ManagerProvider.shared.movieManager.theMovieDatabaseAPIConfiguration { [weak self] (fetchedAPIConfiguration, _) in
            apiConfiguration = fetchedAPIConfiguration
            self?.imageSecureBaseURLPath = apiConfiguration?.imageData.secureBaseUrl
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            if let imageSecureBaseURLPath = self?.imageSecureBaseURLPath,
                let posterPath = self?.posterPath {
                ManagerProvider.shared.movieManager.poster(imageSecureBaseURL: imageSecureBaseURLPath, posterSize: Constants.Fallback.thumbnailPosterImageSize, posterPath: posterPath) { [weak self] (posterData, error) in
                    self?.posterData = posterData
                    self?.error = error
                    self?.presentMovieDetails()
                }
            }
        }
    }
}
