//
//  MoviesTableViewController.swift
//  SanFranciscoMovies
//
//  Created by Kaushil Ruparelia on 10/14/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    let viewModel = MoviesViewModel()
    var fetchedResultsController : NSFetchedResultsController<Movie>!
    let activityIndicator = ActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setFetchResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    // MARK: - Set up
    func setFetchResultsController()  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let fetchRequest : NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptorTitle = NSSortDescriptor(key: "title", ascending: true)
        let sortDescriptorReleaseYear = NSSortDescriptor(key: "releaseYear", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorTitle, sortDescriptorReleaseYear]
        
         fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.persistentContainer.viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    func addActivityIndicator(){
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(activityIndicator)

        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))
        
        activityIndicator.layoutIfNeeded()

    }
    
    @objc func reloadData() {
        do {
            try fetchedResultsController.performFetch()
            
            if fetchedResultsController.fetchedObjects?.count == 0 {
                
                addActivityIndicator()
                
                viewModel.fetchMoviesFromServer { (success) in
                    if success {
                        print("done")
                        DispatchQueue.main.async {
                            do {
                                try self.fetchedResultsController.performFetch()
                                self.tableView.reloadData()
                                self.activityIndicator.removeFromSuperview()
                                
                            }
                            catch let error {
                                print(String(describing: error))
                            }
                        }
                    }
                    else {
                        print("failed")
                    }
                }
            }
        }
        catch let error {
            print(String(describing: error))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
        
        let movie = fetchedResultsController.object(at: indexPath)
        
        cell.populate(withMovie: movie)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = fetchedResultsController.object(at: indexPath)
        
        self.performSegue(withIdentifier: "locationsSegue", sender:movie)
        }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "locationsSegue" {
            
            guard let viewController = segue.destination as? LocationsTableViewController else {
                return
            }
            
            guard let movie = sender as? Movie else { return }
            
            viewController.locations = movie.location?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [Location]
            viewController.title = movie.title?.removingPercentEncoding
            
        }
        
    }

}
