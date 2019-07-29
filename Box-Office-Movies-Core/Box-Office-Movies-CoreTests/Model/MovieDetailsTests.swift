//
//  MovieDetailsTests.swift
//  Box-Office-Movies-Core
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
