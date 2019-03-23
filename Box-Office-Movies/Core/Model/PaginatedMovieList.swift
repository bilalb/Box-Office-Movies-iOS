//
//  PaginatedMovieList.swift
//  Box-Office-Movies
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
