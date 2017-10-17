//
//  MoviesViewModel.swift
//  SanFranciscoMovies
//
//  Created by Kaushil Ruparelia on 10/2/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MoviesViewModel {
    let mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    let moviesWebService = MoviesWebService()
    
    let backgroundQueue = DispatchQueue(label: "CoreDataQueue")
    
    /**
     Initializes the MOC to be used by the view model
     */
    init() {
        //Initialize the ViewModel
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mainManagedObjectContext = appDelegate.persistentContainer.viewContext
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
        
    }
    
    
    /**
     
     Fetches a list of movies from the server, add them to core data and acknowledges success to the caller
     
     */
    func fetchMoviesFromServer(onCompletion: @escaping (_ success: Bool) -> Void) {
        
        //API Call
        moviesWebService.getMovies { (success, data) in
            
            //Check if successful
            if success {
                //Add entries to core data
                
                guard let json = data else {
                    print("No data received")
                    onCompletion(false)
                    return
                }
                
                self.backgroundQueue.async {
                    
                    let didAddToCoreData = self.addDataToCoreData(json)
                    onCompletion(didAddToCoreData)
                }
                return
            }
            
            onCompletion(success)
            
        }
        
        
    }
    
    /**
     
     Adds the data Dictionary to core data
     
     */
    func addDataToCoreData(_ data: Any) -> Bool {
        
        //Check if data is a dictionary
        guard let json = data as? Dictionary<String, Any> else {
            print("Unable to add entries to core data")
            return false
        }
        
        //Check if the data has meta tag
        guard let jsonMeta = json["meta"] as? Dictionary<String, Any> else {
            print("Unable to extract meta")
            return false
        }
        
        //Extract the view from the meta
        guard let metaView = jsonMeta["view"] as? Dictionary<String, Any> else {
            print("Unable to extract meta view")
            return false
        }
        
        //Extract the keys for the data columns
        guard let columns = metaView["columns"] as? Array<Dictionary<String,Any>> else {
            print("Unable to extract columns")
            return false
        }
        
        //Extract names of all columns
        guard let columnNames = (columns.flatMap { $0["fieldName"] }) as? [String] else {
            print("Unable to extract column names")
            return false
        }
        
        
        //Extract the data
        guard let jsonData = json["data"] as? Array<Array<Any>> else {
            print("Unable to extract data")
            return false
        }
        
        guard jsonData.count > 0 else {
            print("No entries found to add to core data")
            return false
        }
        
        guard columnNames.count == jsonData.first!.count else {
            print("Number of columns recieved does not match data entries")
            return false
        }
        
        //Map the meta keys to values and add to core data
        for movie in jsonData {
            if !addMovieToCoreData(columns: columnNames, data: movie) {
                return false
            }
        }
        
        return true
    }
    
    func addMovieToCoreData(columns: Array<String>, data: Array<Any>) -> Bool {
        
        guard let idIndex = columns.index(of: ":id") else {
            print("id not found")
            return false
        }
        
        guard let id = data[idIndex] as? String else {
            print("id type changed")
            return false
        }
        
        guard let titleIndex = columns.index(of: "title") else {
            print("Title not found")
            return false
        }
        
        guard let title = data[titleIndex] as? String else {
            print("Title type changed")
            return false
        }
        
        guard let releaseYearIndex = columns.index(of: "release_year") else {
            print("releaseYear not found")
            return false
        }
        
        guard let releaseYear = data[releaseYearIndex] as? String else {
            print("releaseYear type changed")
            return false
        }
        
        guard let locationsIndex = columns.index(of: "locations") else {
            print("location not found")
            return false
        }
    
        guard let productionCompanyIndex = columns.index(of: "production_company") else {
            print("production_company not found")
            return false
        }
        
        guard let productionCompany = data[productionCompanyIndex] as? String else {
            print("production_company type changed")
            return false
        }

        guard let directorIndex = columns.index(of: "director") else {
            print("director not found")
            return false
        }
        
        guard let writerIndex = columns.index(of: "writer") else {
            print("writer not found")
            return false
        }
        
        guard let actor1Index = columns.index(of: "actor_1") else {
            print("sid not found")
            return false
        }
        
        guard let actor2Index = columns.index(of: "actor_2") else {
            print("actor2 not found")
            return false
        }
        
        
        guard let actor3Index = columns.index(of: "actor_3") else {
            print("actor3 not found")
            return false
        }
        
        if let movie = getMovieEntity(forTitle: title)  {
            if let location = data[locationsIndex] as? String {
                if let locationEntity = getLocationEntity(forName: location) {
                    movie.addToLocation(locationEntity)
                    
                }
            }
        }
        else {
            let movie =
                NSManagedObject(
                    entity: NSEntityDescription.entity(forEntityName: "Movie", in: privateManagedObjectContext)!,
                    insertInto: privateManagedObjectContext)
                    as! Movie
            
            movie.id = id
            movie.productionCompany = getProductionCompanyEntity(forName: productionCompany)
            movie.releaseYear = releaseYear
            movie.title = title.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
            
            if let actor1 = data[actor1Index] as? String {
                movie.actor1 = getActorEntity(forName: actor1)
            }
            
            if let actor2 = data[actor2Index] as? String {
                movie.actor2 = getActorEntity(forName: actor2)
            }
            
            if let actor3 = data[actor3Index] as? String {
                movie.actor3 = getActorEntity(forName: actor3)
            }
            
            if let location = data[locationsIndex] as? String {
                if let locationEntity = getLocationEntity(forName: location) {
                    movie.addToLocation(locationEntity)
                }
            }
            
            if let funFactsIndex = columns.index(of: "fun_facts") {
                if let funFacts = data[funFactsIndex] as? String {
                    movie.funFacts = funFacts
                }
            }
            
            if let director = data[directorIndex] as? String {
                movie.director = getDirectorEntity(forName: director)
            }
            
            
            if let writer = data[writerIndex] as? String {
                movie.writer = getWriterEntity(forName: writer)
            }
            
        }
        
        self.saveContext()
        return true
    }
    
    func getMovieEntity(forTitle title: String) -> Movie? {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title MATCHES[cd] %@",title.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)
    
        return getFirstEntity(fetchRequest: fetchRequest) as? Movie
        
    }
    
    func getActorEntity(forName name: String) -> Actor? {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Actor.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name MATCHES[cd] %@",name)
        
        if let actor = getFirstEntity(fetchRequest: fetchRequest) {
            return actor as? Actor
        }
        else {
            return addActor(name: name)
        }
        
    }
    
    func addActor(name: String) -> Actor {
        let actor = NSManagedObject(
            entity: Actor.entity(),
            insertInto: privateManagedObjectContext)
             as! Actor
        
        actor.name = name
        
        return actor
    }
    
    
    
    func getDirectorEntity(forName name: String) -> Director? {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Director.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name MATCHES[cd] %@",name)
        
        if let actor = getFirstEntity(fetchRequest: fetchRequest) {
            return actor as? Director
        }
        else {
            return addDirector(name: name)
        }
        
    }
    
    func addDirector(name: String) -> Director {
        let director = NSManagedObject(
            entity: Director.entity(),
            insertInto: privateManagedObjectContext)
            as! Director
        
        director.name = name
        
        return director
    }
    
    func getProductionCompanyEntity(forName name: String) -> ProductionCompany? {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = ProductionCompany.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name MATCHES[cd] %@",name)
        
        if let productionCompany = getFirstEntity(fetchRequest: fetchRequest) {
            return productionCompany as? ProductionCompany
        }
        else {
            return addProductionCompany(name: name)
        }
        
    }
    
    func addProductionCompany(name: String) -> ProductionCompany {
        let productionCompany = NSManagedObject(
            entity: ProductionCompany.entity(),
            insertInto: privateManagedObjectContext)
            as! ProductionCompany
        
        productionCompany.name = name
        
        return productionCompany
    }
    
    func getWriterEntity(forName name: String) -> Writer? {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Writer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name MATCHES[cd] %@",name)
        
        if let writer = getFirstEntity(fetchRequest: fetchRequest) {
            return writer as? Writer
        }
        else {
            return addWriter(name: name)
        }
        
    }
    
    func addWriter(name: String) -> Writer {
        let writer = NSManagedObject(
            entity: Writer.entity(),
            insertInto: privateManagedObjectContext)
            as! Writer
        
        writer.name = name
        
        return writer
    }
    
    func getLocationEntity(forName name: String) -> Location? {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name MATCHES[cd] %@",name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)

        if let location = getFirstEntity(fetchRequest: fetchRequest) {
            return location as? Location
        }
        else {
            return addLocation(name: name)
        }

    }
    
    func addLocation(name: String) -> Location {
        let location = NSManagedObject(
            entity: Location.entity(),
            insertInto: privateManagedObjectContext)
            as! Location
        
        location.name = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        return location
    }
    
    func getFirstEntity(fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> NSManagedObject? {
        do {
            let fetchedResults = try privateManagedObjectContext.fetch(fetchRequest)
            
            if let entity = fetchedResults.first {
                return entity as? NSManagedObject
            }
        }
        catch let error as NSError{
            print("Error: \(error)")
        }
        return nil

    }
    
    func saveContext() {
        privateManagedObjectContext.performAndWait {
            do {
                try self.privateManagedObjectContext.save()
                self.mainManagedObjectContext.performAndWait {
                    do {
                        try self.mainManagedObjectContext.save()
                    } catch let error as NSError {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch let error as NSError{
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
