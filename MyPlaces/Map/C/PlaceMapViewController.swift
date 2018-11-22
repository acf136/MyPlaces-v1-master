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

    let manager = PlaceManager.shared
    var locationNew = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPlaceInMap" {
            let apvc = segue.destination as! AddPlaceController
            apvc.previousScreen = self as UIViewController
            apvc.locationNew = self.locationNew
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: nil, action: nil)
        determineMyCurrentLocation()
        mapView.delegate = self     // delegating for "marker" views
        // set initial location at "Plaza Cataluña 1, Barcelona 08001, Spain"
        let initialLocation = CLLocation(latitude: 41.381760, longitude: 2.167330)
        centerMapOnLocation(location: initialLocation)
        showPlacesOnMap()
        
    }
    
    // MKAnnotation basic features
    let regionRadius: CLLocationDistance = 1000 //meters
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius = manager.maxDistBtPlaces * 2
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MKAnnotation management
    func showPlacesOnMap() {
        var position = 0
        while position < manager.count() { //TODO:Until we can introduce GPS coordinates in editing Place
            let place = manager.itemAt(position: position)
            mapView.addAnnotation(place!)
            position += 1
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
}


// Extension for PlaceMapViewController - To set PopUp markers behaviour of our type PlaceMarkerView
extension PlaceMapViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Place else { return nil }
        // 3
        let identifier = "marker"
        var view: PlaceMarkerView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)  as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView as! PlaceMarkerView
        } else {
            // 5
            view = PlaceMarkerView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view as MKMarkerAnnotationView
    }
}


// Override MKMarkerAnnotationView.annotation property to set color depending on place.type
class PlaceMarkerView: MKMarkerAnnotationView {
    let manager = PlaceManager.shared
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let place = newValue as? Place else { return }
            // 2
            markerTintColor = manager.itemTypeColor(place.id)
            glyphText = "\(place.type)"
        }
    }
}
