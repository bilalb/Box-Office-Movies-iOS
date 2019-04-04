//
//  Casting.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

public struct Casting: Codable {
    
    public let actors: [Actor]
    
    private enum CodingKeys: String, CodingKey {
        case actors = "cast"
    }
    
    public init(actors: [Actor]) {
        self.actors = actors
    }
}

extension Casting {
    
    public struct Actor: Codable {
        
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
    }
}
