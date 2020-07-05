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
}

class MoviesViewModel {
    
    var movies: [Movie]?
    weak var delegate: MoviesViewModelDelegate?
    
    
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
    
    func numberOfMovies() -> Int {
        return movies?.count ?? 0
    }
    
    func title(at index: Int) -> String? {
        return movies?[index].title
    }
}
