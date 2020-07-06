//
//  MovieRouter.swift
//  ADecadeOfMovies
//
//  Created by Mohammad Shaker on 7/5/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum MovieRouter {
    case movieFlickrImages(title: String)
}

extension MovieRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        case .movieFlickrImages:
            if let url = URL(string: "https://api.flickr.com/services/rest/") {
                return url
            }
            fatalError("Movie Flickr Images Base URL Not Found")
        }
    }
    
    var path: String {
        switch self {
        case .movieFlickrImages:
            return ""
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .movieFlickrImages(let title):
            let params: [String: Any] = ["method": "flickr.photos.search",
                          "api_key": "7f96a09227cc32f1073b0dfe2e245c52",
                          "format": "json",
                          "nojsoncallback": 1,
                          "text": title,
                          "page": 1,
                          "per_page": 10
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: Any?]? {
        return nil
    }
}
