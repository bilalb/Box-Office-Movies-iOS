//
//  EmptyBackgroundView.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 29.07.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

/// View used as a table view background view when a table view is empty.
final class EmptyBackgroundView: UIView {
    
    @IBOutlet var messageLabel: UILabel?
    
    /// Descriptive text that provides details about the reason for the empty table view.
    var message: String? = nil {
        didSet {
            messageLabel?.text = message
        }
    }
}
