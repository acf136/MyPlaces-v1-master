//
//  AddPlaceController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class AddPlaceController: UIViewController {
    var place: Place?
    let manager = PlaceManager.shared
    var tbv : UITableView!
    
    @IBOutlet weak var locationPlace: UILabel!
    @IBOutlet weak var typeLabelPlace: UILabel!
    //@IBOutlet weak var picktypePlace: UIPickerView!
    @IBOutlet weak var nameEditPlace: UITextField!
    @IBOutlet weak var descLabelPlace: UILabel!
    @IBOutlet weak var descEditPlace: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        place = Place(type: .generic ,name: "Enter a name", description: "Enter a description", image_in: nil , www: nil )
        place?.location =  CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
        locationPlace.text = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(place?.location.latitude)!, (place?.location.longitude)!])
        typeLabelPlace.text = "Select Type of place"
        //"\(place?.type ?? .generic))"
        nameEditPlace.text = place?.name
        descLabelPlace.text = "Description of place"
        descEditPlace.text = place?.description
        
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    
    @IBAction func savePlace(_ sender: Any) {
        if place != nil { manager.append(place!) }
        tbv.reloadData()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
