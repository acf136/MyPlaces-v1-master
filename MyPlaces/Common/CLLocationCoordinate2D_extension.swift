//
//  CLLocationCoordinate2D_extension.swift
//  MyPlaces
//
//  Created by acf136 on 20/11/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
