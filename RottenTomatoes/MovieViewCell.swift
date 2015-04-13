//
//  MovieViewCell.swift
//  RottenTomatoes
//
//  Created by Pat Boonyarittipong on 4/10/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
