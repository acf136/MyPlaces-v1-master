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

    let manager = PlaceManager.shared
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation() 
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Places", style: .plain, target: nil, action: nil)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlace" {
            let cell = sender as! PlaceCell
            let index = tableView.indexPath(for: cell)!.row
            let place = manager.itemAt(position: index)
            let pdvc = segue.destination as! PlaceDetailViewController
            pdvc.place = place
        }
        if segue.identifier == "AddPlaceInTable" {
            let apvc = segue.destination as! AddPlaceController
            apvc.tbv = tableView
            apvc.previousScreen = self as UIViewController
            apvc.locationNew = self.locationNew
        }
    }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.locationNew.latitude = currentLocation.latitude
        print("current latitude = \(currentLocation.latitude)")
        self.locationNew.longitude = currentLocation.longitude
        print("current longitude = \(currentLocation.longitude)")
        
        // Call stopUpdatingLocation() to stop listening for location updates, otherwise this function will be called every time when user location changes.
        // After first call I don't want to listen my location anymore
        manager.stopUpdatingLocation()
    }
}
