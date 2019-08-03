//
//  PosterPresenterTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright (c) 2019 Boxotop. All rights reserved.
//

@testable import Box_Office_Movies
import XCTest

class PosterPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: PosterPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPosterPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPosterPresenter() {
        sut = PosterPresenter()
    }
    
    // MARK: Test doubles
    
    class PosterDisplayLogicSpy: PosterDisplayLogic {
        
        var displayPosterImageExpectation = XCTestExpectation(description: "displayPosterImage called")
        
        func displayPosterImage(viewModel: Poster.LoadPosterImage.ViewModel) {
            displayPosterImageExpectation.fulfill()
        }
    }
    
    // MARK: Tests
    
    func testPresentPosterImage() {
        // Given
        let spy = PosterDisplayLogicSpy()
        sut.viewController = spy
        let response = Poster.LoadPosterImage.Response(posterData: nil)
        
        // When
        sut.presentPosterImage(response: response)
        
        // Then
        wait(for: [spy.displayPosterImageExpectation], timeout: 0.1)
    }
}
