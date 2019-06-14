//
//  CoreDataAccessController.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

class CoreDataAccessController {
    
    static var shared = CoreDataAccessController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.CoreData.dataModelName, bundle: Bundle(for: ManagerProvider.self))

        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        return container
    }()
}
