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
}

public class ManagerProvider: ManagerProviding {
    
    public static var sharedInstance: ManagerProviding = ManagerProvider()
    
    public var movieManager: MovieManagement!
    
    init() {
        let environment = Environment(theMovieDatabaseAPIBaseUrl: Constants.Environment.theMovieDatabaseAPIBaseUrl, theMovieDatabaseAPIKey: Constants.Environment.theMovieDatabaseAPIKey)
        let movieNetworkController = MovieNetworkController(environment: environment)
        movieManager = MovieManager(networkController: movieNetworkController)
    }
}
