//
//  NSPersistentContainer.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 14.06.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

extension NSPersistentContainer {
    
    convenience init(name: String, bundle: Bundle) {
        guard
            let managedObjectModelURL = bundle.url(forResource: name, withExtension: Constants.CoreData.managedObjectModelFileExtension),
            let managedObjectModel = NSManagedObjectModel(contentsOf: managedObjectModelURL)
        else {
            fatalError("Unable to locate Core Data model")
        }
        
        self.init(name: name, managedObjectModel: managedObjectModel)
    }
}
