//
//  WebServiceTests.swift
//  SanFranciscoMoviesTests
//
//  Created by Kaushil Ruparelia on 10/1/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import XCTest
@testable import SanFranciscoMovies

class WebServiceTests: XCTestCase {
    
    var webService = MoviesWebService()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetMovies() {
        
        let serviceExpectation = expectation(description: "Get list of movies from server")
        
        webService.getMovies { (success, responseData) in
            XCTAssertTrue(success, "API Call failed")
            XCTAssertNotNil(responseData, "Response data is nil")
            
            serviceExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            print(error ?? "")
        }
    }
    
    
}
