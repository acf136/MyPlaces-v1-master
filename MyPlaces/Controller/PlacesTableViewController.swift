//
//  PlacesTableViewController.swift
//  MyPlaces
//
//  Created by acf136 on 22/10/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class PlacesTableViewController: UITableViewController, CLLocationManagerDelegate {

    // Data to comunicate with other controllers
    // ...
    // initial status
    var waitingForAddPlace = false
    var waitingForPlaceDetail = false
    var dataChangedOnAdd = false
    var dataChangedOnDetail = false

    // Own Outlets initialitzation
    // ...
    // Data for own management
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    let manager = PlaceManager.shared
    var displayAdvice = false
    // Data to delegate
    var locationManager:CLLocationManager!

    
    // Outlets
    //
    
    // Actions
    //
    
    // Called from PlaceDetailViewController: must exist, even if empty
    @IBAction func unwindFromPlaceDetail(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("PlacesTableViewController: unwindFromPlaceDetail")
        if dataChangedOnDetail { self.tableView.reloadData() }
    }
    
    
    // Called from AddPlaceController: must exist, even if empty
    // Is a func shared with others VControllers that go to AddPlaceController screen
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print("PlacesTableViewController: prepareForUnwind")
        if dataChangedOnAdd {
            self.tableView.reloadData()
        } else {
            displayAdvice = true
        }
    }
    
    // Overrided members of UITableViewController
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if displayAdvice {
            self.adviceNotEnoughData(message: "No all Data supplied to add a place")
        }
    }
    
    // Manage/allow unwind from Add
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        print("PlaceTableViewController: canPerformUnwindSegueAction")
        if action == #selector(PlacesTableViewController.unwindFromPlaceDetail(for:towards:)) {
            waitingForPlaceDetail = false
            return true
        } else {
            if self.waitingForAddPlace {
                self.waitingForAddPlace = false
                return true
            } else {
                return false
            }
        }
    }
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
        // initial status
        waitingForAddPlace = false
        waitingForPlaceDetail = false
        dataChangedOnAdd = false
        dataChangedOnDetail = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell
        let place = manager.itemAt(position: indexPath.item)
        cell.bind(place: place)
        return cell
    }
    
    // Previous to go to other screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlaceSegue" {
            let cell = sender as! PlaceCell
            let index = tableView.indexPath(for: cell)!.row
            let place = manager.itemAt(position: index)
            let pdnvc = segue.destination as! UINavigationController
            let pdvc = pdnvc.topViewController as! PlaceDetailViewController
            pdvc.previousScreen = self as UITableViewController
            pdvc.place = place
            self.waitingForPlaceDetail = true
        }
        if segue.identifier == "AddPlaceInTableSegue" {
            let apnvc = segue.destination as! UINavigationController
            let apvc = apnvc.topViewController as! AddPlaceController
            apvc.tbv = tableView
            apvc.previousScreen = self as UIViewController
            apvc.locationNew = self.locationNew
            self.waitingForAddPlace = true
        }
    }
    
    //
    // Public Functions of PlacesTableViewController
    //
    
    //  alert that nothing has been added/updated
    public func adviceNotEnoughData(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.displayAdvice = false // one time only
    }
    
    //
    // Private Functions of PlacesTableViewController
    //
    
    // Delegated members of CLLocationManagerDelegate
    //
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
}
