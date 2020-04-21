//
//  FavoritesManagerTests.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.07.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies_Core
import XCTest

final class FavoritesManagerTests: XCTestCase {
    
    var sut: FavoritesManager!
    
    override func setUp() {
        super.setUp()
        sut = ManagerProvider.shared.favoritesManager as? FavoritesManager
    }
    
    override func tearDown() {
        super.tearDown()
        ManagerProvider.shared.favoritesManager.favoriteMovies()?.forEach({ movie in
            _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(movie)
        })
    }
    
    func testAddMovieToFavorites() {
        // Given
        let movie = Movie.dummyInstance
        
        // When
        let success = sut.addMovieToFavorites(movie)
        
        // Then
        XCTAssertTrue(success)
    }
    
    func testRemoveExistingMovieFromFavorites() {
        // Given
        let movie = Movie.dummyInstance
        _ = sut.addMovieToFavorites(movie)
        
        // When
        let success = sut.removeMovieFromFavorites(movie)
        
        // Then
        XCTAssertTrue(success)
    }
    
    func testRemoveNonExistingMovieFromFavorites() {
        // Given
        let movie = Movie.dummyInstance
        
        // When
        let success = sut.removeMovieFromFavorites(movie)
        
        // Then
        XCTAssertFalse(success)
    }
}

extension Movie {
    
    static var dummyInstance: Movie {
        return Movie(identifier: 42, title: "Whiplash")
    }
}
