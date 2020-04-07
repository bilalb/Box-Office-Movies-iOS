//
//  Array+Extension.swift
//  Box-Office-Movies
//
//  Created by Bilal on 07/04/2020.
//  Copyright © 2020 Boxotop. All rights reserved.
//

import Foundation

extension Array {

    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
