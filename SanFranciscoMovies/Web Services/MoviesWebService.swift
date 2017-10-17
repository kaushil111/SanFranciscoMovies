//
//  MoviesWebService.swift
//  SanFranciscoMovies
//
//  Created by Kaushil Ruparelia on 10/1/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import UIKit

class MoviesWebService {
    func getMovies(onCompletion: @escaping (_ success: Bool,_ jsonData: Any?) -> Void ) {
        
        //Create URL
        guard let requestURL = URL(string: "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD") else {
            print("Error in URL")
            onCompletion(false, nil)
            return
        }
        
        //Create session
        let session = URLSession.shared

        //Setup Task
        let task = session.dataTask(with: requestURL) { (data, urlResponse, error) in
            
            guard let responseData = data  else {
                print("Error in retreiving data")
                onCompletion(false, nil)
                return
            }
            
            if let responseError = error {
                print("Error in response: \(responseError)")
                onCompletion(false, nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                
                onCompletion(true, jsonData)
                return
            }
            catch {
                print("Error in serializing data")
                onCompletion(false, nil)
                return
            }
            
        }
        
        //Start the task
        task.resume()
        
    }
    
    
}
