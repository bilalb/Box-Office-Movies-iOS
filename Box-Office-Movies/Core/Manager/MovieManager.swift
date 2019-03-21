//
//  MovieManager.swift
//  Box-Office-Movies
//

import Foundation

protocol MovieManagement {
}

final class MovieManager: MovieManagement {
    
    private var networkController: MovieNetworkControlling
    
    init(networkController: MovieNetworkControlling) {
        self.networkController = networkController
    }
}
