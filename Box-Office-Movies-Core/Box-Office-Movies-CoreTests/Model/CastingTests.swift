//
//  CastingTests.swift
//  Box-Office-Movies-CoreTests
//
//  Created by Bilal Benlarbi on 09/08/2019.
//  Copyright © 2019 Boxotop. All rights reserved.
//

@testable import Box_Office_Movies_Core
import XCTest

class CastingTests: XCTestCase {
    
    func testInit() {
        // Given
        let actors = [Casting.Actor(name: "foo"), Casting.Actor(name: "bar")]
        
        // When
        let casting = Casting(actors: actors)
        
        // Then
        XCTAssertEqual(casting.actors.count, 2)
    }
}

class ActorTests: XCTestCase {
    
    func testInit() {
        // Given
        let name = "foo"
        
        // When
        let actor = Casting.Actor(name: name)
        
        // Then
        XCTAssertEqual(actor.name, "foo")
    }
}
