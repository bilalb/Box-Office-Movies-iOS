//
//  EmptyBackgroundView.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 29.07.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

/// View used as a table view background view.
final class EmptyBackgroundView: UIView {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    var retryButtonAction: (() -> Void)?

    /// Descriptive text that provides details about the reason for the empty table view. The default value is `nil`.
    var message: String? = nil {
        didSet {
            messageLabel.text = message
        }
    }

    /// Indicates whether the retry button should be displayed or not. The default value is `false`.
    var shouldDisplayRetryButton = false {
        didSet {
            retryButton.isHidden = !shouldDisplayRetryButton
        }
    }

    @IBAction private func retryButtonPressed() {
        retryButtonAction?()
    }
}
