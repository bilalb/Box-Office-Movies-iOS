//
//  UIView.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Returns with a default string.
    /// Used for example for UITableViewCell subclasses identifiers.
    static var identifier: String {
        return String(describing: self)
    }
    
    /// Returns the view for the given nib name
    ///
    /// - Parameter name: name of the nib
    /// - Returns: the view associated to the nib
    class func fromNib<T: UIView>(named name: String) -> T? {
        return Bundle.main.loadNibNamed(String(describing: name), owner: nil, options: nil)?.first as? T
    }
    
    /// Adds constraints to the view in order to fill its superview.
    ///
    /// - Parameters:
    ///   - padding: The padding for the edges. The default value is `.zero`.
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            return
        }
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: padding.left)
        let rightConstraint = NSLayoutConstraint(item: superview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: padding.right)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: padding.top)
        let bottomConstraint = NSLayoutConstraint(item: superview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: padding.bottom)
        
        superview.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
}
