//
//  DataAccessController.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

class DataAccessController {
    
    // TODO: to remove ?
    static var shared = DataAccessController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        // TODO: rename "Box-Office-Movies-Core-Movie" to "Box-Office-Movies-Core"
        let container = NSPersistentContainer(name: "Box-Office-Movies-Core-Movie", bundle: Bundle(for: ManagerProvider.self))

        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        return container
    }()
}

extension NSPersistentContainer {
    
    public convenience init(name: String, bundle: Bundle) {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Not able to find data model")
        }
        
        self.init(name: name, managedObjectModel: managedObjectModel)
    }
}
