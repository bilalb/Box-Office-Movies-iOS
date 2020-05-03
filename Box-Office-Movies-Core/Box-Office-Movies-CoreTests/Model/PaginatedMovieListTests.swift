//
//  PaginatedMovieListTests.swift
//  Box-Office-Movies-CoreTests
//
//  Created by Bilal Benlarbi on 09/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies_Core
import XCTest

final class PaginatedMovieListTests: XCTestCase {
    
    func testInit() {
        // Given
        let page = 0
        let totalPages = 2
        let movies = [Movie]()
        
        // When
        let paginatedMovieList = PaginatedMovieList(page: page, totalPages: totalPages, movies: movies)
        
        // Then
        XCTAssertEqual(paginatedMovieList.page, 0)
        XCTAssertEqual(paginatedMovieList.totalPages, 2)
        XCTAssertEqual(paginatedMovieList.movies.count, 0)
    }
}
