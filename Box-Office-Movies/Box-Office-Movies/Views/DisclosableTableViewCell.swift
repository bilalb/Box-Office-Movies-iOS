//
//  DisclosableTableViewCell.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 04/04/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol DisclosableTableViewCell {
    func setDisclosureIndicator(_ visible: Bool)
}

extension DisclosableTableViewCell where Self: UITableViewCell {
    
    func setDisclosureIndicator(_ visible: Bool) {
        accessoryType = visible ? .disclosureIndicator : .none
    }
}
