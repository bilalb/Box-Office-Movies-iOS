//
//  FavoritesDataAccessController.swift
//  Box-Office-Movies-Core
//
//  Created by Bilal Benlarbi on 07.06.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import CoreData
import Foundation

protocol FavoritesDataAccessControlling {
    
    func addMovieToFavorites(_ movie: Movie) -> Bool
    func removeMovieFromFavorites(_ movie: Movie) -> Bool
    func favoriteMovies() -> [Movie]?
}

final class FavoritesDataAccessController: DataAccessController, FavoritesDataAccessControlling {
    
    func addMovieToFavorites(_ movie: Movie) -> Bool {
        let managedContext = persistentContainer.viewContext
        
        var success = false
        
        do {
            if let movieEntity = NSEntityDescription.entity(forEntityName: Movie.entityName, in: managedContext) {
            if let movieEntity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext) {
                let favoriteMovie = NSManagedObject(entity: movieEntity, insertInto: managedContext)
                favoriteMovie.setValue(movie.identifier, forKey: Movie.CodingKeys.identifier.rawValue)
                favoriteMovie.setValue(movie.title, forKey: Movie.CodingKeys.title.rawValue)
                favoriteMovie.setValue(movie.identifier, forKey: "identifier")
                favoriteMovie.setValue(movie.title, forKey: "title")
                
                try managedContext.save()
                success = true
            }
        } catch let error as NSError {
            print("A Core Data error occurred. \(error), \(error.userInfo)")
        }
        
        return success
    }
    
    func removeMovieFromFavorites(_ movie: Movie) -> Bool {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Movie.entityName)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        var success = false

        do {
            if let favoriteMovies = try managedContext.fetch(fetchRequest) as? [Movie],
                let savedFavoriteMovie = favoriteMovies.first(where: { $0.identifier == movie.identifier }) {
                managedContext.delete(savedFavoriteMovie)
                try managedContext.save()
                success = true
            }
        } catch let error as NSError {
            print("A Core Data error occurred. \(error), \(error.userInfo)")
        }
        
        return success
    }
    
    func favoriteMovies() -> [Movie]? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Movie.entityName)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        var favoriteMovies: [Movie]?
        
        do {
            favoriteMovies = try managedContext.fetch(fetchRequest) as? [Movie]
        } catch let error as NSError {
            print("A Core Data error occurred. \(error), \(error.userInfo)")
        }
        
        return favoriteMovies
    }
}
