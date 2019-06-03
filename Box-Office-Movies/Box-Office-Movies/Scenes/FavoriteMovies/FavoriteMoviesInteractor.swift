//
//  FavoriteMoviesInteractor.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 27.05.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Box_Office_Movies_Core
import CoreData
import UIKit

protocol FavoriteMoviesDataStore {
}

protocol FavoriteMoviesBusinessLogic {
    func loadFavoriteMovies(request: FavoriteMovies.LoadFavoriteMovies.Request)
    func removeMovieFromFavorites(request: FavoriteMovies.RemoveMovieFromFavorites.Request)
}

class FavoriteMoviesInteractor: FavoriteMoviesDataStore {
    // MARK: Instance Properties
    var presenter: FavoriteMoviesPresentationLogic?
}

extension FavoriteMoviesInteractor: FavoriteMoviesBusinessLogic {
    
    func loadFavoriteMovies(request: FavoriteMovies.LoadFavoriteMovies.Request) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        
        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [FavoriteMovie] {
                let response = FavoriteMovies.LoadFavoriteMovies.Response(favoriteMovies: favoriteMovies)
                presenter?.presentFavoriteMovies(response: response)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func removeMovieFromFavorites(request: FavoriteMovies.RemoveMovieFromFavorites.Request) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        NSBatchDeleteRequest(fetchRequest: <#T##NSFetchRequest<NSFetchRequestResult>#>)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovie")
        
        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [FavoriteMovie] {
                let response = FavoriteMovies.LoadFavoriteMovies.Response(favoriteMovies: favoriteMovies)
                presenter?.presentFavoriteMovies(response: response)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
