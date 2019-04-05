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
    }
    
    // MARK: Tests
    
    func testPresentNowPlayingMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FetchNowPlayingMovies.Response(movies: dummyMovies, error: nil)
            
        // When
        sut.presentNowPlayingMovies(response: response)
        
        // Then
        wait(for: [spy.displayNowPlayingMoviesExpectation], timeout: 0.1)
    }
    
    func testPresentNextPage() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FetchNextPage.Response(movies: dummyMovies, error: nil)
            
        // When
        sut.presentNextPage(response: response)
        
        // Then
        wait(for: [spy.displayNextPageExpectation], timeout: 0.1)
    }
    
    func testPresentFilterMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.FilterMovies.Response(movies: dummyMovies)
        
        // When
        sut.presentFilterMovies(response: response)
        
        // Then
        XCTAssertTrue(spy.displayFilterMoviesCalled, "presentFilterMovies(response:) should ask the view controller to display the result")
    }
    
    func testPresentRefreshMovies() {
        // Given
        let spy = NowPlayingMoviesDisplayLogicSpy()
        sut.viewController = spy
        let response = NowPlayingMovies.RefreshMovies.Response(movies: dummyMovies, error: nil)
            
        // When
        sut.presentRefreshMovies(response: response)
        
        // Then
        wait(for: [spy.displayRefreshMoviesExpectation], timeout: 0.1)
    }
}

extension NowPlayingMoviesPresenterTests {
    
    var dummyMovies: [Movie] {
        return [Movie(identifier: 42, title: "Whiplash"),
                Movie(identifier: 64, title: "Usual Suspects")]
    }
}
