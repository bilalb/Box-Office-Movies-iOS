//
//  NowPlayingMoviesPresenterTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
import Box_Office_Movies_Core
import XCTest

class NowPlayingMoviesPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: NowPlayingMoviesPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupNowPlayingMoviesPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
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
        var displayRemoveMovieFromFavoritesCalled = false
        var displayTableViewBackgroundViewCalled = false

        func displayNowPlayingMovies(viewModel: NowPlayingMovies.FetchNowPlayingMovies.ViewModel) {
            XCTAssertEqual(viewModel.movieItems?.count, 2)
            XCTAssertEqual(viewModel.movieItems?.first?.title, "Whiplash")
            XCTAssertTrue(viewModel.shouldHideErrorView)
            XCTAssertNil(viewModel.errorDescription)
            
            displayNowPlayingMoviesExpectation.fulfill()
        }
        
        func displayNextPage(viewModel: NowPlayingMovies.FetchNextPage.ViewModel) {
            XCTAssertEqual(viewModel.movieItems?.count, 2)
            XCTAssertFalse(viewModel.shouldPresentErrorAlert)
            XCTAssertNil(viewModel.errorAlertTitle)
            XCTAssertNil(viewModel.errorAlertMessage)
            XCTAssertEqual(viewModel.errorAlertActions.count, 1)
            XCTAssertEqual(viewModel.errorAlertActions.first?.title, NSLocalizedString("ok", comment: "ok"))
            XCTAssertEqual(viewModel.errorAlertActions.first?.style, .cancel)
            
            displayNextPageExpectation.fulfill()
        }
        
        func displayFilterMovies(viewModel: NowPlayingMovies.FilterMovies.ViewModel) {
            XCTAssertEqual(viewModel.movieItems?.count, 2)
            XCTAssertEqual(viewModel.movieItems?.first?.title, "Whiplash")
            
            displayFilterMoviesCalled = true
        }
        
        func displayRefreshMovies(viewModel: NowPlayingMovies.RefreshMovies.ViewModel) {
            XCTAssertEqual(viewModel.movieItems?.count, 2)
            XCTAssertFalse(viewModel.shouldPresentErrorAlert)
            XCTAssertNil(viewModel.errorAlertTitle)
            XCTAssertNil(viewModel.errorAlertMessage)
            XCTAssertEqual(viewModel.errorAlertActions.count, 1)
            XCTAssertEqual(viewModel.errorAlertActions.first?.title, NSLocalizedString("ok", comment: "ok"))
            XCTAssertEqual(viewModel.errorAlertActions.first?.style, .cancel)
            
            displayRefreshMoviesExpectation.fulfill()
        }
        
        func displayRemoveMovieFromFavorites(viewModel: NowPlayingMovies.RemoveMovieFromFavorites.ViewModel) {
            displayRemoveMovieFromFavoritesCalled = true
        }
        
        func displayTableViewBackgroundView(viewModel: NowPlayingMovies.LoadTableViewBackgroundView.ViewModel) {
            displayTableViewBackgroundViewCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentNowPlayingMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: Movie.dummyInstances, error: nil)
            
        // When
        sut.presentNowPlayingMovies(response: response)
        
        // Then
        wait(for: [spy.displayNowPlayingMoviesExpectation], timeout: 0.1)
    }
    
    func testPresentNextPage() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FetchNextPage.Response(movies: Movie.dummyInstances, error: nil)
            
        // When
        sut.presentNextPage(response: response)
        
        // Then
        wait(for: [spy.displayNextPageExpectation], timeout: 0.1)
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
    
    func testPresentRefreshMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.RefreshMovies.Response(movies: Movie.dummyInstances, error: nil)
            
        // When
        sut.presentRefreshMovies(response: response)
        
        // Then
        wait(for: [spy.displayRefreshMoviesExpectation], timeout: 0.1)
    }
    
    func testPresentRemoveMovieFromFavorites() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.RemoveMovieFromFavorites.Response(movies: Movie.dummyInstances, indexPathForMovieToRemove: IndexPath(row: 0, section: 0))
        
        // When
        sut.presentRemoveMovieFromFavorites(response: response)
        
        // Then
        XCTAssertTrue(spy.displayRemoveMovieFromFavoritesCalled, "presentRemoveMovieFromFavorites(response:) should ask the view controller to display the result")
    }
    
    func testPresentTableViewBackgroundViewForAllMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: .allMovies, searchText: nil, movies: [])
        
        // When
        sut.presentTableViewBackgroundView(response: response)
        
        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }
    
    func testPresentTableViewBackgroundViewForFavoritesWithSearchText() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: .favorites, searchText: "A", movies: [])
        
        // When
        sut.presentTableViewBackgroundView(response: response)
        
        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }
    
    func testPresentTableViewBackgroundViewForFavoritesWithoutSearchText() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.LoadTableViewBackgroundView.Response(state: .favorites, searchText: nil, movies: [])
        
        // When
        sut.presentTableViewBackgroundView(response: response)
        
        // Then
        XCTAssertTrue(spy.displayTableViewBackgroundViewCalled, "presentTableViewBackgroundView(response:) should ask the view controller to display the result")
    }
}
