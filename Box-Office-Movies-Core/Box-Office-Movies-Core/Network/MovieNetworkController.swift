//
//  MovieNetworkController.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation
import CoreData

protocol MovieNetworkControlling {
    
    /// Fetches the list of movies now playing in theatres.
    ///
    /// - Parameters:
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - regionCode: Region code in ISO 3166-1 format.
    ///   - page: Page to query (minimum: `1`, maximum: `1000`).
    ///   - completionHandler: The completion handler to call when the request is complete.
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?)
    
    /// Fetches the details of a movie.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - regionCode: Region code in ISO 3166-1 format.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func movieDetails(identifier: Int, languageCode: String, regionCode: String, completionHandler: MovieDetailsCompletionHandler?)
    
    /// Fetches the configuration of The Movie Database API.
    ///
    /// - Parameters:
    ///   - completionHandler: The completion handler to call when the request is complete.
    func theMovieDatabaseAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?)
    
    /// Fetches the data for the poster of a movie.
    ///
    /// - Parameters:
    ///   - imageSecureBaseURL: Image secure base url.
    ///   - posterSize: Size of the poster to request.
    ///   - posterPath: Path to the poster.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func posterData(imageSecureBaseURL: String, posterSize: String, posterPath: String, completionHandler: PosterDataCompletionHandler?)
    
    /// Fetches the casting of a movie.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func casting(identifier: Int, completionHandler: CastingCompletionHandler?)
    
    /// Fetches the list of similar movies.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - page: Page to query (minimum: `1`, maximum: `1000`).
    ///   - completionHandler: The completion handler to call when the request is complete.
    func similarMovies(identifier: Int, languageCode: String, page: Int, completionHandler: SimilarMoviesCompletionHandler?)
    
    /// Fetches the videos of a movie.
    ///
    /// - Parameters:
    ///   - identifier: Identifier of the movie.
    ///   - languageCode: Language code in ISO 639-1 format.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func videos(identifier: Int, languageCode: String, completionHandler: VideosCompletionHandler?)
}

class MovieNetworkController: NetworkController, MovieNetworkControlling {
    
    func nowPlayingMovies(languageCode: String, regionCode: String, page: Int, completionHandler: NowPlayingMoviesCompletionHandler?) {
        let request = NowPlayingMoviesNetworkRequest(environment: environment,
                                                     languageCode: languageCode,
                                                     regionCode: regionCode,
                                                     page: page)
        send(request: request) { (data, _, error) in
            if let data = data, let managedObjectContextCodingUserInfoKey = CodingUserInfoKey.managedObjectContext {
                let managedObjectContext = CoreDataStack.shared.persistentContainer.newBackgroundContext()
                let jsonDecoder = JSONDecoder()
                jsonDecoder.userInfo[managedObjectContextCodingUserInfoKey] = managedObjectContext
                let paginatedMovieList = try? jsonDecoder.decode(PaginatedMovieList.self, from: data)
                completionHandler?(paginatedMovieList, error)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func movieDetails(identifier: Int, languageCode: String, regionCode: String, completionHandler: MovieDetailsCompletionHandler?) {
        let request = MovieDetailsNetworkRequest(environment: environment,
                                                 identifier: identifier,
                                                 languageCode: languageCode,
                                                 regionCode: regionCode)
        send(request: request) { (data, _, error) in
            if let data = data, let movieDetails = try? JSONDecoder().decode(MovieDetails.self, from: data) {
                completionHandler?(movieDetails, error)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func theMovieDatabaseAPIConfiguration(completionHandler: TheMovieDatabaseAPIConfigurationCompletionHandler?) {
        let request = TheMovieDatabaseAPIConfigurationNetworkRequest(environment: environment)
        send(request: request) { (data, _, error) in
            if let data = data, let configuration = try? JSONDecoder().decode(TheMovieDatabaseAPIConfiguration.self, from: data) {
                completionHandler?(configuration, error)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func posterData(imageSecureBaseURL: String, posterSize: String, posterPath: String, completionHandler: PosterDataCompletionHandler?) {
        let request = PosterNetworkRequest(environment: environment,
                                           imageSecureBaseURL: imageSecureBaseURL,
                                           posterSize: posterSize,
                                           posterPath: posterPath)
        send(request: request) { (data, _, error) in
            completionHandler?(data, error)
        }
    }
    
    func casting(identifier: Int, completionHandler: CastingCompletionHandler?) {
        let request = CastingNetworkRequest(environment: environment, identifier: identifier)
        send(request: request) { (data, _, error) in
            if let data = data, let casting = try? JSONDecoder().decode(Casting.self, from: data) {
                completionHandler?(casting, error)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func similarMovies(identifier: Int, languageCode: String, page: Int, completionHandler: SimilarMoviesCompletionHandler?) {
        let request = SimilarMoviesNetworkRequest(environment: environment, identifier: identifier, languageCode: languageCode, page: page)
        send(request: request) { (data, _, error) in
            if let data = data, let managedObjectContextCodingUserInfoKey = CodingUserInfoKey.managedObjectContext {
                let managedObjectContext = CoreDataStack.shared.persistentContainer.newBackgroundContext()
                let jsonDecoder = JSONDecoder()
                jsonDecoder.userInfo[managedObjectContextCodingUserInfoKey] = managedObjectContext
                let paginatedSimilarMovieList = try? jsonDecoder.decode(PaginatedMovieList.self, from: data)
                completionHandler?(paginatedSimilarMovieList, error)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
    
    func videos(identifier: Int, languageCode: String, completionHandler: VideosCompletionHandler?) {
        let request = VideosNetworkRequest(environment: environment, identifier: identifier, languageCode: languageCode)
        send(request: request) { (data, _, error) in
            if let data = data, let videoResponse = try? JSONDecoder().decode(VideoResponse.self, from: data) {
                completionHandler?(videoResponse.videos, error)
            } else {
                completionHandler?(nil, error)
            }
        }
    }
}
