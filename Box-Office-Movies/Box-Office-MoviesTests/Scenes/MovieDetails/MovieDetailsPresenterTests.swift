//
//  MovieDetailsPresenterTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
import Box_Office_Movies_Core
import XCTest

class MovieDetailsPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: MovieDetailsPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieDetailsPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupMovieDetailsPresenter() {
        sut = MovieDetailsPresenter()
    }
    
    // MARK: Test doubles
    
    class MovieDetailsDisplayLogicSpy: MovieDetailsDisplayLogic {
        
        var displayMovieDetailsExpectation = XCTestExpectation(description: "displayMovieDetails called")
        var displayMovieReviewsCalled = false
        var displayReviewMovieCalled = false
        
        func displayMovieDetails(viewModel: MovieDetailsScene.FetchMovieDetails.ViewModel) {
            XCTAssertEqual(viewModel.detailItems?.count, 6)
            
            displayMovieDetailsExpectation.fulfill()
        }
        
        func displayMovieReviews(viewModel: MovieDetailsScene.LoadMovieReviews.ViewModel) {
            XCTAssertEqual(viewModel.alertControllerTitle, NSLocalizedString("reviewTheMovie", comment: "reviewTheMovie"))
            XCTAssertNil(viewModel.alertControllerMessage)
            XCTAssertEqual(viewModel.alertControllerPreferredStyle, .actionSheet)
            XCTAssertEqual(viewModel.actions.count, 6)
            XCTAssertEqual(viewModel.actions.first?.alertAction.title, "★☆☆☆☆")
            
            displayMovieReviewsCalled = true
        }
        
        func displayReviewMovie(viewModel: MovieDetailsScene.ReviewMovie.ViewModel) {
            if case .reviewMovie(let review) = viewModel.reviewMovieItem {
                XCTAssertEqual(review, "★★★★☆")
            } else {
                XCTFail("The detailItem instance of the viewModel should be a reviewMovie item")
            }
            
            displayReviewMovieCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentMovieDetails() {
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        
        let response = MovieDetailsScene.FetchMovieDetails.Response(movieDetails: MovieDetails(identifier: 42, title: "Whiplash", releaseDate: "2019-05-04", voteAverage: 8.5, synopsis: "masterpiece", posterPath: "posterPath"),
                                                                    casting: Casting(actors: [Casting.Actor(name: "John Doe")]), paginatedSimilarMovieLists: [PaginatedMovieList(page: 1, totalPages: 1, movies: [Movie(identifier: 1, title: "Mo Better Blues"),
                                                                                                                                                                                                                  Movie(identifier: 2, title: "8 miles")
                                                                        ])],
                                                                    posterImage: nil,
                                                                    error: nil)
        
        // When
        sut.presentMovieDetails(response: response)
        
        // Then
        wait(for: [spy.displayMovieDetailsExpectation], timeout: 0.1)
    }
    
    func testPresentMovieReviews() {
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        
        let response = MovieDetailsScene.LoadMovieReviews.Response(movieReviews: MovieReview.allCases)
        
        // When
        sut.presentMovieReviews(response: response)
        
        // Then
        XCTAssertTrue(spy.displayMovieReviewsCalled, "presentMovieReviews(response:) should ask the view controller to display the result")
    }
    
    func testPresentReviewMovie() {
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        
        let response = MovieDetailsScene.ReviewMovie.Response(movieReview: MovieReview.fourStars)
        
        // When
        sut.presentReviewMovie(response: response)
        
        // Then
        XCTAssertTrue(spy.displayReviewMovieCalled, "presentReviewMovie(response:) should ask the view controller to display the result")
    }
}
