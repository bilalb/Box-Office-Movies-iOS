//
//  Movie+CoreDataProperties.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 11.06.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation
import CoreData

extension Movie {
    
    @NSManaged public var identifier: Int32
    @NSManaged public var title: String
}
