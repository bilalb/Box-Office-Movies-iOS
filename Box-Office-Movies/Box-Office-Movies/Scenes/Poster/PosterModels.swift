//
//  PosterModels.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
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
        }
        
        struct ViewModel {
            let posterImage: UIImage?
        }
    }
}
