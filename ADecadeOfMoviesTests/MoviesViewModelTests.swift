//
//  MoviesViewModelTests.swift
//  ADecadeOfMoviesTests
//
//  Created by Mohammad Shaker on 7/8/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import XCTest

class MoviesViewModelTests: XCTestCase {

    private lazy var viewModel = MoviesViewModel()
    private var searchInProgress: String?
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel.delegate = self
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadMoviesLocally() throws {
        searchInProgress = nil
        viewModel.loadMovies()
    }
    
    private func searchByKeyword(keyword: String) {
        searchInProgress = keyword
        viewModel.searchMovies(keyword: searchInProgress)
    }
    
    func testSearch17AgainMovie() throws {
        try testLoadMoviesLocally()
        searchByKeyword(keyword: "17 Again")
    }
    
    func testSearch17AgainSmallLettersMovie() throws {
        try testLoadMoviesLocally()
        searchByKeyword(keyword: "17 again")
    }
    
    func testSearch2012Movie() throws {
        try testLoadMoviesLocally()
        searchByKeyword(keyword: "2012")
    }
    
    func testSearchSpidermanMovie() throws {
        try testLoadMoviesLocally()
        searchByKeyword(keyword: "Spiderman")
    }
    
    func testSearchDayMovie() throws {
        try testLoadMoviesLocally()
        searchByKeyword(keyword: "day")
    }

}


// MARK: - Performance Tests
extension MoviesViewModelTests {
    func testLoadMoviesLocallyPerformanceExample() {
        viewModel = MoviesViewModel()
        viewModel.delegate = self
        measure {
            viewModel.loadMovies()
        }
    }
    
    func testSearchMoviesPerformanceExample() {
        viewModel = MoviesViewModel()
        viewModel.delegate = self
        viewModel.loadMovies()
        measure {
            searchByKeyword(keyword: "a")
        }
    }
}


// MARK: - MoviesViewModel Delegate Methods
extension MoviesViewModelTests: MoviesViewModelDelegate {
    func moviesLoadedSuccessfully() {
        if searchInProgress == nil {
            XCTAssertEqual(viewModel.numberOfMoviesSections(), 1)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 0), 2272)
        } else if searchInProgress == "17 Again" {
            XCTAssertEqual(viewModel.numberOfMoviesSections(), 1)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 0), 1)
        } else if searchInProgress == "17 again" {
            XCTAssertEqual(viewModel.numberOfMoviesSections(), 1)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 0), 1)
        } else if searchInProgress == "2012" {
            XCTAssertEqual(viewModel.numberOfMoviesSections(), 2)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 0), 1)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 1), 1)
        } else if searchInProgress == "Spiderman" {
            XCTAssertEqual(viewModel.numberOfMoviesSections(), 0)
        }  else if searchInProgress == "day" {
            XCTAssertEqual(viewModel.numberOfMoviesSections(), 9)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 0), 4)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 1), 1)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 2), 2)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 3), 5)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 4), 2)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 5), 5)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 6), 3)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 7), 5)
            XCTAssertEqual(viewModel.numberOfMovies(yearIndex: 8), 5)
        }
    }
    
    func moviesFailedWithError(errorMessage: String) {
        XCTAssert(false, errorMessage)
    }
    
    func movieImagesLoadedSuccessfully() {
        
    }
    
    func movieImagesFailedWithError(errorMessage: String) {
        XCTAssert(false, errorMessage)
    }
}
