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
        guard let navigationController = viewControllers.first as? UINavigationController else { return nil }

        return navigationController.viewControllers.first
    }

    /// Returns the details view controller when the child view controllers of the split view controller are navigation controllers.
    var detailViewController: UIViewController? {
        guard viewControllers.indices.contains(1),
            let navigationController = viewControllers[1] as? UINavigationController else { return nil }

        return navigationController.viewControllers.first
    }
}
