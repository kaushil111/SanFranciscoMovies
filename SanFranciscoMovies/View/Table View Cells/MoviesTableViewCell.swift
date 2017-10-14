//
//  MoviesTableViewCell.swift
//  SanFranciscoMovies
//
//  Created by Kaushil Ruparelia on 10/14/17.
//  Copyright © 2017 Kaushil Ruparelia. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var actor1Label: UILabel!
    @IBOutlet weak var actor2Label: UILabel!
    @IBOutlet weak var actor3Label: UILabel!
    
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var productionCompanyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        actor1Label.text = ""
        actor2Label.text = ""
        actor3Label.text = ""
        releaseYearLabel.text = ""
        directorLabel.text = ""
        productionCompanyLabel.text = ""
        
    }
    
    func populate(withMovie movie: Movie) {
        
        titleLabel.text = movie.title ?? ""
        
        actor1Label.text = movie.actor1?.name ?? ""
        actor2Label.text = movie.actor2?.name ?? ""
        actor3Label.text = movie.actor3?.name ?? ""
        
        releaseYearLabel.text = movie.releaseYear ?? ""
        directorLabel.text = movie.director?.name ?? ""
        productionCompanyLabel.text = movie.productionCompany?.name ?? ""
        
    }
}
