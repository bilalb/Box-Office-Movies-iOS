//
//  CoreDataStack.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

class CoreDataStack {
    
    static var shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer: NSPersistentContainer = {
            if #available(iOS 13.0, *) {
                return NSPersistentCloudKitContainer(name: Constants.CoreData.dataModelName, bundle: Bundle(for: ManagerProvider.self))
            } else {
                return NSPersistentContainer(name: Constants.CoreData.dataModelName, bundle: Bundle(for: ManagerProvider.self))
            }
        }()

        persistentContainer.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Loading of the persistent stores failed: \(error), \(error.userInfo)")
        }
        
        return persistentContainer
    }()
}
