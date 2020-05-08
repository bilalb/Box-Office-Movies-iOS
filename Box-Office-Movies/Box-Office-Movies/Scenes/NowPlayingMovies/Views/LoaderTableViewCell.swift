//
//  LoaderTableViewCell.swift
//  Boxotop
//
//  Created by Bilal Benlarbi on 15/05/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import UIKit

final class LoaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicatorView.setStyle(.medium)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.startAnimating()
    }
}
