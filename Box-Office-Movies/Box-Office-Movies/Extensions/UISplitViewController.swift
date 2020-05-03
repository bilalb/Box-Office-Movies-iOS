//
//  UISplitViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal on 06/04/2020.
//  Copyright © 2020 Boxotop. All rights reserved.
//

import UIKit

extension UISplitViewController {

    /// Returns the master view controller when the child view controllers of the split view controller are navigation controllers.
    var masterViewController: UIViewController? {
        let navigationController = viewControllers.first as? UINavigationController
        return navigationController?.viewControllers.first
    }

    /// Returns the details view controller when the child view controllers of the split view controller are navigation controllers.
    var detailViewController: UIViewController? {
        if isCollapsed {
            let navigationController = viewControllers.first as? UINavigationController
            let detailNavigationController = navigationController?.viewControllers[safe: 1] as? UINavigationController
            return detailNavigationController?.viewControllers.first
        } else {
            let navigationController = viewControllers[safe: 1] as? UINavigationController
            return navigationController?.viewControllers.first
        }
    }
}
