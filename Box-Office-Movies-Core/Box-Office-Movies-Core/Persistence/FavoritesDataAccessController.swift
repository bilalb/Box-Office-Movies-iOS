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

final class FavoritesDataAccessController: FavoritesDataAccessControlling {

    func addMovieToFavorites(_ movie: Movie) -> Bool {
        guard let entityName = Movie.entity().name else {
            return false
        }
        
        let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
        
        var success = false
        
        if let movieEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) {
            let favoriteMovie = NSManagedObject(entity: movieEntity, insertInto: managedObjectContext)
            favoriteMovie.setValue(movie.identifier, forKey: Movie.AttributeKeys.identifier.rawValue)
            favoriteMovie.setValue(movie.title, forKey: Movie.AttributeKeys.title.rawValue)
            
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    success = true
                } catch let error as NSError {
                    print("Failed to save Core Data context. \(error), \(error.userInfo)")
                }
            }
        }
        
        return success
    }
    
    func removeMovieFromFavorites(_ movie: Movie) -> Bool {
        guard let entityName = Movie.entity().name else {
            return false
        }
        
        let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext

        // TODO: make use of the fetch request UI from Box-Office-Movies-Core.xcdatamodel ?
        let fetchRequest = NSFetchRequest<Movie>(entityName: entityName)
        
        var success = false
        
        do {
            let favoriteMovies = try managedObjectContext.fetch(fetchRequest)
            if let savedFavoriteMovie = favoriteMovies.first(where: { $0.identifier == movie.identifier }) {
                managedObjectContext.delete(savedFavoriteMovie)
                
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                    success = true
                }
            }
        } catch let error as NSError {
            print("A Core Data error occurred. \(error), \(error.userInfo)")
        }
        
        return success
    }
    
    func favoriteMovies() -> [Movie]? {
        guard let entityName = Movie.entity().name else {
            return nil
        }
        
        let managedObjectContext = CoreDataStack.shared.persistentContainer.viewContext

        // TODO: make use of the fetch request UI from Box-Office-Movies-Core.xcdatamodel ?
        let fetchRequest = NSFetchRequest<Movie>(entityName: entityName)
        
        var favoriteMovies: [Movie]?
        
        do {
            favoriteMovies = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Failed to fetch movies. \(error), \(error.userInfo)")
        }
        
        return favoriteMovies
    }
}