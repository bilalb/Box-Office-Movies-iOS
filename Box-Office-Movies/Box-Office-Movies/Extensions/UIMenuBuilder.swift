//
//  UIMenuBuilder.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 06/12/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension UIMenuBuilder {
    
    func customizeMenu() {
        guard system == .main else { return }
        
        let menusToRemove: [UIMenu.Identifier] = [.file,
                                                  .format,
                                                  .undoRedo,
                                                  .spelling,
                                                  .substitutions,
                                                  .transformations,
                                                  .speech,
                                                  .toolbar,
                                                  .bringAllToFront,
                                                  .help]
        menusToRemove.forEach { menuIdentifier in
            remove(menu: menuIdentifier)
        }
        
        let siblingMenusToInsert: [(UIMenu, UIMenu.Identifier)] = [(.favorites, .view)]
        siblingMenusToInsert.forEach { (siblingMenu, siblingIdentifier) in
            insertSibling(siblingMenu, afterMenu: siblingIdentifier)
        }
        
        let childMenusToInsert: [(UIMenu, UIMenu.Identifier)] = [(.search, .edit),
                                                                 (.refreshMovieList, .view)]
        childMenusToInsert.forEach { (childMenu, parentIdentifier) in
            insertChild(childMenu, atStartOfMenu: parentIdentifier)
        }
    }
}
