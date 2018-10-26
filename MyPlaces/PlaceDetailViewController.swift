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
        nameOfPlace.text = place.name
        descrOfPlace.text = place.description
        ///TODO: assign image of place on detail
        //imageOfPlace. = place.image
        let coords : CLLocationCoordinate2D? = place.location
        locationOfPlace.text = "Latitude = \(String(describing: coords?.latitude)) \nLongitude = \(String(describing: coords?.longitude))"
    }

}
