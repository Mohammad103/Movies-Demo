//
//  MovieImageCollectionViewCell.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/6/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import Kingfisher

class MovieImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let cellId = "MovieImageCollectionViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    // MARK: - Setup
    func configureCell(movieImage: MovieImage) {
        if let urlStr = movieImage.imageURL(), let url = URL(string: urlStr) {
            movieImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
        }
    }
}
