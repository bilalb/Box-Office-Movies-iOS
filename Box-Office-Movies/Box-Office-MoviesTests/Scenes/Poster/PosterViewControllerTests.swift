//
//  PosterViewControllerTests.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright (c) 2019 Boxotop. All rights reserved.
//

@testable import Box_Office_Movies
import XCTest

class PosterViewControllerTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: PosterViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupPosterViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPosterViewController() {
        let storyboard = UIStoryboard(name: Constants.StoryboardName.poster, bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: PosterViewController.identifier) as? PosterViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class PosterBusinessLogicSpy: PosterBusinessLogic {
        
        var loadPosterImageCalled = false
        
        func loadPosterImage(request: Poster.LoadPosterImage.Request) {
            loadPosterImageCalled = true
        }
    }
    
    // MARK: Tests
    
    func testInitWithNibNameAndBundle() {
        // When
        let posterViewController = PosterViewController(nibName: nil, bundle: nil)
        
        // Then
        XCTAssertNotNil(posterViewController, "init(nibName:, bundle:) should return an instance of PosterViewController")
    }
    
    func testShouldLoadPosterImageWhenViewIsLoaded() {
        // Given
        let spy = PosterBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.loadPosterImageCalled, "viewDidLoad() should ask the interactor to do loadPosterImage")
    }
    
    func testDisplayPosterImage() {
        // Given
        let viewModel = Poster.LoadPosterImage.ViewModel(posterImage: nil)
        
        // When
        loadView()
        sut.displayPosterImage(viewModel: viewModel)
        
        // Then
        XCTAssertNil(sut.imageView?.image, "displayPosterImage(viewModel:) should update the image")
    }
}
