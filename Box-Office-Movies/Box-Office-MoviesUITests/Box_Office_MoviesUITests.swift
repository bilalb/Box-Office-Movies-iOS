//
//  Box_Office_MoviesUITests.swift
//  Box-Office-MoviesUITests
//
//  Created by Bilal Benlarbi on 29/06/2019.
//  Copyright © 2019 Boxotop. All rights reserved.
//

import XCTest

class Box_Office_MoviesUITests: XCTestCase {

    override func setUp() {
        let application = XCUIApplication()
        setupSnapshot(application)
        application.launch()
    }

    func testScreenshots() {
        snapshot("01MovieList")
        XCUIApplication().cells.firstMatch.tap()
        snapshot("02MovieDetails")
    }
}
