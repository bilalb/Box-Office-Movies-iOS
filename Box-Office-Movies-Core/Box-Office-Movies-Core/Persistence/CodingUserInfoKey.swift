//
//  CodingUserInfoKey.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 12.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension CodingUserInfoKey {
    
    /// Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
