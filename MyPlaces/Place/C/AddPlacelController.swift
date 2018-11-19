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

class AddPlaceController: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var place: Place?
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    let manager = PlaceManager.shared
    var tbv : UITableView!
    var pickerData: [PlaceType] = [.generic, .touristic, .services]
    var currenPickerValue : PlaceType = .generic
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var typeLabelPlace: UILabel!
    @IBOutlet weak var picktypePlace: UIPickerView!
    @IBOutlet weak var nameEditPlace: UITextField!
    @IBOutlet weak var importImageButton: UIButton!
    @IBOutlet weak var MyImageView: UIImageView!
    @IBOutlet weak var descrEditPlace: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func editLocation(_ sender: Any) {
        showInputDialogCoordinates(latitude: self.locationNew.latitude, longitude: self.locationNew.longitude)
    }
    
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Place", style: .plain, target: nil, action: nil)
        // Connect data of UIPickerView delegated
        self.picktypePlace.delegate = self
        self.picktypePlace.dataSource = self
        // Initial values to show in the view
        let textLocation = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(locationNew.latitude), (locationNew.longitude)])
        locationButton.setTitle(textLocation, for: .normal)
        typeLabelPlace.text = "Select Type of place"
        picktypePlace.selectRow(0, inComponent: 0, animated: false)
        currenPickerValue = .generic
        nameEditPlace.text = "Enter a name"
        descrEditPlace.text = "Enter a description"
        // post-processing of layout
        saveButton.layer.cornerRadius = 10
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
    
    
    // Button to import custom GPS coordinates
    func showInputDialogCoordinates(latitude: Double, longitude: Double) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter GPS coordinates", message: "-90 < Long. < 270 | -180 < Lat. < 180", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            //getting the input values from user
            let textLongitude = alertController.textFields?[0].text
            let textLatitude = alertController.textFields?[1].text
            
            self.locationNew.latitude = Double(String(describing: textLatitude)) ?? 90
            self.locationNew.longitude = Double(String(describing: textLongitude)) ?? 0
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in textField.placeholder = "\(self.locationNew.latitude)" }
        alertController.addTextField { (textField) in textField.placeholder = "\(self.locationNew.longitude)"  }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
}
