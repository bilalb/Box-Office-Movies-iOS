//
//  MovieDetailsTests.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies_Core
import XCTest

class MovieDetailsTests: XCTestCase {

    var sut: MovieDetails!
    
    override func setUp() {
        super.setUp()
        
        sut = MovieDetails(identifier: 42, title: "Whiplash", releaseDate: "releaseData", voteAverage: 9, synopsis: "foo", posterPath: "bar")
    }

    func testRelatedMovie() {
        // When
        let relatedMovie = sut.relatedMovie
        
        // Then
        XCTAssertEqual(relatedMovie.identifier, 42)
        XCTAssertEqual(relatedMovie.title, "Whiplash")
    }
}
