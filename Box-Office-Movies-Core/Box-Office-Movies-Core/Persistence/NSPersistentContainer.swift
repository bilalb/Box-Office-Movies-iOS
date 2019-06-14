//
//  NSPersistentContainer.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 14.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

extension NSPersistentContainer {
    
    public convenience init(name: String, bundle: Bundle) {
        guard
            let modelURL = bundle.url(forResource: name, withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Unable to locate Core Data model")
        }
        
        self.init(name: name, managedObjectModel: mom)
    }
}
