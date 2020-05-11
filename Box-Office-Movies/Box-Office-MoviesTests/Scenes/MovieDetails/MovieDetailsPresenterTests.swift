//
//  MovieDetailsPresenterTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import Box_Office_Movies_Core
import XCTest

final class MovieDetailsPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: MovieDetailsPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupMovieDetailsPresenter()
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
        var displayFavoriteToggleCalled = false
        var displayTableViewBackgroundViewCalled = false
        
        func displayMovieDetails(viewModel: MovieDetailsScene.FetchMovieDetails.ViewModel) {
            XCTAssertEqual(viewModel.detailItems?.count, 7)
            
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
        
        func displayFavoriteToggle(viewModel: MovieDetailsScene.LoadFavoriteToggle.ViewModel) {
            displayFavoriteToggleCalled = true
        }

        func displayTableViewBackgroundView(viewModel: MovieDetailsScene.LoadTableViewBackgroundView.ViewModel) {
            displayTableViewBackgroundViewCalled = true
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
                                                                    posterData: Data(),
                                                                    trailer: Video.dummyInstance,
                                                                    error: nil,
                                                                    remainingRequestCount: 0,
                                                                    isReviewEnabled: true)
        
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
    
    func testPresentFavoriteToggle() {
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy
        
        let response = MovieDetailsScene.LoadFavoriteToggle.Response(isFavorite: true)
        
        // When
        sut.presentFavoriteToggle(response: response)
        
        // Then
        XCTAssertTrue(spy.displayFavoriteToggleCalled, "presentFavoriteToggle(response:) should ask the view controller to display the result")
    }

    func test_presentTableViewBackgroundView_shouldCallDisplayTableViewBackgroundView() {
        // Given
        let spy = MovieDetailsDisplayLogicSpy()
        sut.viewController = spy

        let response = MovieDetailsScene.LoadTableViewBackgroundView.Response(
            movieDetails: nil,
            casting: nil,
            paginatedSimilarMovieLists: nil,
            posterData: nil,
            trailer: nil,
            error: nil)

        // When
        sut.presentTableViewBackgroundView(response: response)

        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }
}

extension Video {
    
    static var dummyInstance: Video {
        return Video(key: "foo", site: .youTube, type: .trailer)
    }
}
