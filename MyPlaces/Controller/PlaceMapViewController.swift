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
    // ...
    // initial status
    var waitingForAddPlace = false
    var dataChangedOnAdd = false
    var deletedPlace = false
    var dataChangedOnObserve = false
    // Own Outlets initialitzation
    // ...
    // Data for own management
    let manager = PlaceManager.shared
    var lastNumberOfPlaces = 0
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
        if dataChangedOnAdd {
            self.refreshMap()
        }
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
    
    // Previous to redraw
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineMyCurrentLocation()
        // if changes on annotations from last didAppear then refresh
        if lastNumberOfPlaces != manager.count() || dataChangedOnObserve {
            self.refreshMap()
            lastNumberOfPlaces = manager.count()
            dataChangedOnObserve = false
            self.setMapObservers()
        }
    }
    
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        // Get fom GPS
        determineMyCurrentLocation()
        super.viewDidLoad()
        mapView.delegate = self     // delegating for "marker" views
        // initial status
        waitingForAddPlace = false
        dataChangedOnAdd = false
        deletedPlace = false
        dataChangedOnObserve = false
        lastNumberOfPlaces = self.manager.count()
        refreshMap()
        // Set observers
        self.setMapObservers()
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
        centerMap()
        showPlacesOnMap()
    }
    
    //
    // Public Functions of PlaceMapViewController
    //

    //
    // Private Functions of PlaceMapViewController
    //
    
    // Set KVO observers for every property defined as KVO in places
    public func setMapObservers() {
        var pos = 0
        while pos < manager.count() {
            manager.setObserver(place: manager.itemAt(position: pos)!, property: .locationName, action: {
                self.dataChangedOnObserve = true } )
            manager.setObserver(place: manager.itemAt(position: pos)!, property: .myDescription, action: {
                self.dataChangedOnObserve = true } )
            manager.setObserver(place: manager.itemAt(position: pos)!, property: .title, action: {
                self.dataChangedOnObserve = true } )
            pos += 1
        }
    }
    
    // Basic feature to center mapView
    private func centerMap() {
        let regionRadius = manager.maxDistBtPlaces * 2
        let center = manager.calcCenterOfPlaces()
        let coordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    // Show the places of manager as MKAnnotations in mapView
    private func showPlacesOnMap() {
        mapView.removeAnnotations(self.mapView.annotations)
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

