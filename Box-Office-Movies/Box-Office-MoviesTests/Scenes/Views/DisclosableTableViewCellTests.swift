//
//  DisclosableTableViewCellTests.swift
//  Box-Office-MoviesTests
//
//  Created by Bilal Benlarbi on 02/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

@testable import Boxotop
import XCTest

class DisclosableTableViewCellTests: XCTestCase {

    // MARK: Subject under test
    
    var sut: DisclosableTableViewCell!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupDisclosableTableViewCell()
    }
    
    // MARK: Test setup
    
    func setupDisclosableTableViewCell() {
        sut = MovieTableViewCell()
    }
    
    // MARK: Tests
    
    func test_setDisclosureIndicator_visible_shouldSetTheDisclosureIndicator() {
        // Given
        let visible = true
        
        // When
        sut.setDisclosureIndicator(visible)
        
        // Then
        guard let sut = sut as? UITableViewCell else {
            XCTFail("sut should be an instance of UITableViewCell")
            return
        }
        XCTAssertEqual(sut.accessoryType, .disclosureIndicator)
    }
    
    func test_setDisclosureIndicator_invisible_shouldSetNoneAccessoryType() {
        // Given
        let visible = false
        
        // When
        sut.setDisclosureIndicator(visible)
        
        // Then
        guard let sut = sut as? UITableViewCell else {
            XCTFail("sut should be an instance of UITableViewCell")
            return
        }
        XCTAssertEqual(sut.accessoryType, .none)
    }
}
