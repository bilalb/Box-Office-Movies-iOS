//
//  String.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension String {
    
    /// Appends separator if needed.
    ///
    /// - Parameters:
    ///   - separator: The separator to be used.
    ///   - other: The string to be appended.
    mutating func append(withSeparator separator: String, other: String) {
        if !isEmpty && !other.isEmpty {
            append(separator)
        }
        append(other)
    }
}
