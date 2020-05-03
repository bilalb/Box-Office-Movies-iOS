//
//  PosterModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

enum Poster {
    
    enum LoadSmallSizePosterImage {
        
        struct Request { }
        
        struct Response {
            let smallSizePosterData: Data?
        }
        
        struct ViewModel {
            let smallSizePosterImage: UIImage?
        }
    }
    
    enum FetchPosterImage {
        
        struct Request { }
        
        struct Response {
            let posterData: Data?
            let error: Error?
        }
        
        struct ViewModel {
            let posterImage: UIImage?
        }
    }
}

enum FetchPosterImageError: Error {
    case posterPathNil
}
