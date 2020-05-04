//
//  Movie+CoreDataClass.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 11.06.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation
import CoreData

/// Movie.
public class Movie: NSManagedObject, Decodable {
   
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard
            let managedObjectContextCodingUserInfoKey = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[managedObjectContextCodingUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Movie.entityName, in: managedObjectContext)
        else {
            fatalError("Failed to decode Movie")
        }

        self.init(entity: entity, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(Int32.self, forKey: .identifier)
        title = try values.decode(String.self, forKey: .title)
    }
}

public extension Movie {
    
    convenience init(identifier: Int32, title: String) {
        self.init(identifier: identifier, title: title, context: CoreDataStack.shared.persistentContainer.viewContext)
    }
}

fileprivate extension Movie {

    convenience init(identifier: Int32, title: String, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: Movie.entityName, in: context) else {
            fatalError("Failed to find the Movie entity")
        }
        
        self.init(entity: entity, insertInto: nil)
        self.title = title
        self.identifier = identifier
    }
}

extension Movie: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(title, forKey: .title)
    }
}

extension Movie {
    
    enum AttributeKeys: String {
        case identifier
        case title
    }
}

extension Movie {

    static let entityName = "Movie"

    class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: entityName)
    }
}
