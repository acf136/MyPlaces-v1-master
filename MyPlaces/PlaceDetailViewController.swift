//
//  PlaceDetailViewController.swift
//  MyPlaces
//
//  Created by acf136 on 24/10/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {

    var place : Place!
    let manager = PlaceManager.shared
        
    @IBOutlet weak var idOfPlace: UILabel!
    @IBOutlet weak var typeOfPlace: UILabel!
    
    @IBOutlet weak var nameOfPlace: UILabel!
    @IBOutlet weak var descrOfPlace: UILabel!
    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var locationOfPlace: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        idOfPlace.text = place.id
        typeOfPlace.text = "\(place.type)"
        typeOfPlace.textColor = manager.itemTypeColor(place.id) //UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        nameOfPlace.text = place.name
        descrOfPlace.text = place.description
        ///TODO: assign image of place on detail
        imageOfPlace.image = place.image
        let coords : CLLocationCoordinate2D? = place.location
        locationOfPlace.text = "Latitude = \(String(describing: coords?.latitude)) \nLongitude = \(String(describing: coords?.longitude))"
    }

}
