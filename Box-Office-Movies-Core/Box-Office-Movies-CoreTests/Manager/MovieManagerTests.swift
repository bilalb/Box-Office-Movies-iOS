//
//  MovieManagerTests.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 23.07.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies_Core
import XCTest

final class MovieManagerTests: XCTestCase {
    
    var sut: MovieManager!
    
    override func setUp() {
        super.setUp()
        sut = ManagerProvider.shared.movieManager as? MovieManager
    }
    
    func testNowPlayingMovies() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let languageCode = "en-US"
        let regionCode = "US"
        let page = 0
        
        // When
        sut.nowPlayingMovies(languageCode: languageCode, regionCode: regionCode, page: page) { (paginatedMovieList, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(paginatedMovieList)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testMovieDetails() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let identifier = 0
        let languageCode = "en-US"
        let regionCode = "US"
        
        // When
        sut.movieDetails(identifier: identifier, languageCode: languageCode, regionCode: regionCode) { (movieDetails, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(movieDetails)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testTheMovieDatabaseAPIConfiguration() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        // When
        sut.theMovieDatabaseAPIConfiguration { (theMovieDatabaseAPIConfiguration, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(theMovieDatabaseAPIConfiguration)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testPosterData() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let imageSecureBaseURL = "https://image.tmdb.org/t/p/"
        let posterSize = "foo"
        let posterPath = "bar"
        
        // When
        sut.posterData(imageSecureBaseURL: imageSecureBaseURL, posterSize: posterSize, posterPath: posterPath) { (data, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCasting() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let identifier = 0
        
        // When
        sut.casting(identifier: identifier) { (casting, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(casting)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testSimilarMovies() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let identifier = 0
        let languageCode = "en-US"
        let page = 0
        
        // When
        sut.similarMovies(identifier: identifier, languageCode: languageCode, page: page) { (paginatedMovieList, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(paginatedMovieList)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testVideos() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let identifier = 420818
        let languageCode = "en-US"
        
        // When
        sut.videos(identifier: identifier, languageCode: languageCode) { (videos, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(videos)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testVideo() {
        // Given
        let expectation = XCTestExpectation(description: "completion handler called")
        
        let identifier = 420818
        let languageCode = "en-US"
        
        // When
        sut.video(for: .trailer, site: .youTube, identifier: identifier, languageCode: languageCode) { (trailer, error) in
            // Then
            expectation.fulfill()
            XCTAssertNotNil(trailer)
            XCTAssertNil(error)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}
