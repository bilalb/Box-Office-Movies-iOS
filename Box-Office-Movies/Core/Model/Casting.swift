//
//  Casting.swift
//  Box-Office-Movies
//

import Foundation

struct Casting: Codable {
    
    let actors: [Actor]
    
    private enum CodingKeys: String, CodingKey {
        case actors = "cast"
    }
}

extension Casting {
    
    struct Actor: Codable {
        
        let name: String
    }
}
