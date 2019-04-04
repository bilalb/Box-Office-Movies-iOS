//
//  NowPlayingMoviesInteractorTests.swift
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
