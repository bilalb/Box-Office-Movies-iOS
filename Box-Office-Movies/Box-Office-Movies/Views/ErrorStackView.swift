//
//  ErrorStackView.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 03.04.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

/// The stack view used to display an error. It contains a label and a button.
class ErrorStackView: UIStackView {
    
    /// The label containing the description of the error.
    @IBOutlet var descriptionLabel: UILabel?
    
    /// The retry button.
    @IBOutlet var retryButton: UIButton?
    
    /// The description of the error.
    var errorDescription: String? {
        didSet {
            descriptionLabel?.text = errorDescription
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
}

private extension ErrorStackView {
    
    func configureView() {
        axis = .vertical
        spacing = 8
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.textAlignment = .center
        retryButton?.setTitle(NSLocalizedString("retry", comment: "retry"), for: .normal)
    }
}
