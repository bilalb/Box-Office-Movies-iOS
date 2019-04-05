//
//  MovieDetailsInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
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
    }
    
    // MARK: Test setup
    
    func setupMovieDetailsInteractor() {
        sut = MovieDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsPresentationLogicSpy: MovieDetailsPresentationLogic {
        
        var presentMovieDetailsExpectation = XCTestExpectation(description: "presentMovieDetails called")
        var presentMovieReviewsCalled = false
        var presentReviewMovieCalled = false

        func presentMovieDetails(response: MovieDetailsScene.FetchMovieDetails.Response) {
            presentMovieDetailsExpectation.fulfill()
        }
        
        func presentMovieReviews(response: MovieDetailsScene.LoadMovieReviews.Response) {
            XCTAssertEqual(response.movieReviews.count, 5)
            
            presentMovieReviewsCalled = true
        }
        
        func presentReviewMovie(response: MovieDetailsScene.ReviewMovie.Response) {
            XCTAssertEqual(response.movieReview.description, "★★★★☆")
            
            presentReviewMovieCalled = true
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
}
