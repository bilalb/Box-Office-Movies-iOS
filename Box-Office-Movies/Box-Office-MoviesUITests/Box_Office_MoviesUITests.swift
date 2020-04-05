//
//  Box_Office_MoviesUITests.swift
//  Box-Office-MoviesUITests
//
//  Created by Bilal Benlarbi on 29.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import XCTest

class Box_Office_MoviesUITests: XCTestCase {
    
    var locale: Locale = .french
    
    override func setUp() {
        super.setUp()
        let application = XCUIApplication()
        setupSnapshot(application)
        application.launch()
    }

    func testScreenshots() {
        let application = XCUIApplication()
        
        snapshot("01MovieList")
        
        application.searchFields.firstMatch.tap()
        locale.searchKeys.forEach { (key) in
            application.keys[key].tap()
        }
        snapshot("02SearchInput")
        
        application.cells.firstMatch.tap()
        snapshot("03MovieDetails")
        
        let backButton = application.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()
        
        let keyboardSearchButton = application.buttons[locale.keyboardSearchButtonIdentifier]
        keyboardSearchButton.tap()
        
        let cancelSearchButton: XCUIElement = {
            let predicate = NSPredicate(format: "label == %@", locale.cancelSearchButtonLabel)
            return application.buttons.element(matching: predicate)
        }()
        cancelSearchButton.tap()
        
        let favoriteSegmentIndex = 1
        application.segmentedControls.firstMatch.tap(at: favoriteSegmentIndex)
        snapshot("04Favorites")
    }
}

extension Box_Office_MoviesUITests {
    
    enum Locale: String {
        
        case english
        case french
        
        var searchKeys: [String] {
            switch self {
            case .english:
                return ["T", "h"]
            case .french:
                return ["L", "a"]
            }
        }
        
        var keyboardSearchButtonIdentifier: String {
            switch self {
            case .english:
                return "Search"
            case .french:
                return "Rechercher"
            }
        }
        
        var cancelSearchButtonLabel: String {
            switch self {
            case .english:
                return "Cancel"
            case .french:
                return "Annuler"
            }
        }
    }
}

extension XCUIElement {
    
    /// Helper method to tap a UISegmentedControl's segment.
    ///
    /// - Parameter index: The index of segment to tap.
    func tap(at index: Int) {
        guard buttons.count > 0 else {
            return
        }
        let segmentsIndexes = 0 ..< buttons.count
        var segments = segmentsIndexes.map { buttons.element(boundBy: $0) }
        segments.sort { $0.frame.origin.x < $1.frame.origin.x }
        segments[index].tap()
    }
}
