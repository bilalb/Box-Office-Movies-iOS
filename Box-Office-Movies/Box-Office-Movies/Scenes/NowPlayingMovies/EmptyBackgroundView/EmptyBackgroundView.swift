//
//  EmptyBackgroundView.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 29.07.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

class EmptyBackgroundView: UIView {
    
    @IBOutlet var messageLabel: UILabel?
    
    var message: String? = nil {
        didSet {
            messageLabel?.text = message
        }
    }
}
