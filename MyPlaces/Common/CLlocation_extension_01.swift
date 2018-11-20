//
//  CLlocation_extension_01.swift
//  MyPlaces
//
//  Created by acf136 on 20/11/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import MapKit

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(to)
    }
}
