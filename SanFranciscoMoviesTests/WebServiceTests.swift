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
        
        //Arrange
        let serviceExpectation = expectation(description: "Get list of movies from server")
        
        //Create URL
        let requestURL = URL(string: "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD")
        
        //Create session
        let session = URLSession.shared
        
        //Setup Task
        let task = session.dataTask(with: requestURL!) { (data, urlResponse, error) in
            
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                XCTAssertNotNil(jsonData)
            }
            catch {
                return
            }
            serviceExpectation.fulfill()
        }
        
        //Act
        task.resume()
        
        //Assert
        XCTAssertNotNil(requestURL)
        XCTAssertNotNil(session)
        waitForExpectations(timeout: 40) { (error) in
            print("\(String(describing: error))")
        }
        
    }
    
    
}
