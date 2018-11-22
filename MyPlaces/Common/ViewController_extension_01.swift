//
//  ViewController_extension_01.swift
//  MyPlaces
//
//  Created by acf136 on 22/11/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension PlacesTableViewController  {
    
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

extension PlaceMapViewController  {
    
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
