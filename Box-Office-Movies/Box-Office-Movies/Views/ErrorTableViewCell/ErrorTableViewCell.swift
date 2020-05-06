//
//  ErrorTableViewCell.swift
//  Boxotop
//
//  Created by Bilal on 09/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import UIKit

final class ErrorTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    var retryButtonAction: (() -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.stopAnimating()
    }

    @IBAction private func retryButtonPressed() {
        retryButtonAction?()
        activityIndicatorView.startAnimating()
    }
}
