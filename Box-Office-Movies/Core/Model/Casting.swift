//
//  Casting.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
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
