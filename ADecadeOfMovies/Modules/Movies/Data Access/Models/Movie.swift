//
//  Movie.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct Movie: Mappable {
    
    var title: String?
    var year: Int?
    var cast: [String]?
    var genres: [String]?
    var rating: Int?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        year <- map["year"]
        cast <- map["cast"]
        genres <- map["genres"]
        rating <- map["rating"]
    }
}
