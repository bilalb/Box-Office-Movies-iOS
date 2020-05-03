//
//  AppDelegate.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 24.03.2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import Firebase
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    private lazy var splitViewController: UISplitViewController? = {
        return window?.rootViewController as? UISplitViewController
    }()
    
    private lazy var nowPlayingMoviesViewController: NowPlayingMoviesViewController? = {
        return splitViewController?.masterViewController as? NowPlayingMoviesViewController
    }()
    
    private var movieDetailsViewController: MovieDetailsViewController? {
        return splitViewController?.detailViewController as? MovieDetailsViewController
    }
}

// MARK: - macOS Menu
#if targetEnvironment(macCatalyst)
extension AppDelegate {

    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        builder.customizeMenu()
    }

    override func validate(_ command: UICommand) {
        super.validate(command)
        guard let propertyList = command.propertyList as? String else { return }
        switch propertyList {
        case UIKeyCommand.Kind.search.rawValue:
            validateSearch(command)
        case UIKeyCommand.Kind.toggleMovieList.rawValue:
            validateToggleMovieList(command)
        case UIKeyCommand.Kind.toggleFavorite.rawValue:
            validateToggleFavorite(command)
        case UIKeyCommand.Kind.refreshMovieList.rawValue:
            validateRefreshMovieList(command)
        default:
            break
        }
    }
}
#endif

// MARK: - Private Methods
@available(iOS 13.0, *)
private extension AppDelegate {
    
    func validateSearch(_ command: UICommand) {
        if nowPlayingMoviesViewController?.searchController.searchBar.searchTextField.isFirstResponder == true {
            command.attributes = .disabled
        }
    }
    
    func validateToggleMovieList(_ command: UICommand) {
        let title: String = {
            switch nowPlayingMoviesViewController?.segmentedControl.selectedSegmentIndex {
            case SegmentedControlSegmentIndex.all.rawValue:
                return NSLocalizedString("showFavorites", comment: "showFavorites")
            case SegmentedControlSegmentIndex.favorites.rawValue:
                return NSLocalizedString("showAllMovies", comment: "showAllMovies")
            default:
                return ""
            }
        }()
        command.title = title
    }
    
    func validateToggleFavorite(_ command: UICommand) {
        let title = movieDetailsViewController?.interactor?.isMovieAddedToFavorites() == true ? NSLocalizedString("removeFromFavorites", comment: "removeFromFavorites") : NSLocalizedString("addToFavorites", comment: "addToFavorites")
        command.title = title
    }
    
    func validateRefreshMovieList(_ command: UICommand) {
        if nowPlayingMoviesViewController?.router?.dataStore?.state == .favorites {
            command.attributes = .disabled
        }
    }
}

// MARK: - Menu Actions
extension AppDelegate {
    
    @objc func searchMenuAction() {
        if #available(iOS 13.0, *) {
            nowPlayingMoviesViewController?.searchController.searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    @objc func toggleMovieListTypeMenuAction() {
        nowPlayingMoviesViewController?.segmentedControl.selectedSegmentIndex = nowPlayingMoviesViewController?.segmentedControl.selectedSegmentIndex == 1 ? 0 : 1
        nowPlayingMoviesViewController?.segmentedControl.sendActions(for: .valueChanged)
    }
    
    @objc func toggleFavoriteMenuAction() {
        movieDetailsViewController?.refreshFavoriteMovies()
    }

    @objc func refreshMovieListMenuAction() {
        nowPlayingMoviesViewController?.refreshNowPlayingMovies()
    }
}
