//
//  PaginatedMovieList.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All right reserved.
//

import Foundation

struct PaginatedMovieList: Codable {
    
    let page: Int
    let totalPages: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
