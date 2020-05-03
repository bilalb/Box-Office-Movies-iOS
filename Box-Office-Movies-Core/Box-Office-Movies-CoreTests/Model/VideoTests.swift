//
//  VideoTests.swift
//  Box-Office-Movies-CoreTests
//
//  Created by Bilal Benlarbi on 09/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

@testable import Box_Office_Movies_Core
import XCTest

final class VideoTests: XCTestCase {
    
    func testInit() {
        // Given
        let key = "foo"
        let site: Video.Site = .youTube
        let type: Video.VideoType = .trailer
        
        // When
        let video = Video(key: key, site: site, type: type)
        
        // Then
        XCTAssertEqual(video.key, "foo")
        XCTAssertEqual(video.site, .youTube)
        XCTAssertEqual(video.type, .trailer)
    }
}
