//
//  UIActivityIndicatorView.swift
//  Box-Office-Movies
//
//  Created by Bilal on 08/04/2020.
//  Copyright © 2020 Boxotop. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView.Style {

    enum BackwardCompatible {
        case medium
        case large
        
        var priorIOS13Style: UIActivityIndicatorView.Style {
            switch self {
            case .medium:
                return .gray
            case .large:
                return .whiteLarge
            }
        }
        
        @available(iOS 13.0, *)
        var afterIOS13Style: UIActivityIndicatorView.Style {
            switch self {
            case .medium:
                return .medium
            case .large:
                return .large
            }
        }
    }
}

extension UIActivityIndicatorView {

    func setStyle(_ style: Style.BackwardCompatible) {
        if #available(iOS 13.0, *) {
            self.style = style.afterIOS13Style
        } else {
            self.style = style.priorIOS13Style
        }
    }
}
