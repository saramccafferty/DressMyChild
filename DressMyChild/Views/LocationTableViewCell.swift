//
//  LocationTableViewCell.swift
//  DressMyChild
//
//  Created by Sara on 24/2/2023.
//

import UIKit

// define a custom table view cell class
class LocationTableViewCell: UITableViewCell {

    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var weatherIconImage: UIImageView!
    
    // update the cell text with name from Location object
    func update(with location: Location) {
        locationNameLabel.text = location.title
    }
    
}
