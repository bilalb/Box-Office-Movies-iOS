//
//  MovieDetailsPresenterTests.swift
//  Box-Office-Movies
//
//  (c) Neofonie Mobile GmbH (2019)
//
//  This computer program is the sole property of Neofonie
//  Mobile GmbH (http://mobile.neofonie.de) and is protected
//  under the German Copyright Act (paragraph 69a UrhG).
//
//  All rights are reserved. Making copies, duplicating,
//  modifying, using or distributing this computer program
//  in any form, without prior written consent of Neofonie
//  Mobile GmbH, is prohibited.
//
//  Violation of copyright is punishable under the German
//  Copyright Act (paragraph 106 UrhG).
//
//  Removing this copyright statement is also a violation.

@testable import Box_Office_Movies
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
        wait(for: [spy.displayMovieDetailsExpectation], timeout: 0.3)
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
