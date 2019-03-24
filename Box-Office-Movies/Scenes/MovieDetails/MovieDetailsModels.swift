//
//  MovieDetailsModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

enum MovieDetailsScene {
    
    enum FetchMovieDetails {
        
        struct Request { }
        
        struct Response {
            let movieDetails: MovieDetails?
        }
        
        struct ViewModel {
            let basicItems: [BasicItem]?
        }
    }
    
    enum FetchCasting {
        
        struct Request { }
        
        struct Response {
            let casting: Casting?
        }
        
        struct ViewModel {
            let castingItem: CastingItem
        }
    }
    
    enum FetchSimilarMovies {
        
        struct Request { }
        
        struct Response {
            let paginatedMovieLists: [PaginatedMovieList]?
        }
        
        struct ViewModel {
            let similarMoviesItem: SimilarMoviesItem
        }
    }
}

extension MovieDetailsScene.FetchMovieDetails.ViewModel {
    
    enum BasicItem: DetailItem {
        case title(value: String)
        case synopsis(value: String?)
        
        var cellIdentifier: String {
            switch self {
            case .title:
                return "TitleTableViewCell"
            case .synopsis:
                return "SynopsisTableViewCell"
            }
        }
    }
}

extension MovieDetailsScene.FetchCasting.ViewModel {
    
    struct CastingItem: DetailItem {
        
        var actors: String?
        
        var cellIdentifier: String {
            return "CastingTableViewCell"
        }
    }
}

extension MovieDetailsScene.FetchSimilarMovies.ViewModel {
    
    struct SimilarMoviesItem: DetailItem {
        
        var similarMovies: String?
        
        var cellIdentifier: String {
            return "SimilarMoviesTableViewCell"
        }
    }
}

protocol DetailItem {
    var cellIdentifier: String { get }
}
