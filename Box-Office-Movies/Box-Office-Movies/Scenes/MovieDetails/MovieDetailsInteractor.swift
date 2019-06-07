//
//  MovieDetailsInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import CoreData
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
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let movieIdentifier = movieIdentifier
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteMovie.entityName)
        
        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [FavoriteMovie] {
                let isMovieAddedToFavorite = favoriteMovies.contains(where: { $0.identifier == movieIdentifier })
                
                let response = MovieDetailsScene.LoadFavoriteToggle.Response(isMovieAddedToFavorite: isMovieAddedToFavorite)
                presenter?.presentFavoriteToggle(response: response)
            }
        } catch let error as NSError {
            print("A Core Data error occurred. \(error), \(error.userInfo)")
        }
    }
    
    func toggleFavorite(request: MovieDetailsScene.ToggleFavorite.Request) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let movieDetails = movieDetails
            else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteMovie.entityName)
        
        var isMovieAddedToFavorite: Bool?
        
        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [FavoriteMovie] {
                if let savedFavoriteMovie = favoriteMovies.first(where: { $0.identifier == movieDetails.identifier }) {
                    managedContext.delete(savedFavoriteMovie)
                    try managedContext.save()
                    isMovieAddedToFavorite = false
                } else {
                    if let favoriteMovieEntity = NSEntityDescription.entity(forEntityName: FavoriteMovie.entityName, in: managedContext) {
                        let favoriteMovie = NSManagedObject(entity: favoriteMovieEntity, insertInto: managedContext)
                        favoriteMovie.setValue(movieDetails.identifier, forKey: FavoriteMovie.Key.identifier)
                        favoriteMovie.setValue(movieDetails.title, forKey: FavoriteMovie.Key.title)
                        
                        try managedContext.save()
                        isMovieAddedToFavorite = true
                    }
                }
            }
            if let isMovieAddedToFavorite = isMovieAddedToFavorite {
                let response = MovieDetailsScene.ToggleFavorite.Response(isMovieAddedToFavorite: isMovieAddedToFavorite)
                presenter?.presentToggleFavorite(response: response)
            }
        } catch let error as NSError {
            print("A Core Data error occurred. \(error), \(error.userInfo)")
        }
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

// TODO: To move to FavoriteMovie.swift
extension FavoriteMovie {
    
    var relatedMovie: Movie? {
        guard let title = title else {
            return nil
        }
        return Movie(identifier: Int(identifier), title: title)
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
