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
    let locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
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
        locationPlace.text = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(locationNew.latitude), (locationNew.longitude)])
        typeLabelPlace.text = "Select Type of place"
        //"\(place?.type ?? .generic))"
        nameEditPlace.text = "Enter a name"
        descLabelPlace.text = "Description of place"
        descEditPlace.text = "Enter a description"
        
        saveButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    
    @IBAction func cancelAdd(_ sender: UIButton) {
        if sender.titleLabel?.text == "Cancel" {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func savePlace(_ sender: UIButton) {
        if sender.titleLabel?.text == "Save" {
            place = Place(type: .generic ,name: nameEditPlace.text!, description: descEditPlace.text! , image_in: nil , www: nil )
            place?.location = locationNew
            manager.append(place!)
            tbv.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
    }
}
