//
//  MovieImage.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieImage: Mappable {
    
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var isPublic: Bool?
    var isFriend: Bool?
    var isFamily: Bool?
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        owner <- map["owner"]
        secret <- map["secret"]
        server <- map["server"]
        farm <- map["farm"]
        title <- map["title"]
        isPublic <- map["ispublic"]
        isFriend <- map["isfriend"]
        isFamily <- map["isfamily"]
    }
    
    func imageURL() -> String? {
        guard let farm = farm, let server = server, let id = id, let secret = secret else {
            return nil
        }
        return String(format: Constants.FlickrImageURL, farm, server, id, secret)
    }
}
