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

        func presentNowPlayingMovies(response: NowPlayingMovies.FetchNowPlayingMovies.Response) {
            presentNowPlayingMoviesExpectation.fulfill()
        }
        
        func presentNextPage(response: NowPlayingMovies.FetchNextPage.Response) {
            presentNextPageExpectation.fulfill()
        }
        
        func presentFilterMovies(response: NowPlayingMovies.FilterMovies.Response) {
            XCTAssertEqual(response.movies?.count, 1)
            XCTAssertEqual(response.movies?.first?.title, "Whiplash")
            presentFilterMoviesCalled = true
        }
        
        func presentRefreshMovies(response: NowPlayingMovies.RefreshMovies.Response) {
            presentRefreshMoviesExpectation.fulfill()
        }
    }
    
    // MARK: Tests
    
    func testFilterMoviesWithSearchText() {
        // Given
        let spy = NowPlayingMoviesPresentationLogicSpy()
        sut.presenter = spy
        
        sut.movies = dummyMovies
        let request = NowPlayingMovies.FilterMovies.Request(searchText: "Wh", isSearchControllerActive: true)
        
        // When
        sut.filterMovies(request: request)
        
        // Then
        XCTAssertTrue(spy.presentFilterMoviesCalled, "filterMovies(request:) should ask the presenter to format the result")
    }
}

extension NowPlayingMoviesInteractorTests {
    
    var dummyMovies: [Movie] {
        return [Movie(identifier: 42, title: "Whiplash"),
                Movie(identifier: 64, title: "Usual Suspects")]
    }
}
