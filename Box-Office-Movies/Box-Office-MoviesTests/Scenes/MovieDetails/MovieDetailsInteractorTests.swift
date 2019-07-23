//
//  MovieDetailsInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
import Box_Office_Movies_Core
import XCTest

class MovieDetailsInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: MovieDetailsInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieDetailsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        
        ManagerProvider.shared.favoritesManager.favoriteMovies()?.forEach({ movie in
            _ = ManagerProvider.shared.favoritesManager.removeMovieFromFavorites(movie)
        })
    }
    
    // MARK: Test setup
    
    func setupMovieDetailsInteractor() {
        sut = MovieDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsPresentationLogicSpy: MovieDetailsPresentationLogic {
        
        var presentMovieDetailsCalled = false
        var presentMovieReviewsCalled = false
        var presentReviewMovieCalled = false
        var presentFavoriteToggleCalled = false
        var presentToggleFavoriteCalled = false

        func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
            presentMovieDetailsCalled = true
        }
        
        func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response) {
            XCTAssertEqual(response.movieReviews.count, 5)
            
            presentMovieReviewsCalled = true
        }
        
        func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response) {
            XCTAssertEqual(response.movieReview.description, "★★★★☆")
            
            presentReviewMovieCalled = true
        }
        
        func presentFavoriteToggle(response: MovieDetailsScene.LoadFavoriteToggle.Response) {
            presentFavoriteToggleCalled = true
        }
        
        func presentToggleFavorite(response: MovieDetailsScene.ToggleFavorite.Response) {
            presentToggleFavoriteCalled = true
        }
    }
    
    // MARK: Tests
    
    func testLoadMovieReviews() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        let request = MovieDetailsScene.LoadMovieReviews.Request()
        
        // When
        sut.loadMovieReviews(request: request)
        
        // Then
        XCTAssertTrue(spy.presentMovieReviewsCalled, "loadMovieReviews(request:) should ask the presenter to format the result")
    }
    
    func testReviewMovie() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        let request = MovieDetailsScene.ReviewMovie.Request(movieReview: MovieReview.fourStars)
        
        // When
        sut.reviewMovie(request: request)
        
        // Then
        XCTAssertTrue(spy.presentReviewMovieCalled, "reviewMovie(request:) should ask the presenter to format the result")
    }
    
    func testLoadFavoriteToggle() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieIdentifier = 0
        
        let request = MovieDetailsScene.LoadFavoriteToggle.Request()
        
        // When
        sut.loadFavoriteToggle(request: request)
        
        // Then
        XCTAssertTrue(spy.presentFavoriteToggleCalled, "loadFavoriteToggle(request:) should ask the presenter to format the result")
    }
    
    func testToggleFavoriteForMovieToAddToFavorites() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieDetails = MovieDetails.dummyInstance
        
        let request = MovieDetailsScene.ToggleFavorite.Request()
        
        // When
        sut.toggleFavorite(request: request)
        
        // Then
        XCTAssertTrue(spy.presentToggleFavoriteCalled, "toggleFavorite(request:) should ask the presenter to format the result")
    }
    
    func testToggleFavoriteForMovieRemoveFromFavorites() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieDetails = MovieDetails.dummyInstance
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(MovieDetails.dummyInstance.relatedMovie)
        
        let request = MovieDetailsScene.ToggleFavorite.Request()
        
        // When
        sut.toggleFavorite(request: request)
        
        // Then
        XCTAssertTrue(spy.presentToggleFavoriteCalled, "toggleFavorite(request:) should ask the presenter to format the result")
    }
    
    func testPresentMovieDetails() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy

        // When
        sut.presentMovieDetails()
        
        // Then
        XCTAssertTrue(spy.presentMovieDetailsCalled, "presentMovieDetails() should ask the presenter to format the result")
    }
}

extension MovieDetails {
    
    static var dummyInstance: MovieDetails {
        return MovieDetails(identifier: 0, title: "foo", releaseDate: "12345", voteAverage: 1, synopsis: "bar", posterPath: "a")
    }
}
