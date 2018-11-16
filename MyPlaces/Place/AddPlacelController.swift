//
//  AddPlaceController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddPlaceController: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    var place: Place?
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    let manager = PlaceManager.shared
    var tbv : UITableView!
    var pickerData: [PlaceType] = [.generic, .touristic, .services]
    var currenPickerValue : PlaceType = .generic
    
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var locationPlace: UILabel!
    @IBOutlet weak var typeLabelPlace: UILabel!
    @IBOutlet weak var picktypePlace: UIPickerView!
    @IBOutlet weak var nameEditPlace: UITextField!
    @IBOutlet weak var importImageButton: UIButton!
    @IBOutlet weak var MyImageView: UIImageView!
    @IBOutlet weak var descrEditPlace: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    // Import Image into MyImageView UIImageView
    @IBAction func ImportImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = 	UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {
            // After it is completed
            
        }
    }
    // called when the user picks image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Assign image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            MyImageView.image = image
        }
        else {
            // Error?
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Number of columns of data picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])"
    }
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        currenPickerValue = pickerData[picktypePlace.selectedRow(inComponent: component)]
    }
    // redraw view
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Place", style: .plain, target: nil, action: nil)
        // Connect data of UIPickerView delegated
        self.picktypePlace.delegate = self
        self.picktypePlace.dataSource = self
        // Initial values to show in the view
        locationPlace.text = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(locationNew.latitude), (locationNew.longitude)])
        typeLabelPlace.text = "Select Type of place"
        picktypePlace.selectRow(0, inComponent: 0, animated: false)
        currenPickerValue = .generic
        nameEditPlace.text = "Enter a name"
        descrEditPlace.text = "Enter a description"
        // post-processing of layout
        saveButton.layer.cornerRadius = 10
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        print("current latitude = \(currentLocation.latitude)")
        self.locationNew.latitude = currentLocation.latitude
        print("current longitude = \(currentLocation.longitude)")
        self.locationNew.longitude = currentLocation.longitude
        
        // Call stopUpdatingLocation() to stop listening for location updates, otherwise this function will be called every time when user location changes.
        // After first call I don't want to listen my location anymore
        manager.stopUpdatingLocation()
    }
    
    // Button Save data to manager of places
    @IBAction func savePlace(_ sender: UIButton) {
        if sender.titleLabel?.text == "Save" {
            place = Place(type: .generic ,locationName: nameEditPlace.text!, myDescription: descrEditPlace.text! , image_in: nil , www: nil )
            place?.coordinate = locationNew
            place?.type = currenPickerValue
            place?.image = MyImageView.image
            manager.append(place!)
            manager.writeFileOfPlaces(file: manager.nameOfFileJSON())
            tbv.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
    }
}
