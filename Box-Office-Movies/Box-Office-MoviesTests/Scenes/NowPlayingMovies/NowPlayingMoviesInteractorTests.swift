//
//  NowPlayingMoviesInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
import Box_Office_Movies_Core
import XCTest

class NowPlayingMoviesInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: NowPlayingMoviesInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupNowPlayingMoviesInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupNowPlayingMoviesInteractor() {
        sut = NowPlayingMoviesInteractor()
    }
    
    // MARK: Test doubles
    
    class NowPlayingMoviesPresentationLogicSpy: NowPlayingMoviesPresentationLogic {
     
        var presentNowPlayingMoviesExpectation = XCTestExpectation(description: "presentNowPlayingMovies called")
        var presentNextPageExpectation = XCTestExpectation(description: "presentNextPage called")
        var presentFilterMoviesCalled = false
        var presentRefreshMoviesExpectation = XCTestExpectation(description: "presentRefreshMovies called")
        var presentTableViewBackgroundViewCalled = false

        func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
            presentNowPlayingMoviesExpectation.fulfill()
        }
        
        func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response) {
            presentNextPageExpectation.fulfill()
        }
        
        func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
            presentFilterMoviesCalled = true
        }
        
        func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response) {
            presentRefreshMoviesExpectation.fulfill()
        }
        
        func presentRemoveMovieFromFavorites(response: NowPlayingMovies.RemoveMovieFromFavorites.Response) {
            presentFilterMoviesCalled = true
        }
        
        func presentTableViewBackgroundView(response: NowPlayingMovies.LoadTableViewBackgroundView.Response) {
            presentTableViewBackgroundViewCalled = true
        }
    }
    
    // MARK: Tests
    
    func testCurrentMoviesForAllMovies() {
        // Given
        sut.state = .allMovies
        
        // When
        let currentMovies = sut.currentMovies
        
        // Then
        XCTAssertEqual(currentMovies, sut.movies)
    }
    
    func testCurrentMoviesForFavorites() {
        // Given
        sut.state = .favorites
        
        // When
        let currentMovies = sut.currentMovies
        
        // Then
        XCTAssertEqual(currentMovies, sut.favoriteMovies)
    }
    
    func testLoadNowPlayingMoviesWithEmptyMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy

        sut.movies = []
        
        // When
        sut.loadNowPlayingMovies()
        
        wait(for: [spy.presentNowPlayingMoviesExpectation], timeout: 0.1)
    }
    
    func testLoadNowPlayingMoviesWithNotEmptyMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy

        sut.movies = Movie.dummyInstances
        
        // When
        sut.loadNowPlayingMovies()
        
        wait(for: [spy.presentNowPlayingMoviesExpectation], timeout: 0.1)
    }
    
    func testFilterMoviesWithEmptySearchText() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movies = Movie.dummyInstances
        let request = NowPlayingMovies.FilterMovies.Request(searchText: "", isSearchControllerActive: true)
        
        // When
        sut.filterMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.filteredMovies, sut.currentMovies)
        XCTAssertTrue(spy.presentFilterMoviesCalled, "filterMovies(request:) should ask the presenter to format the result")
    }
    
    func testFilterMoviesWithSearchText() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movies = Movie.dummyInstances
        let request = NowPlayingMovies.FilterMovies.Request(searchText: "Wh", isSearchControllerActive: true)
        
        // When
        sut.filterMovies(request: request)
        
        // Then
        XCTAssertTrue(spy.presentFilterMoviesCalled, "filterMovies(request:) should ask the presenter to format the result")
    }
    
    func testRefreshMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        let request = NowPlayingMovies.RefreshMovies.Request()
        
        // When
        sut.refreshMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.state, .allMovies)
    }
    
    func testLoadFavoriteMovies() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        // When
        sut.loadFavoriteMovies()
        
        // Then
        XCTAssertTrue(spy.presentFilterMoviesCalled, "loadFavoriteMovies() should ask the presenter to format the result")
    }
    
    func testLoadFavoriteMoviesWithRequest() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        let request = NowPlayingMovies.LoadFavoriteMovies.Request()
        
        // When
        sut.loadFavoriteMovies(request: request)
        
        // Then
        XCTAssertEqual(sut.state, .favorites)
        XCTAssertTrue(spy.presentFilterMoviesCalled, "loadFavoriteMovies() should ask the presenter to format the result")
    }
    
    func testRemoveMovieFromFavorites() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        _ = ManagerProvider.shared.favoritesManager.addMovieToFavorites(Movie.dummyInstance)
        sut.favoriteMovies = ManagerProvider.shared.favoritesManager.favoriteMovies() ?? []
        
        let request = NowPlayingMovies.RemoveMovieFromFavorites.Request(indexPathForMovieToRemove: IndexPath(row: 0, section: 0))
        
        // When
        sut.removeMovieFromFavorites(request: request)
        
        // Then
        XCTAssertTrue(ManagerProvider.shared.favoritesManager.favoriteMovies()?.isEmpty == true)
        XCTAssertTrue(spy.presentFilterMoviesCalled, "loadFavoriteMovies() should ask the presenter to format the result")
    }
    
    func testLoadTableViewBackgroundView() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        let request = NowPlayingMovies.LoadTableViewBackgroundView.Request(searchText: nil)
        
        // When
        sut.loadTableViewBackgroundView(request: request)
        
        // Then
        XCTAssertTrue(spy.presentTableViewBackgroundViewCalled, "loadTableViewBackgroundView(request:) should ask the presenter to format the result")
    }
}

extension Movie {
    
    static var dummyInstance: Movie {
        return Movie(identifier: 42, title: "Whiplash")
    }
    
    static var dummyInstances: [Movie] {
        return [Movie(identifier: 42, title: "Whiplash"),
                Movie(identifier: 64, title: "Usual Suspects")]
    }
}
