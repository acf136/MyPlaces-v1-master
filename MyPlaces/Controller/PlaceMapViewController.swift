//
//  PlaceMapViewController.swift
//  MyPlaces
//
//  Created by acf136 on 16/11/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class PlaceMapViewController: UIViewController , CLLocationManagerDelegate {

    // Data to comunicate with other controllers
    var waitingForAddPlace = false
    // Own Outlets initialitzation
    // ...
    // Data for own management
    let manager = PlaceManager.shared
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    let regionRadius: CLLocationDistance = 1000 //meters
    // Data to delegate
    var locationManager:CLLocationManager!
    
    
    // Outlets
    //
    @IBOutlet weak var mapView: MKMapView!
    
    // Actions
    //
    
    // Called from AddPlaceController: must exist, even if empty
    // Is a func shared with others VControllers tha go to AddPlaceController screen
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print("PlaceMapViewController: prepareForUnwind")
        self.refreshMap()
    }

    // Overrided members of UIViewController
    //
    
    // Manage/allow unwind from Add
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        print("PlaceMapViewController: canPerformUnwindSegueAction")
        if self.waitingForAddPlace {
            self.waitingForAddPlace = false
            return true
        } else {
            return false
        }
    }
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        // Get fom GPS
        determineMyCurrentLocation()
        super.viewDidLoad()
        mapView.delegate = self     // delegating for "marker" views
        // set initial location at "Plaza Cataluña 1, Barcelona 08001, Spain"
        let initialLocation = CLLocation(latitude: 41.381760, longitude: 2.167330)
        //let initialLocation = CLLocation(latitude: locationNew.latitude, longitude: locationNew.longitude)
        centerMapOnLocation(location: initialLocation)
        showPlacesOnMap()
    }
    
    // Previous to go to other screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPlaceInMapSegue" {
            let apnvc = segue.destination as! UINavigationController
            let apvc = apnvc.topViewController as! AddPlaceController
            apvc.mpv = mapView
            apvc.previousScreen = self as UIViewController
            apvc.locationNew = self.locationNew
            self.waitingForAddPlace = true
        }
    }

    //
    // Public Functions of PlaceMapViewController
    //
    
    // Refresh map, called when unwind
    public func refreshMap() {
        print("Received Notification")
        let initialLocation = CLLocation(latitude: 41.381760, longitude: 2.167330)
        //let initialLocation = CLLocation(latitude: locationNew.latitude, longitude: locationNew.longitude)
        centerMapOnLocation(location: initialLocation)
        showPlacesOnMap()
    }
    
    //
    // Public Functions of PlaceMapViewController
    //
    
    //
    // Private Functions of PlaceMapViewController
    //
    
    // Basic feature to center mapView
    private func centerMapOnLocation(location: CLLocation) {
        let regionRadius = manager.maxDistBtPlaces * 2
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    // Show the places of manager as MKAnnotations in mapView
    private func showPlacesOnMap() {
        var position = 0
        while position < manager.count() { //TODO:Until we can introduce GPS coordinates in editing Place
            let place = manager.itemAt(position: position)
            mapView.addAnnotation(place!)
            position += 1
        }
    }
    
    // Delegated members of CLLocationManagerDelegate
    //
    private func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

