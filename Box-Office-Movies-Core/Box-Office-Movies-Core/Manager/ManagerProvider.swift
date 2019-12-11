//
//  ManagerProvider.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

public protocol ManagerProviding {
    
    var movieManager: MovieManagement! { get }
    var favoritesManager: FavoritesManagement! { get }
}

public class ManagerProvider: ManagerProviding {
    
    public static var shared: ManagerProviding = ManagerProvider()
    
    public var movieManager: MovieManagement!
    public var favoritesManager: FavoritesManagement!
    
    init() {
        let environment: Environment = {
            guard
                let theMovieDatabaseAPIBaseUrl = Bundle.core.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.theMovieDatabaseAPIBaseUrl) as? String,
                let theMovieDatabaseAPIKey = Bundle.core.object(forInfoDictionaryKey: Constants.InfoDictionaryKey.theMovieDatabaseAPIKey) as? String
            else {
                preconditionFailure("failed to read configuration")
            }
            // xcconfig files treat the sequence // as a comment delimiter, regardless of whether it’s enclosed in quotation marks. If you try to escape with backslashes \/\/, those backslashes show up literally and must be removed from the resulting value.
            // I decided to omit the scheme in the xcconfig file and now I have to prepend https://
            let completeBaseUrl = "https://" + theMovieDatabaseAPIBaseUrl
            return Environment(theMovieDatabaseAPIBaseUrl: completeBaseUrl, theMovieDatabaseAPIKey: theMovieDatabaseAPIKey)
        }()
        let session: URLSession = {
            #if DEBUG
            if ManagerProvider.isTest() {
                return MockedURLSession()
            }
            #endif
            let session = URLSession(configuration: .default)
            session.configuration.timeoutIntervalForRequest = Constants.Network.timeoutIntervalForRequest
            session.configuration.timeoutIntervalForResource = Constants.Network.timeoutIntervalForResource
            return session
        }()
        let movieNetworkController = MovieNetworkController(environment: environment, session: session)
        movieManager = MovieManager(networkController: movieNetworkController)
        
        let favoritesDataAccessController = FavoritesDataAccessController()
        favoritesManager = FavoritesManager(dataAccessController: favoritesDataAccessController)
    }
}

extension ManagerProvider {
    
    #if DEBUG
    /// Indicates if test is running.
    ///
    /// - Returns: `true` if test is running; otherwise, `false`.
    static func isTest() -> Bool {
        return NSClassFromString("XCTest") != nil
    }
    #endif
}
