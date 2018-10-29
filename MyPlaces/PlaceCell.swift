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
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.cornerRadius = 20
        }
    }
    
    // Set data of the place in the cell IBOutlets
    func bind(place: Place?) {
        nameLabel.text = place?.name
        idLabel.text = place?.id
        // Crop image to adapt to table cell size
        backgroundImageView.image = place?.image?.cropped(boundingBox : CGRect(origin: CGPoint(x:0,y:0) , size: CGSize(width:375,height:150)) )
    }
}
