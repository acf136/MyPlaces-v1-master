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

    // Data to comunicate with previous controllers
    // ...
    // Data for own management
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    let manager = PlaceManager.shared
    // Data to delegate
    var locationManager:CLLocationManager!
    
    // Overrided members of UITableViewController
    //
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
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
            pdvc.place = place
        }
        if segue.identifier == "AddPlaceInTableSegue" {
            let apnvc = segue.destination as! UINavigationController
            let apvc = apnvc.topViewController as! AddPlaceController
            apvc.tbv = tableView
            apvc.previousScreen = self as UIViewController
            apvc.locationNew = self.locationNew
        }
    }
    
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
