//
//  MoviesViewModel.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MoviesViewModelDelegate: class {
    func moviesLoadedSuccessfully()
    func moviesFailedWithError(errorMessage: String)
    func movieImagesLoadedSuccessfully()
    func movieImagesFailedWithError(errorMessage: String)
}

class MoviesViewModel {
    
    // MARK: - Properties
    private var movies: [Movie]?
    private var movieImagesResponse: MovieImagesResponse?
    weak var delegate: MoviesViewModelDelegate?
    
    
    // MARK: - Load data methods
    func loadMovies() {
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let moviesResponse = Mapper<MoviesResponse>().map(JSONObject: jsonResult) {
                    self.movies = moviesResponse.moviesList
                    delegate?.moviesLoadedSuccessfully()
                } else {
                    delegate?.moviesFailedWithError(errorMessage: "ERR700 - Error happened while trying to load movies") // ERR700 for mapping
                }
            } catch {
                delegate?.moviesFailedWithError(errorMessage: "ERR701 - Error happened while trying to load movies") // ERR701 for parsing
            }
        }
    }
    
    func loadMovieImages(movie: Movie) {
        guard let movieTitle = movie.title else { return }
        
        RequestManager.beginRequest(withTargetType: MovieRouter.self, andTarget: MovieRouter.movieFlickrImages(title: movieTitle), responseModel: MovieImagesResponse.self) { [weak self] (data, error) in
            guard let weakSelf = self else { return }
            if error != nil {
                weakSelf.delegate?.movieImagesFailedWithError(errorMessage: error!.errorMessage)
                return
            }
            
            if let response = data as? MovieImagesResponse {
                weakSelf.movieImagesResponse = response
                weakSelf.delegate?.movieImagesLoadedSuccessfully()
            } else {
                weakSelf.delegate?.movieImagesFailedWithError(errorMessage: "ERR701 - Error happened while trying to load movies")  // ERR701 for parsing
            }
        }
    }
    
    // MARK:- Datasource methods
    func numberOfMovies() -> Int {
        return movies?.count ?? 0
    }
    
    func title(at index: Int) -> String? {
        return movies?[index].title
    }
    
    func movie(at index: Int) -> Movie? {
        return movies?[index]
    }
    
    func numberOfMovieImages() -> Int {
        return movieImagesResponse?.photos?.count ?? 0
    }
    
    func movieImage(at index: Int) -> MovieImage? {
        return movieImagesResponse?.photos?[index]
    }
}
