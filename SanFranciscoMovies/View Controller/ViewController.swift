//
//  ViewController.swift
//  SanFranciscoMovies
//
//  Created by Kaushil Ruparelia on 10/1/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel.fetchMoviesFromServer { (success) in
            print(success)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

