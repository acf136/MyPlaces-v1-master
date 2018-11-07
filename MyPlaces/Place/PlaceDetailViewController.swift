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
    @IBOutlet weak var descrOfPlace: UILabel!
    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var locationOfPlace: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = place.name

        idOfPlace.text = place.id
        typeOfPlace.text = "\(place.type)"
        typeOfPlace.textColor = manager.itemTypeColor(place.id) //UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        descrOfPlace.text = place.description
        //descrOfPlace.text = " bla bla lba bla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lbabla bla lba "
        descrOfPlace.sizeToFit()
        
        imageOfPlace.image = place.image
        locationOfPlace.text = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [place.location.latitude, place.location.longitude])
    }

}
