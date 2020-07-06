//
//  MovieImagesResponse.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieImagesResponse: Mappable {
    
    var page: Int?
    var pages: Int?
    var perPage: Int?
    var total: String?
    var photos: [MovieImage]?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        page <- map["photos.page"]
        pages <- map["photos.pages"]
        perPage <- map["photos.perpage"]
        total <- map["photos.total"]
        photos <- map["photos.photo"]
    }
}
