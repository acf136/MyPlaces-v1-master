//
//  PlaceCell.swift
//  MyPlaces
//
//  Created by acf136 on 22/10/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    //@IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.cornerRadius = 20
        }
    }
    
    // Set data of the place in the cell IBOutlets
    func bind(place: Place?) {
        //idLabel.text = place?.id
        locationLabel.text = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(place?.coordinate.latitude)!, (place?.coordinate.longitude)!] )
        nameLabel.text = place?.locationName
        // Crop image from left-top corner to adapt to table cell bounds
        backgroundImageView.image = place?.image?.cropped(boundingBox : self.bounds )
    }
}
