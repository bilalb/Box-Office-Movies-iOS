//
//  UIApplication.swift
//  Box-Office-Movies
//
//  Created by Bilal on 08/04/2020.
//  Copyright © 2020 Boxotop. All rights reserved.
//

import UIKit

extension UIApplication {

    func setNetworkActivityIndicatorVisibility(_ visibility: Bool) {
        if #available(iOS 13.0, *) { } else {
            isNetworkActivityIndicatorVisible = visibility
        }
    }
}
