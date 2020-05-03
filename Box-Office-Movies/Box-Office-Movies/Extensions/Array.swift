//
//  Array+Extension.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 07/04/2020.
//  Copyright © 2020 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension Array {

    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
