//
//  MovieDetailsInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import Box_Office_Movies_Core
import XCTest

final class MovieDetailsInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: MovieDetailsInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieDetailsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        
        ManagerProvider.shared.favoritesManager.removeAllMovies()
    }
    
    // MARK: Test setup
    
    func setupMovieDetailsInteractor() {
        sut = MovieDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsPresentationLogicSpy: MovieDetailsPresentationLogic {
        
        var presentMovieDetailsExpectation = XCTestExpectation(description: "presentMovieDetails called")
        var presentMovieDetailsCalled = false
        var presentMovieReviewsCalled = false
        var presentReviewMovieCalled = false
        var presentFavoriteToggleCalled = false

        func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
            presentMovieDetailsExpectation.fulfill()
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
    }
    
    // MARK: Tests
    
    func testFetchMovieDetails() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieIdentifier = 42
        let request = MovieDetailsScene.FetchMovieDetails.Request()
        
        // When
        sut.fetchMovieDetails(request: request)
        
        wait(for: [spy.presentMovieDetailsExpectation], timeout: 0.1)
    }
    
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
                
        let request = MovieDetailsScene.LoadFavoriteToggle.Request()
        
        // When
        sut.loadFavoriteToggle(request: request)
        
        // Then
        XCTAssertTrue(spy.presentFavoriteToggleCalled, "loadFavoriteToggle(request:) should ask the presenter to format the result")
    }
    
    func test_isMovieAddedToFavorites_withNilMovieIdentifier_shouldReturnNil() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieIdentifier = nil
        
        // When
        let isMovieAddedToFavorites = sut.isMovieAddedToFavorites()
        
        // Then
        XCTAssertNil(isMovieAddedToFavorites)
    }
    
    func test_isMovieAddedToFavorites_withFavoriteMovie_shouldReturnTrue() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.movieIdentifier = Int(Movie.dummyInstance.identifier)
        
        // When
        let isMovieAddedToFavorites = sut.isMovieAddedToFavorites()
        
        // Then
        XCTAssertEqual(isMovieAddedToFavorites, true)
    }
    
    func test_isMovieAddedToFavorites_withUnfavoriteMovie_shouldReturnFalse() {
        // Given
        let spy = MovieDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movieIdentifier = 42
        
        // When
        let isMovieAddedToFavorites = sut.isMovieAddedToFavorites()
        
        // Then
        XCTAssertEqual(isMovieAddedToFavorites, false)
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
    
    func testFetchTrailer() {
        // Given
        let expectation = XCTestExpectation(description: "video completion handler called")
        
        sut.movieIdentifier = 0

        // When
        sut.fetchTrailer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Then
            XCTAssertNotNil(self.sut.trailer, "fetchTrailer() should set the trailer")
            XCTAssertNil(self.sut.error, "fetchTrailer() should set the error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.11)
    }
}

extension MovieDetails {
    
    static var dummyInstance: MovieDetails {
        return MovieDetails(identifier: 0, title: "foo", releaseDate: "12345", voteAverage: 1, synopsis: "bar", posterPath: "a")
    }
}
