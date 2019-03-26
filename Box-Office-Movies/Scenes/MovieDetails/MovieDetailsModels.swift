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
            let basicItems: [DetailItem]?
        }
    }
    
    enum FetchCasting {
        
        struct Request { }
        
        struct Response {
            let casting: Casting?
        }
        
        struct ViewModel {
            let castingItem: DetailItem
        }
    }
    
    enum FetchSimilarMovies {
        
        struct Request { }
        
        struct Response {
            let paginatedMovieLists: [PaginatedMovieList]?
        }
        
        struct ViewModel {
            let similarMoviesItem: DetailItem
        }
    }
    
        
        }
    }
    
        
        }
    }
}

    
        }
    }
}

}
