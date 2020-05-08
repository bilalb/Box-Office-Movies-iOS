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
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

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

    var displayType: DisplayType = .message {
        didSet {
            switch displayType {
            case .loading:
                activityIndicatorView.startAnimating()
            case .message:
                activityIndicatorView.stopAnimating()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorView.setStyle(.large)
    }

    @IBAction private func retryButtonPressed() {
        retryButtonAction?()
        activityIndicatorView.startAnimating()
    }
}

extension EmptyBackgroundView {

    enum DisplayType {
        /// Used to display a loader.
        case loading
        /// Used to display a message.
        case message
    }
}
