//
//  OwnViewController_extensions.swift
//  MyPlaces
//
//  Created by acf136 on 23/11/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension PlacesTableViewController  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.locationNew.latitude = currentLocation.latitude
        print("PlacesTableViewController : current latitude = \(currentLocation.latitude)")
        self.locationNew.longitude = currentLocation.longitude
        print("PlacesTableViewController : current longitude = \(currentLocation.longitude)")
        
        // Call stopUpdatingLocation() to stop listening for location updates, otherwise this function will be called every time when user location changes.
        // After first call I don't want to listen my location anymore
        manager.stopUpdatingLocation()
    }
}

// Extension for PlaceMapViewController - To get GPS coordinates through CLLocationManager class
extension PlaceMapViewController  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.locationNew.latitude = currentLocation.latitude
        print("PlaceMapViewController : current latitude = \(currentLocation.latitude)")
        self.locationNew.longitude = currentLocation.longitude
        print("PlaceMapViewController : current longitude = \(currentLocation.longitude)")
        
        // Call stopUpdatingLocation() to stop listening for location updates, otherwise this function will be called every time when user location changes.
        // After first call I don't want to listen my location anymore
        manager.stopUpdatingLocation()
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

// Add PlaceMarkerView classs definition derived from MKMarkerAnnotationView
//   override MKMarkerAnnotationView.annotation property to set color depending on place.type
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
