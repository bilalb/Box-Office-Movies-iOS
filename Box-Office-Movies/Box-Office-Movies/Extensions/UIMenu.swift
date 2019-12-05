//
//  UIMenu.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 06/12/2019.
//  Copyright © 2019 Boxotop. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension UIMenu {

    class var search: UIMenu {
        let command = UIKeyCommand(title: NSLocalizedString("search", comment: "search"),
                                   image: nil,
                                   action: #selector(AppDelegate.searchMenuAction),
                                   input: "F",
                                   modifierFlags: .command,
                                   propertyList: UIKeyCommand.Kind.search.rawValue)

        let menu = UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [command])

        return menu
    }

    class var favorites: UIMenu {
        let toggleMovieListTypeCommand = UIKeyCommand(title: NSLocalizedString("showFavorites", comment: "showFavorites"),
                                                      action: #selector(AppDelegate.toggleMovieListTypeMenuAction),
                                                      input: "B",
                                                      modifierFlags: [.alternate, .command],
                                                      propertyList: UIKeyCommand.Kind.toggleMovieList.rawValue)
        
        let toggleFavoriteCommand = UIKeyCommand(title: NSLocalizedString("addToFavorites", comment: "addToFavorites"),
                                                 action: #selector(AppDelegate.toggleFavoriteMenuAction),
                                                 input: "D",
                                                 modifierFlags: .command,
                                                 propertyList: UIKeyCommand.Kind.toggleFavorite.rawValue)

        let childrenCommands = [toggleMovieListTypeCommand, toggleFavoriteCommand]

        let menu = UIMenu(title: NSLocalizedString("favorites", comment: "favorites"),
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: childrenCommands)
        
        return menu
    }

    class var refreshMovieList: UIMenu {
        let command = UIKeyCommand(title: NSLocalizedString("refreshMovieList", comment: "refreshMovieList"),
                                   image: nil,
                                   action: #selector(AppDelegate.refreshMovieListMenuAction),
                                   input: "R",
                                   modifierFlags: .command,
                                   propertyList: UIKeyCommand.Kind.refreshMovieList.rawValue)

        let menu = UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [command])

        return menu
    }
}

extension UIKeyCommand {
    
    enum Kind: String {
        case search
        case toggleMovieList
        case toggleFavorite
        case refreshMovieList
    }
}
