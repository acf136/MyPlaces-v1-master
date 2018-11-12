//
//  AddPlaceController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class AddPlaceController: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    var place: Place?
    let locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    let manager = PlaceManager.shared
    var tbv : UITableView!
    var pickerData: [PlaceType] = [.generic, .touristic, .services]
    var currenPickerValue : PlaceType = .generic
    
    @IBOutlet weak var locationPlace: UILabel!
    @IBOutlet weak var typeLabelPlace: UILabel!
    @IBOutlet weak var picktypePlace: UIPickerView!
    @IBOutlet weak var nameEditPlace: UITextField!
    @IBOutlet weak var importImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var descrEditPlace: UITextView!
    
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
        //importImageButton.layer.cornerRadius = 10
    }

    // Button Save data to manager of places
    @IBAction func savePlace(_ sender: UIButton) {
        if sender.titleLabel?.text == "Save" {
            place = Place(type: .generic ,name: nameEditPlace.text!, description: descrEditPlace.text! , image_in: nil , www: nil )
            place?.location = locationNew
            place?.type = currenPickerValue
            manager.append(place!)
            tbv.reloadData()
            dismiss(animated: true, completion: nil)
        }
        
    }
}
