//
//  DetailViewController.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import TagListView
import Cosmos

class MovieDetailViewController: UIViewController {

    private let kGridCellSize: CGSize = CGSize(width: (UIScreen.main.bounds.width - 41) / 2, height: UIScreen.main.bounds.width)
    
    // MARK: - Outlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var genresTagListView: TagListView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    // MARK: - Properties
    private lazy var moviesViewModel = MoviesViewModel()
    var movie: Movie? {
        didSet {
            configureView()
        }
    }
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    // MARK: - Helpers
    private func loadData() {
        moviesViewModel.delegate = self
        if movie != nil {
            moviesViewModel.loadMovieImages(movie: movie!)
        }
    }
    
    private func configureView() {
        if yearLabel == nil || titleLabel == nil || castLabel == nil || genresTagListView == nil || ratingView == nil {
            return
        }
        
        if let yearInt = movie?.year {
            yearLabel.text = "\(yearInt)"
        }
        titleLabel.text = movie?.title
        castLabel.text = movie?.cast?.joined(separator: ", ")
        genresTagListView.addTags(movie?.genres ?? [])
        ratingView.rating = Double(movie?.rating ?? 0)
        
        loadData()
    }
}


extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesViewModel.numberOfMovieImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieImageCollectionViewCell.cellId, for: indexPath) as? MovieImageCollectionViewCell {
            if let movieImage = moviesViewModel.movieImage(at: indexPath.item) {
                cell.configureCell(movieImage: movieImage)
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return kGridCellSize
    }
}


extension MovieDetailViewController: MoviesViewModelDelegate {
    func moviesLoadedSuccessfully() {
        // Do nothing
    }
    
    func moviesFailedWithError(errorMessage: String) {
        // Do nothing
    }
    
    func movieImagesLoadedSuccessfully() {
        imagesCollectionView.reloadData()
    }
    
    func movieImagesFailedWithError(errorMessage: String) {
        // TODO: Handle error message
    }
}
