//
//  PosterInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import XCTest

final class PosterInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: PosterInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPosterInteractor()
    }
    
    // MARK: Test setup
    
    func setupPosterInteractor() {
        sut = PosterInteractor()
    }
    
    // MARK: Test doubles
    
    class PosterPresentationLogicSpy: PosterPresentationLogic {
        
        var presentSmallSizePosterImageCalled = false
        var presentPosterImageExpectation = XCTestExpectation(description: "presentPosterImage called")
        
        func presentSmallSizePosterImage(response: Poster.LoadSmallSizePosterImage.Response) {
            presentSmallSizePosterImageCalled = true
        }
        
        func presentPosterImage(response: Poster.FetchPosterImage.Response) {
            presentPosterImageExpectation.fulfill()
        }
    }
    
    // MARK: Tests
    
    func testPresentSmallSizePosterImage() {
        // Given
        let spy = PosterPresentationLogicSpy()
        sut.presenter = spy
        
        let request = Poster.LoadSmallSizePosterImage.Request()
        
        // When
        sut.loadSmallSizePosterImage(request: request)
        
        // Then
        XCTAssertTrue(spy.presentSmallSizePosterImageCalled, "loadSmallSizePosterImage(request:) should ask the presenter to format the result")
    }
    
    func testFetchPosterImage() {
        // Given
        let spy = PosterPresentationLogicSpy()
        sut.presenter = spy
        
        sut.imageSecureBaseURLPath = "https://image.tmdb.org/t/p/"
        sut.posterPath = ""
        
        let request = Poster.FetchPosterImage.Request()
        
        // When
        sut.fetchPosterImage(request: request)
        
        // Then
        wait(for: [spy.presentPosterImageExpectation], timeout: 0.1)
    }
}
