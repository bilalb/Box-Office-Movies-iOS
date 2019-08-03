//
//  MovieDetailsRouterTests.swift
//  Box-Office-MoviesTests
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies
import XCTest

class MovieDetailsRouterTests: XCTestCase {

    var sut: MovieDetailsRouter!
    var movieDetailsViewController: MovieDetailsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: Constants.StoryboardName.main, bundle: Bundle.main)
        guard let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as? MovieDetailsViewController else { return }
        self.movieDetailsViewController = movieDetailsViewController
        let navigationController = UINavigationController(rootViewController: movieDetailsViewController)
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        
        sut = MovieDetailsRouter()
        sut.viewController = movieDetailsViewController
        sut.dataStore = MovieDetailsInteractor()
    }
    
    func testRouteToPoster() {
        // Given
        movieDetailsViewController.loadView()
        
        // When
        sut.routeToPoster()
        
        // Then
        XCTAssertNotNil(sut.viewController?.presentedViewController, "routeToPoster() should present a view controller")
    }
}
