//
//  PosterInteractorTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright (c) 2019 Boxotop. All rights reserved.
//

@testable import Box_Office_Movies
import XCTest

class PosterInteractorTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: PosterInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPosterInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPosterInteractor() {
        sut = PosterInteractor()
    }
    
    // MARK: Test doubles
    
    class PosterPresentationLogicSpy: PosterPresentationLogic {
        
        var presentPosterImageExpectation = XCTestExpectation(description: "presentPosterImage called")
        
        func presentPosterImage(response: Poster.LoadPosterImage.Response) {
            presentPosterImageExpectation.fulfill()
        }
    }
    
    // MARK: Tests
    
    func testLoadPosterImage() {
        // Given
        let spy = PosterPresentationLogicSpy()
        sut.presenter = spy
        
        sut.imageSecureBaseURLPath = "https://image.tmdb.org/t/p/"
        sut.posterPath = ""
        
        let request = Poster.LoadPosterImage.Request()
        
        // When
        sut.loadPosterImage(request: request)
        
        // Then
        wait(for: [spy.presentPosterImageExpectation], timeout: 0.1)
    }
}
