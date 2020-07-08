//
//  NetworkLayerTests.swift
//  ADecadeOfMoviesTests
//
//  Created by Mohammad Shaker on 7/8/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import XCTest
import Moya
import ObjectMapper

class NetworkLayerTests: XCTestCase {

    var moviesProvider: MoyaProvider<MovieRouter>!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadMovieImages() throws {
        moviesProvider = MoyaProvider<MovieRouter>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        moviesProvider.request(.movieFlickrImages(title: "Superman")) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    if let movieImagesResponse = ParsingHandler.parseObject(responseData: response.data, toModel: MovieImagesResponse.self) {
                        XCTAssertEqual(movieImagesResponse.photos?.count, 10)
                        XCTAssertEqual(movieImagesResponse.photos?[0].imageURL(), "https://farm66.static.flickr.com/65535/50088736853_b3e1bed421.jpg")
                    } else {
                        XCTAssert(false)
                    }
                } else {
                    XCTAssert(false)
                }
                
            case .failure(_):
                XCTAssert(false)
            }
        }
    }

}


// MARK: - Helper methods
extension NetworkLayerTests {
    private func customEndpointClosure(_ target: MovieRouter) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}
