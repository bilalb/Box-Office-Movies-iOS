//
//  PosterViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol PosterDisplayLogic: class {
    func displayPosterImage(viewModel: Poster.LoadPosterImage.ViewModel)
}

class PosterViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: PosterBusinessLogic?
    var router: (NSObjectProtocol & PosterRoutingLogic & PosterDataPassing)?
    
    @IBOutlet var posterImageView: UIImageView?
    
    // MARK: Object Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sceneSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sceneSetup()
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosterImage()
    }
}

// MARK: - Private Functions
private extension PosterViewController {
    
    func loadPosterImage() {
        let request = Poster.LoadPosterImage.Request()
        interactor?.loadPosterImage(request: request)
    }
    
    @IBAction func doneButtonItemPressed() {
        dismiss(animated: true)
    }
    
    @IBAction func swipeDownGestureRecognizerPerformed(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
}

// MARK: - Display Logic
extension PosterViewController: PosterDisplayLogic {
    
    func displayPosterImage(viewModel: Poster.LoadPosterImage.ViewModel) {
        posterImageView?.image = viewModel.posterImage
    }
}
