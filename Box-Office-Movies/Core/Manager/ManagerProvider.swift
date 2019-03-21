//
//  ManagerProvider.swift
//  Box-Office-Movies
//

import Foundation

protocol ManagerProviding {
    
    var movieManager: MovieManager! { get }
}

class ManagerProvider: ManagerProviding {
    
    static var sharedInstance: ManagerProviding = ManagerProvider()
    
    var movieManager: MovieManager!
    
    init() {
        let environment = Environment(baseURL: Constants.Environment.theMovieDatabaseAPIBaseUrl)
        let movieNetworkController = MovieNetworkController(environment: environment)
        movieManager = MovieManager(networkController: movieNetworkController)
    }
}
