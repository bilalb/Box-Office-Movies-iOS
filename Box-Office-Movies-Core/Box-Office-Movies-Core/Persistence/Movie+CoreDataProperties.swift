//
//  Movie+CoreDataProperties.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 11.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation
import CoreData

extension Movie {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    
    @NSManaged public var identifier: Int32
    @NSManaged public var title: String
    
}
