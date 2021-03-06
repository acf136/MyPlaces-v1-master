//
//  AddPlaceController.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation

class AddPlaceController: UIViewController ,  UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Data to comunicate with previous controllers
    var previousScreen : UIViewController!
    var inputPlace : Place! , newPlace : Place!
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    var tbv : UITableView!
    var mpv : MKMapView!
    var pdv : UIView!
    // Own Outlets initialitzation
    var pickerData: [PlaceType] = [.generic, .touristic, .services]
    var currenPickerValue : PlaceType = .generic
    // Data for own management
    let manager = PlaceManager.shared
    var keyboardPresent = false
    // Data to delegate
    // ...

    // Outlets
    //
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var typeLabelPlace: UILabel!
    @IBOutlet weak var picktypePlace: UIPickerView!
    @IBOutlet weak var nameEditPlace: UITextField!
    @IBOutlet weak var importImageButton: UIButton!
    @IBOutlet weak var MyImageView: UIImageView!
    @IBOutlet weak var descrEditPlace: UITextView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    // Actions
    //
    
    // Button DELETE
    @IBAction func deletePlace(_ sender: Any) {
        // SHOW Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you SURE you want to DELETE this?", preferredStyle: .alert)
        // Create OK button with action handler and Cancel w/o
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [self]  (paramAction:UIAlertAction!) in
            print("deletePlace: Ok button tapped")
            if self.pdv != nil {
                let previousVC = self.previousScreen as! PlaceDetailViewController
                let oldId = self.inputPlace.id   // preserve id
                self.manager.remove(self.manager.itemWithId(oldId)!)
                self.manager.writeFileOfPlaces(file: self.manager.nameOfFileJSON())
                previousVC.deletedPlace = true
                self.dismiss(animated: false, completion: nil )
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    //  Button importImageButton to import image into MyImageView
    @IBAction func ImportImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = 	UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
        {   // After it is presented
  
        }
    }
    
    //TODO: Delete Feature of Button locationButton to enter GPS coordinates in a Dialog :
    // Button locationButton to show/edit GPS coordinates
    @IBAction func editLocation(_ sender: Any) {
        showInputDialogCoordinates(latitude: self.locationNew.latitude, longitude: self.locationNew.longitude)
        // Advice to user of not suitable coordinates if more than 10 times the distance from the places
        let myNewCoord = CLLocationCoordinate2D(latitude: self.locationNew.latitude, longitude: self.locationNew.longitude)
        let mySecCoord = manager.itemAt(position: 0)?.coordinate  // TODO: we consider places[0] the center of places, by now
        let actualDistance = myNewCoord.distance(from: mySecCoord!)
        if actualDistance > (manager.maxDistBtPlaces * 10) {
            let alert = UIAlertController(title: "Warning", message: "These coordinates are far from current places. The map range will be expanded and current places will be represented too narrow. Consider to change the coordinates", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

    //
    // Overrided members of UIViewController
    //
    
    // save the data before unwind
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "prepareForUnwind" {
            // if Add from Table or Add from Map
            //      if allRequiredDataIsFilled() -> change data
            if (tbv != nil || mpv != nil) {
                if allRequiredDataIsFilled() {
                    let newId = UUID().uuidString
                    let newPlace = Place(id: newId , type: currenPickerValue ,locationName: nameEditPlace.text!, myDescription: descrEditPlace.text!, coordinate: locationNew, www: nil , image:  MyImageView.image , title : nameEditPlace.text! , discipline: "")
                    manager.append(newPlace)
                    manager.writeFileOfPlaces(file: manager.nameOfFileJSON())
                    if tbv != nil { let previousVC = previousScreen as! PlacesTableViewController ; previousVC.dataChangedOnAdd = true }
                    if mpv != nil { let previousVC = previousScreen as! PlaceMapViewController ; previousVC.dataChangedOnAdd = true }
                }
                // if Edit from Detail
                //      if anyDataChanged  ->  change data
            } else {
                let previousVC = self.previousScreen as! PlaceDetailViewController
                if anyDataChanged() {
                    let newId = inputPlace.id
                    let newPlace = Place(id: newId , type: currenPickerValue ,locationName: nameEditPlace.text!, myDescription: descrEditPlace.text!, coordinate: locationNew, www: nil , image:  MyImageView.image , title : nameEditPlace.text! , discipline: "")
                    manager.modify(properties: [.type, .locationName, .myDescription, .coordinate, .title, .image], Id : newId, placeNew: newPlace)
                    manager.writeFileOfPlaces(file: manager.nameOfFileJSON())
                    previousVC.place = manager.itemWithId(newId)!
                    previousVC.dataChangedOnEdit = true
                }
            }
        }

    }
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial State
        if tbv != nil || mpv != nil {     // Add from Table  or  // Add from Map
            newPlace = Place(id: UUID().uuidString , type: .generic ,locationName: "Enter a name", myDescription: "Enter a description", coordinate: locationNew, www: nil , image:  MyImageView.image , title : "title" , discipline: "")
        } else {                        // Edit from Detail
            newPlace = inputPlace
        }
        // Connect data of UIPickerView delegated
        self.picktypePlace.delegate = self
        self.picktypePlace.dataSource = self
        // Initial values to show in the view
        typeLabelPlace.text = "Select Type of place"
        if tbv != nil  || mpv != nil {     // Add from Table  or  // Add from Map
            locationButton.setTitle(String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(newPlace.coordinate.latitude), (newPlace.coordinate.longitude)]), for: .normal)
            picktypePlace.selectRow(0, inComponent: 0, animated: false)
            currenPickerValue = newPlace.type
            nameEditPlace.text = newPlace.locationName
            descrEditPlace.text = newPlace.myDescription
            // Hide delete button
            deleteButton.image = nil
        } else { // Edit from Detail
            locationButton.setTitle(String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [(inputPlace.coordinate.latitude), (inputPlace.coordinate.longitude)]), for: .normal)
            currenPickerValue = inputPlace.type
            var rowPickerIndex = 0
            for item in pickerData  {
                if item == currenPickerValue { break }
                rowPickerIndex += 1
            }
            picktypePlace.selectRow(rowPickerIndex, inComponent: 0, animated: false)
            MyImageView.image = inputPlace.image
            nameEditPlace.text = inputPlace.locationName
            descrEditPlace.text = inputPlace.myDescription
        }
        // Prevent self.view to be hidden by the keyboard
        keyboardPresent = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // UIImagePicker implementation
    //
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
    // UIPickerView implementation
    //
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
    
    //
    // Public Functions of AddPlaceController
    //
    
    // If kbd is shown Move origin of view up
    @objc func keyboardWillShow(notification: NSNotification) {
        if !keyboardPresent {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                    keyboardPresent = true
                }
            }
        }
    }
    // If kbd is hidden Move origin of view down
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardPresent {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                     keyboardPresent = false
                }
            }
        }
    }
    
    //
    // Private Functions of AddPlaceController
    //
    
    // Check all necessary place data is filled
    private func allRequiredDataIsFilled () -> Bool {
        if nameEditPlace.text == "Enter a name" { return false }
        if descrEditPlace.text == "Enter a description" { return false }
        if MyImageView.image == UIImage(named: "PutYourImageHere") { return false }
        return true
    }
    // Check if any data has changed
    private func anyDataChanged() -> Bool {
        if tbv != nil || mpv != nil {     // Add from Table  or  // Add from Map
            if  currenPickerValue != newPlace.type ||
                newPlace.locationName != nameEditPlace.text || newPlace.myDescription != descrEditPlace.text ||
                newPlace.coordinate.latitude != locationNew.latitude || newPlace.coordinate.longitude != locationNew.longitude ||
                newPlace.image != MyImageView.image
            {   return true }
        } else {                        // Edit from Detail
            if  currenPickerValue != inputPlace.type ||
                inputPlace.locationName != nameEditPlace.text || inputPlace.myDescription != descrEditPlace.text ||
                inputPlace.coordinate.latitude != locationNew.latitude || inputPlace.coordinate.longitude != locationNew.longitude ||
                inputPlace.image != MyImageView.image
            { return true }
            
        }
        return false
    }
    
    // Button to import custom GPS coordinates
    private func showInputDialogCoordinates(latitude: Double, longitude: Double) {
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Enter GPS coordinates", message: "-90 < Lat. < 270 | -180 < Long. < 180", preferredStyle: .alert)
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter",   style: UIAlertAction.Style.default,
           handler:
            { [weak self]
                (paramAction:UIAlertAction!) in
                if let textFields = alertController.textFields {
                    let textLatitude = textFields[0].text
                    let proposedLatitude = Double(textLatitude!) ?? 90
                    let textLongitude = textFields[1].text
                    let proposedLongitude = Double(textLongitude!) ?? 0
                    if  -90 > proposedLatitude || proposedLatitude > 270 || -180 > proposedLongitude || proposedLongitude > 180
                    {
                        let alert = UIAlertController(title: "Error", message: "These coordinates are not in the correct range.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                    else {
                        self?.locationNew.latitude = proposedLatitude
                        self?.locationNew.longitude = proposedLongitude
                        let textLocation = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [proposedLatitude, proposedLongitude])
                        self?.locationButton.setTitle(textLocation, for: .normal)
                        // Advice to user of not suitable coordinates if more than 10 times the distance from the places
                        let myNewCoord = CLLocationCoordinate2D(latitude: proposedLatitude, longitude: proposedLongitude)
                        let mySecCoord = self?.manager.itemAt(position: 0)?.coordinate  // TODO: we consider places[0] the center of places, by now
                        let actualDistance = Double((myNewCoord.distance(from: mySecCoord!)))
                        if actualDistance > ( (self?.manager.maxDistBtPlaces)! * 10 )  {
                            let alert = UIAlertController(title: "Warning", message: "These coordinates are far from current places. The map range will be expanded and current places will be represented too narrow. Consider to change the coordinates", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                            }
                    }
                }
            })
        
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
