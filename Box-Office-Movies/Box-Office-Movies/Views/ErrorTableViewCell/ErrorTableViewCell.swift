//
//  ErrorTableViewCell.swift
//  Boxotop
//
//  Created by Bilal Benlarbi on 09/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import UIKit

final class ErrorTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!

    var retryButtonAction: (() -> Void)?

    @IBAction private func retryButtonPressed() {
        retryButtonAction?()
    }
}
