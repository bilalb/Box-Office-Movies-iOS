//
//  Constants.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyright © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Fallback {
        static let languageCode = "en-US"
        static let regionCode = "US"
        static let thumbnailPosterImageSize = "w185"
        static let largePosterImageSize = "w780"
    }
    
    struct CellIdentifier {
        static let movieTableViewCell = "MovieTableViewCell"
        static let titleTableViewCell = "TitleTableViewCell"
        static let reviewMovieTableViewCell = "ReviewMovieTableViewCell"
        static let synopsisTableViewCell = "SynopsisTableViewCell"
        static let castingTableViewCell =  "CastingTableViewCell"
        static let similarMoviesTableViewCell = "SimilarMoviesTableViewCell"
    }

    struct InfoDictionaryKey {
        static let isReviewEnabled = "IsReviewEnabled"
    }
    
    struct SegueIdentifier {
        static let movieDetails = "MovieDetails"
    }
    
    struct StoryboardName {
        static let main = "Main"
        static let poster = "Poster"
    }
    
    struct NibName {
        static let emptyBackgroundView = "EmptyBackgroundView"
    }
    
    struct VideoURL {
        static let youTube = "https://www.youtube.com/embed/%@"
    }
}
