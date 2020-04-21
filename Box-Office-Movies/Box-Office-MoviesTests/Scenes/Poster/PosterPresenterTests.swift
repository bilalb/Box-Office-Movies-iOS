//
//  PosterPresenterTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright (c) 2019 Boxotop. All rights reserved.
//

@testable import Box_Office_Movies
import XCTest

final class PosterPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: PosterPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPosterPresenter()
    }
    
    // MARK: Test setup
    
    func setupPosterPresenter() {
        sut = PosterPresenter()
    }
    
    // MARK: Test doubles
    
    class PosterDisplayLogicSpy: PosterDisplayLogic {
        
        var displaySmallSizePosterImageCalled = false
        var displayPosterImageExpectation = XCTestExpectation(description: "displayPosterImage called")
        
        func displaySmallSizePosterImage(viewModel: Poster.LoadSmallSizePosterImage.ViewModel) {
            displaySmallSizePosterImageCalled = true
        }
        
        func displayPosterImage(viewModel: Poster.FetchPosterImage.ViewModel) {
            displayPosterImageExpectation.fulfill()
        }
    }
    
    // MARK: Tests
    
    func testPresentSmallSizePosterImage() {
        // Given
        let spy = PosterDisplayLogicSpy()
        sut.viewController = spy
        
        let response = Poster.LoadSmallSizePosterImage.Response(smallSizePosterData: nil)
        
        // When
        sut.presentSmallSizePosterImage(response: response)
        
        // Then
        XCTAssertTrue(spy.displaySmallSizePosterImageCalled, "presentSmallSizePosterImage(response:) should ask the view controller to display the result")
    }
    
    func testPresentPosterImage() {
        // Given
        let spy = PosterDisplayLogicSpy()
        sut.viewController = spy
        
        let response = Poster.FetchPosterImage.Response(posterData: nil, error: nil)
        
        // When
        sut.presentPosterImage(response: response)
        
        // Then
        wait(for: [spy.displayPosterImageExpectation], timeout: 0.1)
    }
}
