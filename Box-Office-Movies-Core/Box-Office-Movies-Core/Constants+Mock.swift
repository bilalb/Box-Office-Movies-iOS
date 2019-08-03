//
//  Constants+Mock.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 23.07.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Foundation

extension Constants {
    
    struct Mock {
        
        struct NowPlayingMoviesNetworkRequest {
            static let jsonString = """
                                    {
                                        "results": [{
                                            "vote_count": 617,
                                            "id": 420818,
                                            "video": false,
                                            "vote_average": 7.1,
                                            "title": "The Lion King",
                                            "popularity": 581.731,
                                            "poster_path": "/dzBtMocZuJbjLOXvrl4zGYigDzh.jpg",
                                            "original_language": "en",
                                            "original_title": "The Lion King",
                                            "genre_ids": [12, 16, 10751, 18, 28],
                                            "backdrop_path": "/1TUg5pO1VZ4B0Q1amk3OlXvlpXV.jpg",
                                            "adult": false,
                                            "overview": "Simba idolises his father, King Mufasa, and takes to heart his own royal destiny. But not everyone in the kingdom celebrates the new cub's arrival. Scar, Mufasa's brother—and former heir to the throne—has plans of his own. The battle for Pride Rock is ravaged with betrayal, tragedy and drama, ultimately resulting in Simba's exile. With help from a curious pair of newfound friends, Simba will have to figure out how to grow up and take back what is rightfully his.",
                                            "release_date": "2019-07-19"
                                        }, {
                                            "vote_count": 2235,
                                            "id": 429617,
                                            "video": false,
                                            "vote_average": 7.8,
                                            "title": "Spider-Man: Far from Home",
                                            "popularity": 293.777,
                                            "poster_path": "/rjbNpRMoVvqHmhmksbokcyCr7wn.jpg",
                                            "original_language": "en",
                                            "original_title": "Spider-Man: Far from Home",
                                            "genre_ids": [28, 12, 878],
                                            "backdrop_path": "/dihW2yTsvQlust7mSuAqJDtqW7k.jpg",
                                            "adult": false,
                                            "overview": "Peter Parker and his friends go on a summer trip to Europe. However, they will hardly be able to rest - Peter will have to agree to help Nick Fury uncover the mystery of creatures that cause natural disasters and destruction throughout the continent.",
                                            "release_date": "2019-07-02"
                                        }],
                                        "page": 3,
                                        "total_results": 77,
                                        "dates": {
                                            "maximum": "2019-07-21",
                                            "minimum": "2019-06-03"
                                        },
                                        "total_pages": 4
                                    }
                                    """
        }
        
        struct MovieDetailsNetworkRequest {
            static let jsonString = """
                                    {
                                        "adult": false,
                                        "backdrop_path": "/1TUg5pO1VZ4B0Q1amk3OlXvlpXV.jpg",
                                        "belongs_to_collection": null,
                                        "budget": 260000000,
                                        "genres": [{
                                            "id": 12,
                                            "name": "Adventure"
                                        }, {
                                            "id": 16,
                                            "name": "Animation"
                                        }, {
                                            "id": 10751,
                                            "name": "Family"
                                        }, {
                                            "id": 18,
                                            "name": "Drama"
                                        }, {
                                            "id": 28,
                                            "name": "Action"
                                        }],
                                        "homepage": "https://movies.disney.com/the-lion-king-2019",
                                        "id": 420818,
                                        "imdb_id": "tt6105098",
                                        "original_language": "en",
                                        "original_title": "The Lion King",
                                        "overview": "Simba idolises his father, King Mufasa, and takes to heart his own royal destiny. But not everyone in the kingdom celebrates the new cub's arrival. Scar, Mufasa's brother—and former heir to the throne—has plans of his own. The battle for Pride Rock is ravaged with betrayal, tragedy and drama, ultimately resulting in Simba's exile. With help from a curious pair of newfound friends, Simba will have to figure out how to grow up and take back what is rightfully his.",
                                        "popularity": 581.731,
                                        "poster_path": "/dzBtMocZuJbjLOXvrl4zGYigDzh.jpg",
                                        "production_companies": [{
                                            "id": 2,
                                            "logo_path": "/wdrCwmRnLFJhEoH8GSfymY85KHT.png",
                                            "name": "Walt Disney Pictures",
                                            "origin_country": "US"
                                        }, {
                                            "id": 7297,
                                            "logo_path": "/l29JYQVZbTcjZXoz4CUYFpKRmM3.png",
                                            "name": "Fairview Entertainment",
                                            "origin_country": ""
                                        }],
                                        "production_countries": [{
                                            "iso_3166_1": "US",
                                            "name": "United States of America"
                                        }],
                                        "release_date": "2019-07-12",
                                        "revenue": 270520000,
                                        "runtime": 118,
                                        "spoken_languages": [{
                                            "iso_639_1": "en",
                                            "name": "English"
                                        }],
                                        "status": "Released",
                                        "tagline": "The King has Returned.",
                                        "title": "The Lion King",
                                        "video": false,
                                        "vote_average": 7.1,
                                        "vote_count": 618
                                    }
                                    """
        }
        
        struct TheMovieDatabaseAPIConfigurationNetworkRequest {
            static let jsonString = """
                                    {
                                        "images": {
                                            "base_url": "http://image.tmdb.org/t/p/",
                                            "secure_base_url": "https://image.tmdb.org/t/p/",
                                            "backdrop_sizes": ["w300", "w780", "w1280", "original"],
                                            "logo_sizes": ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
                                            "poster_sizes": ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
                                            "profile_sizes": ["w45", "w185", "h632", "original"],
                                            "still_sizes": ["w92", "w185", "w300", "original"]
                                        },
                                        "change_keys": ["adult", "air_date", "also_known_as", "alternative_titles", "biography", "birthday", "budget", "cast", "certifications", "character_names", "created_by", "crew", "deathday", "episode", "episode_number", "episode_run_time", "freebase_id", "freebase_mid", "general", "genres", "guest_stars", "homepage", "images", "imdb_id", "languages", "name", "network", "origin_country", "original_name", "original_title", "overview", "parts", "place_of_birth", "plot_keywords", "production_code", "production_companies", "production_countries", "releases", "revenue", "runtime", "season", "season_number", "season_regular", "spoken_languages", "status", "tagline", "title", "translations", "tvdb_id", "tvrage_id", "type", "video", "videos"]
                                    }
                                    """
        }
        
        struct CastingNetworkRequest {
            static let jsonString = """
                                    {
                                        "id": 420818,
                                        "cast": [{
                                            "cast_id": 1,
                                            "character": "Simba (voice)",
                                            "credit_id": "58a79add9251417ee8000f5d",
                                            "gender": 2,
                                            "id": 119589,
                                            "name": "Donald Glover",
                                            "order": 0,
                                            "profile_path": "/36o5mpbQVdxOf9kUxWw7SllOuk.jpg"
                                        }, {
                                            "cast_id": 19,
                                            "character": "Nala (voice)",
                                            "credit_id": "59fa5b48925141137f001c68",
                                            "gender": 1,
                                            "id": 14386,
                                            "name": "Beyoncé Knowles",
                                            "order": 1,
                                            "profile_path": "/9MgDCYBBVBl4lM1DuxNIIbCHlKy.jpg"
                                        }, {
                                            "cast_id": 2,
                                            "character": "Mufasa (voice)",
                                            "credit_id": "58a7a1719251417ef40014ab",
                                            "gender": 2,
                                            "id": 15152,
                                            "name": "James Earl Jones",
                                            "order": 2,
                                            "profile_path": "/oqMPIsXrl9SZkRfIKN08eFROmH6.jpg"
                                        }]
                                    }
                                    """
        }
        
        struct SimilarMoviesNetworkRequest {
            static let jsonString = """
                                    {
                                        "page": 1,
                                        "results": [{
                                            "adult": false,
                                            "backdrop_path": "/kZ9CKeZeKMUtrjZ7RuArjVMTDF4.jpg",
                                            "genre_ids": [10751, 16, 18],
                                            "id": 8587,
                                            "original_language": "en",
                                            "original_title": "The Lion King",
                                            "overview": "A young lion cub named Simba can't wait to be king. But his uncle craves the title for himself and will stop at nothing to get it.",
                                            "poster_path": "/sKCr78MXSLixwmZ8DyJLrpMsd15.jpg",
                                            "release_date": "1994-05-07",
                                            "title": "The Lion King",
                                            "video": false,
                                            "vote_average": 8.2,
                                            "vote_count": 10431,
                                            "popularity": 56.377
                                        }, {
                                            "adult": false,
                                            "backdrop_path": "/anxiz37Z9FPKeuCsJcxViSWmPxg.jpg",
                                            "genre_ids": [10751, 16, 35],
                                            "id": 10527,
                                            "original_language": "en",
                                            "original_title": "Madagascar: Escape 2 Africa",
                                            "overview": "Alex, Marty, and other zoo animals find a way to escape from Madagascar when the penguins reassemble a wrecked airplane. The precariously repaired craft stays airborne just long enough to make it to the African continent. There the New Yorkers encounter members of their own species for the first time. Africa proves to be a wild place, but Alex and company wonder if it is better than their Central Park home.",
                                            "poster_path": "/9mohxwknsHcwFBSAAhoQXwFV5zn.jpg",
                                            "release_date": "2008-10-30",
                                            "title": "Madagascar: Escape 2 Africa",
                                            "video": false,
                                            "vote_average": 6.4,
                                            "vote_count": 3856,
                                            "popularity": 18.981
                                        }],
                                        "total_pages": 4,
                                        "total_results": 75
                                    }
                                    """
        }
        
        struct PosterNetworkRequest {
            static let jsonString = """
                                    dummy poster data
                                    """
        }
    }
}
