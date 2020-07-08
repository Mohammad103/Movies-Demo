//
//  MoviesRouterTests.swift
//  ADecadeOfMoviesTests
//
//  Created by Mohammad Shaker on 7/8/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import Foundation

extension MovieRouter {
    var testSampleData: Data {
        switch self {
        case .movieFlickrImages:
            if let path = Bundle(for: NetworkLayerTests.self).path(forResource: "sample-movie-images", ofType: "json") {
                do {
                    return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                } catch {
                }
            }
            return Data()
        }
    }
}
