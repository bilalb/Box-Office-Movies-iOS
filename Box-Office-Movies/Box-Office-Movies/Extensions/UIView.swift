//
//  UIView.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Returns with a default string.
    /// Used for example for UITableViewCell subclasses identifiers.
    static var identifier: String {
        return String(describing: self)
    }
}
