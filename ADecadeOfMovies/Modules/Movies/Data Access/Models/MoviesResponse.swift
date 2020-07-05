//
//  MoviesResponse.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct MoviesResponse: Mappable {
    
    var moviesList: [Movie]?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        moviesList <- map["movies"]
    }
}
