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

    // MARK: - Outlets
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var genresTagListView: TagListView!
    @IBOutlet weak var ratingView: CosmosView!

    // MARK: - Properties
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
    }
}

