//
//  NowPlayingMoviesPresenterTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import Box_Office_Movies_Core
import XCTest

final class NowPlayingMoviesPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: NowPlayingMoviesPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupNowPlayingMoviesPresenter()
    }
    
    // MARK: Test setup
    
    func setupNowPlayingMoviesPresenter() {
        sut = NowPlayingMoviesPresenter()
    }
    
    // MARK: Test doubles
    
    class NowPlayingMoviesDisplayLogicSpy: NowPlayingMoviesDisplayLogic {
    
        var displayNowPlayingMoviesExpectation = XCTestExpectation(description: "displayNowPlayingMovies called")
        var displayNextPageExpectation = XCTestExpectation(description: "displayNextPage called")
        var displayFilterMoviesCalled = false
        var displayRefreshMoviesExpectation = XCTestExpectation(description: "displayRefreshMovies called")
        var displayTableViewBackgroundViewCalled = false
        var displayFavoriteMoviesCalled = false
        var displayRefreshFavoriteMoviesCalled = false

        func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel) {
            XCTAssertEqual(viewModel.movieItems?.count, 3)

            displayNowPlayingMoviesExpectation.fulfill()
        }
        
        func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel) {
            XCTAssertEqual(viewModel.movieItems?.count, 2)
            
            displayFilterMoviesCalled = true
        }
        
        func displayTableViewBackgroundView(viewModel: NowPlayingMovies.LoadTableViewBackgroundView.ViewModel) {
            displayTableViewBackgroundViewCalled = true
        }
        
        func displayFavoriteMovies(viewModel: NowPlayingMovies.LoadFavoriteMovies.ViewModel) {
            displayFavoriteMoviesCalled = true
        }
        
        func displayRefreshFavoriteMovies(viewModel: NowPlayingMovies.RefreshFavoriteMovies.ViewModel) {
            displayRefreshFavoriteMoviesCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentNowPlayingMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: Movie.dummyInstances, networkError: .fetchNextPageError(DummyError.dummy), mode: .fetchNextPage)
            
        // When
        sut.presentNowPlayingMovies(response: response)
        
        // Then
        wait(for: [spy.displayNowPlayingMoviesExpectation], timeout: 0.1)
    }
    
    func testPresentFilterMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FilterMovies.Response(movies: Movie.dummyInstances)
        
        // When
        sut.presentFilterMovies(response: response)
        
        // Then
        XCTAssertTrue(spy.displayFilterMoviesCalled, "presentFilterMovies(response:) should ask the view controller to display the result")
    }
    
    func testPresentTableViewBackgroundViewForAllMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: .allMovies, searchText: nil, movies: [], networkError: .fetchFirstPageError(DummyError.dummy))
        
        // When
        sut.presentTableViewBackgroundView(response: response)
        
        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }
    
    func testPresentTableViewBackgroundViewForFavoritesWithSearchText() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: .favorites, searchText: "A", movies: [], networkError: .fetchFirstPageError(DummyError.dummy))

        // When
        sut.presentTableViewBackgroundView(response: response)

        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }

    func testPresentTableViewBackgroundViewForFavoritesWithoutSearchText() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: .favorites, searchText: nil, movies: [], networkError: .fetchFirstPageError(DummyError.dummy))

        // When
        sut.presentTableViewBackgroundView(response: response)

        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }
    
    func testPresentFavoriteMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadFavoriteMovies.Response(movies: nil, editButtonItem: nil)
        
        // When
        sut.presentFavoriteMovies(response: response)
        
        // Then
        XCTAssertTrue(spy.displayFavoriteMoviesCalled, "presentFavoriteMovies(response:) should ask the view controller to display the result")
    }
    
    func test_presentRefreshFavoriteMovies_shouldCallDisplayRefreshFavoriteMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy

        let response = NowPlayingMovies.RefreshFavoriteMovies.Response(movies: Movie.dummyInstances, refreshType: NowPlayingMovies.RefreshFavoriteMovies.Response.RefreshType.insertion(index: 0), state: .favorites, editButtonItem: nil)

        // When
        sut.presentRefreshFavoriteMovies(response: response)

        // Then
        XCTAssertTrue(spy.displayRefreshFavoriteMoviesCalled, "presentRefreshFavoriteMovies(response:) should ask the view controller to display the result")
    }
}

enum DummyError: Error {
    case dummy
}
