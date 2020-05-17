//
//  UISearchBar.swift
//  Boxotop
//
//  Created by Bilal Benlarbi on 17/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import UIKit

extension UISearchBar {

    func setEnabled(_ enabled: Bool) {
        isUserInteractionEnabled = enabled
        alpha = enabled ? 1 : 0.5
    }
}
