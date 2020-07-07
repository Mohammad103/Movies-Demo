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
    private var moviesByYear = [Int: [Movie]]()
    private var movieImagesResponse: MovieImagesResponse?
    weak var delegate: MoviesViewModelDelegate?
    
    // MARK: - Properties | Search
    private var searchKeyword: String?
    
    
    // MARK: - Load data methods
    func loadMovies() {
        if let path = Bundle.main.path(forResource: "movies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let moviesResponse = Mapper<MoviesResponse>().map(JSONObject: jsonResult) {
                    self.movies = moviesResponse.moviesList
                    self.structureMoviesByYear()
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
    
    // MARK: - Helpers
    private func structureMoviesByYear(maxItemsPerYear: Int = 5) {
        moviesByYear = [:]
        if searchKeyword == nil {
            return
        }
        
        let moviesSearchList: [Movie] = movies?.filter {
            guard let movieTitle = $0.title else {
                return false
            }
            return movieTitle.contains(searchKeyword!)
        }.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) } ?? []
        
        for movie in moviesSearchList {
            guard let movieYear = movie.year else { continue }
            if moviesByYear[movieYear] == nil {
                moviesByYear[movieYear] = []
            }
            if (moviesByYear[movieYear]?.count ?? 0) < maxItemsPerYear {
                moviesByYear[movieYear]?.append(movie)
            }
        }
    }
    
    func searchMovies(keyword: String?) {
        searchKeyword = keyword
        structureMoviesByYear()
        delegate?.moviesLoadedSuccessfully()
    }
    
    // MARK:- Datasource methods
    private func yearKey(yearIndex: Int) -> Int {
        return moviesByYear.keys.sorted(by: >)[yearIndex]
    }
    
    func numberOfMoviesSections() -> Int {
        if searchKeyword == nil {
            return 1
        }
        return moviesByYear.count
    }
    
    func numberOfMovies(yearIndex: Int) -> Int {
        if searchKeyword == nil {
            return movies?.count ?? 0
        }
        
        let key = yearKey(yearIndex: yearIndex)
        return moviesByYear[key]?.count ?? 0
    }
    
    func yearTitle(at index: Int) -> String? {
        if moviesByYear.keys.count <= index {
            return nil
        }
        let key = yearKey(yearIndex: index)
        return "\(key)"
    }
    
    func title(at index: Int, yearIndex: Int) -> String? {
        if searchKeyword == nil {
            return movies?[index].title
        }
        
        let key = yearKey(yearIndex: yearIndex)
        return moviesByYear[key]?[index].title
    }
    
    func movie(at index: Int, yearIndex: Int) -> Movie? {
        if searchKeyword == nil {
            return movies?[index]
        }
        
        let key = yearKey(yearIndex: yearIndex)
        return moviesByYear[key]?[index]
    }
    
    func numberOfMovieImages() -> Int {
        return movieImagesResponse?.photos?.count ?? 0
    }
    
    func movieImage(at index: Int) -> MovieImage? {
        return movieImagesResponse?.photos?[index]
    }
}
