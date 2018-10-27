//
//  PlaceCell.swift
//  MyPlaces
//
//  Created by acf136 on 22/10/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // Set data of the place in the cell IBOutlets
    func bind(place: Place?) {
        nameLabel.text = place?.name
        idLabel.text = place?.id
        backgroundImageView.image = place?.image
    }
}
