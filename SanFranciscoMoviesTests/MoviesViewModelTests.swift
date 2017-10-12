//
//  MoviesViewModelTests.swift
//  SanFranciscoMoviesTests
//
//  Created by Kaushil Ruparelia on 10/6/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import XCTest
import CoreData
@testable import SanFranciscoMovies

class MoviesViewModelTests: XCTestCase {
    
    var moviesModel = MoviesViewModel()
    var persistentStore : NSPersistentStore?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        moviesModel = MoviesViewModel()
        moviesModel.privateManagedObjectContext = setUpInMemoryManagedObjectContext()
        moviesModel.privateManagedObjectContext.parent = moviesModel.mainManagedObjectContext
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        destroyInMemoryPersistentStore()
        
    }
    
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            persistentStore = try appDelegate.persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        return managedObjectContext
    }
    
    func destroyInMemoryPersistentStore()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            try appDelegate.persistentContainer.persistentStoreCoordinator.remove(persistentStore!)
        } catch {
            print("Destroy in-memory persistent store failed")
        }
    }
    
    func testFetchMoviesFromServer() {
        //Assign
        let expect = expectation(description: "Fetching data from server")

        //Act
        moviesModel.fetchMoviesFromServer { (success) in

            //Assert
            if success {
                expect.fulfill()
                return
            }

        }

        waitForExpectations(timeout: 50) { (error) in
            print(error ?? "")
        }

    }

    func testPerformanceForFetchMovies() {
        self.measure {
            //Assign
            let expect = expectation(description: "Fetching data from server")

            //Act
            moviesModel.fetchMoviesFromServer { (success) in

                //Assert
                if success {
                    expect.fulfill()
                    return
                }

            }

            waitForExpectations(timeout: 50) { (error) in
                print(error ?? "")
            }

        }
    }
    
    func testAddDataToCoreData() {
        //Arrange
        
        //Act
        
        //Assert
        
        
    }
    
    func testAddActor() {
        //Arrange
        
        //Act
        let actor = moviesModel.addActor(name: "Test")
        //Assert
        XCTAssertNotNil(actor)
        
    }
    
    func testGetActorEntity() {
        //Arrange
        _ = moviesModel.addActor(name: "Test")
        
        //Act
        let actor = moviesModel.getActorEntity(forName: "Test")
        //Assert
        XCTAssertNotNil(actor)
    }
    
    func testAddDirector() {
        //Arrange
        
        //Act
        let director = moviesModel.addDirector(name: "Test")
        //Assert
        XCTAssertNotNil(director)
    }
    
    func testGetDirectorEntity() {
        //Arrange
        _ = moviesModel.addDirector(name: "Test")
        
        //Act
        let director = moviesModel.getDirectorEntity(forName: "Test")
        //Assert
        XCTAssertNotNil(director)
    }
    
    func testAddWriter() {
        //Arrange
        
        //Act
        let writer = moviesModel.addWriter(name: "Test")
        //Assert
        XCTAssertNotNil(writer)
    }
    
    func testGetWriterEntity() {
        //Arrange
        _ = moviesModel.addWriter(name: "Test")
        
        //Act
        let writer = moviesModel.getWriterEntity(forName: "Test")
        //Assert
        XCTAssertNotNil(writer)
    }
    
    func testAddLocation() {
        //Arrange
        
        //Act
        let location = moviesModel.addLocation(name: "Test")
        //Assert
        XCTAssertNotNil(location)
    }
    
    
    func testGetLocationEntity() {
        //Arrange
        _ = moviesModel.addDirector(name: "Test")
        
        //Act
        let location = moviesModel.getLocationEntity(forName: "Test")
        //Assert
        XCTAssertNotNil(location)
    }
    
    func testAddProductionCompany() {
        //Arrange
        
        //Act
        let productionCompany = moviesModel.addProductionCompany(name: "Test")
        //Assert
        XCTAssertNotNil(productionCompany)
    }
    
    func testGetProductionCompany() {
        //Arrange
        _ = moviesModel.addProductionCompany(name: "Test")
        
        //Act
        let productionCompny = moviesModel.getProductionCompanyEntity(forName: "Test")
        //Assert
        XCTAssertNotNil(productionCompny)
    }
    
}
