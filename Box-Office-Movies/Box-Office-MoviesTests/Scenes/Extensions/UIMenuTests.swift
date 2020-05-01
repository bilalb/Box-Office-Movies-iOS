//
//  UIMenuTests.swift
//  Box-Office-MoviesTests
//
//  Created by Bilal Benlarbi on 01/05/2020.
//  Copyright © 2020 Boxotop. All rights reserved.
//

@testable import Box_Office_Movies
import XCTest

@available(iOS 13.0, *)
class UIMenuTests: XCTestCase {

    func test_search() {
        // When
        let searchMenu = UIMenu.search

        // Then
        XCTAssertEqual(searchMenu.title, "")
        XCTAssertTrue(searchMenu.options.contains(.displayInline))
        XCTAssertEqual(searchMenu.children.count, 1)
        
        XCTAssertEqual(searchMenu.children.first?.title, NSLocalizedString("search", comment: "search"))
        XCTAssertEqual((searchMenu.children.first as? UIKeyCommand)?.action, #selector(AppDelegate.searchMenuAction))
        XCTAssertEqual((searchMenu.children.first as? UIKeyCommand)?.input, "F")
        XCTAssertEqual((searchMenu.children.first as? UIKeyCommand)?.modifierFlags.contains(.command), true)
        XCTAssertEqual((searchMenu.children.first as? UIKeyCommand)?.propertyList as? String, UIKeyCommand.Kind.search.rawValue)
    }

    func test_favorites() {
        // When
        let favoritesMenu = UIMenu.favorites
        
        // Then
        XCTAssertEqual(favoritesMenu.title, NSLocalizedString("favorites", comment: "favorites"))
        XCTAssertEqual(favoritesMenu.children.count, 2)
        
        guard let toggleMovieListTypeCommand = favoritesMenu.children.first as? UIKeyCommand,
            let toggleFavoriteCommand = favoritesMenu.children[safe: 1] as? UIKeyCommand
        else {
            XCTFail("The favorites menu should have two children")
            return
        }
        
        XCTAssertEqual(toggleMovieListTypeCommand.title, NSLocalizedString("showFavorites", comment: "showFavorites"))
        XCTAssertEqual(toggleMovieListTypeCommand.action, #selector(AppDelegate.toggleMovieListTypeMenuAction))
        XCTAssertEqual(toggleMovieListTypeCommand.input, "B")
        XCTAssertTrue(toggleMovieListTypeCommand.modifierFlags.contains(.alternate))
        XCTAssertTrue(toggleMovieListTypeCommand.modifierFlags.contains(.command))
        XCTAssertEqual(toggleMovieListTypeCommand.propertyList as? String, UIKeyCommand.Kind.toggleMovieList.rawValue)
        
        XCTAssertEqual(toggleFavoriteCommand.title, NSLocalizedString("addToFavorites", comment: "addToFavorites"))
        XCTAssertEqual(toggleFavoriteCommand.action, #selector(AppDelegate.toggleFavoriteMenuAction))
        XCTAssertEqual(toggleFavoriteCommand.input, "D")
        XCTAssertTrue(toggleFavoriteCommand.modifierFlags.contains(.command))
        XCTAssertEqual(toggleFavoriteCommand.propertyList as? String, UIKeyCommand.Kind.toggleFavorite.rawValue)
    }

    func test_refreshMovieList() {
        // When
        let refreshMovieListMenu = UIMenu.refreshMovieList
        
        // Then
        XCTAssertEqual(refreshMovieListMenu.title, "")
        XCTAssertTrue(refreshMovieListMenu.options.contains(.displayInline))
        XCTAssertEqual(refreshMovieListMenu.children.count, 1)
        
        XCTAssertEqual(refreshMovieListMenu.children.first?.title, NSLocalizedString("refreshMovieList", comment: "refreshMovieList"))
        XCTAssertEqual((refreshMovieListMenu.children.first as? UIKeyCommand)?.action, #selector(AppDelegate.refreshMovieListMenuAction))
        XCTAssertEqual((refreshMovieListMenu.children.first as? UIKeyCommand)?.input, "R")
        XCTAssertEqual((refreshMovieListMenu.children.first as? UIKeyCommand)?.modifierFlags.contains(.command), true)
        XCTAssertEqual((refreshMovieListMenu.children.first as? UIKeyCommand)?.propertyList as? String, UIKeyCommand.Kind.refreshMovieList.rawValue)
    }
}
