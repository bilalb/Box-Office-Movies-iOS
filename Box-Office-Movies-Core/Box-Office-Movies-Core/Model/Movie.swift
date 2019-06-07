//
//  Movie.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

/// Movie.
public class Movie: NSManagedObject, Decodable {
    
    // TODO: to rename to Movie.entity().name ?
    static let entityName = String(describing: Movie.self)

    /// Identifier of the movie. For example: `299537`.
    @NSManaged public var identifier: Int
    
    /// Title of the movie. For example: `"Captain Marvel"`.
    @NSManaged public var title: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard
            let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Movie.entityName, in: managedObjectContext)
        else {
            fatalError("Failed to decode Movie")
        }
        self.init(entity: entity, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(Int.self, forKey: .identifier)
        title = try values.decode(String.self, forKey: .title)
    }
}

extension Movie {
    
    convenience init(identifier: Int, title: String) {
        self.init()
        self.identifier = identifier
        self.title = title
    }
}

extension Movie: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(title, forKey: .title)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
