//
//  PosterViewController.swift
//  Box-Office-Movies
//
//  Created by Bilal Benlarbi on 02/08/2019.
//  Copyrights © 2019 Bilal Benlarbi. All rights reserved.
//

import UIKit

protocol PosterDisplayLogic: class {
    func displaySmallSizePosterImage(viewModel: Poster.LoadSmallSizePosterImage.ViewModel)
    func displayPosterImage(viewModel: Poster.FetchPosterImage.ViewModel)
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
        loadSmallSizePosterImage()
        fetchPosterImage()
    }
}

// MARK: - Private Functions
private extension PosterViewController {
    
    func loadSmallSizePosterImage() {
        let request = Poster.LoadSmallSizePosterImage.Request()
        interactor?.loadSmallSizePosterImage(request: request)
    }
    
    func fetchPosterImage() {
        let request = Poster.FetchPosterImage.Request()
        interactor?.fetchPosterImage(request: request)
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
    
    func displaySmallSizePosterImage(viewModel: Poster.LoadSmallSizePosterImage.ViewModel) {
        posterImageView?.image = viewModel.smallSizePosterImage
    }
    
    func displayPosterImage(viewModel: Poster.FetchPosterImage.ViewModel) {
        posterImageView?.image = viewModel.posterImage
    }
}

// MARK: - UIScrollViewDelegate
extension PosterViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }
}
