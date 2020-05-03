//
//  ManagerProvider.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
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
            return Environment(theMovieDatabaseAPIBaseUrl: theMovieDatabaseAPIBaseUrl, theMovieDatabaseAPIKey: theMovieDatabaseAPIKey)
        }()
        let session: NetworkSession = {
            #if DEBUG
            if ManagerProvider.isTest() {
                return MockedNetworkSession()
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
