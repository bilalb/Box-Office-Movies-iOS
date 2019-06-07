//
//  FavoritesManager.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

public protocol FavoritesManagement {
    
    func addMovieToFavorites(_ movie: Movie) -> Bool
    func removeMovieFromFavorites(_ movie: Movie) -> Bool
    func favoriteMovies() -> [Movie]?
}

final class FavoritesManager: FavoritesManagement {
    
    private var dataAccessController: FavoritesDataAccessControlling
    
    init(dataAccessController: FavoritesDataAccessControlling) {
        self.dataAccessController = dataAccessController
    }
    
    func addMovieToFavorites(_ movie: Movie) -> Bool {
        return dataAccessController.addMovieToFavorites(movie)
    }
    
    func removeMovieFromFavorites(_ movie: Movie) -> Bool {
        return dataAccessController.removeMovieFromFavorites(movie)
    }
    
    func favoriteMovies() -> [Movie]? {
        return dataAccessController.favoriteMovies()
    }
}
