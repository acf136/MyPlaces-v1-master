//
//  Place.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

class Place {

    // We could have created a PlaceType.swift file for this enumeration or just put it in current
    // Place.swift file but outside the class (so, between those "import MapKit" and "class Place {"
    // lines). However if we know we are only going to use it from our Place, it's probably cleaner
    // if the enumeration lives inside the class.
    enum PlaceType : Int {
        case generic = 1
        case touristic
        case services
    }
    
    // We don't need to specify types when the compiler can infer them from context. That doesn't
    // mean id or name have no type or can have different types at different moments. No way. Both
    // are and will be String.
    var id = ""
    var type = PlaceType.generic
    var name = ""
    var description = ""
    var location: CLLocationCoordinate2D!
    var image: UIImage?
    var www: String?
    	
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one has no information about name or description, so it creates an almost empty place.
    init() {
        self.id = UUID().uuidString
    }
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one creates a generic place with basic name and description information.
    init(name: String, description: String, image_in: UIImage?) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
    }
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one creates a generic or touristic place (based on parameter) with basic name and
    // description information. But wait a minute... shouldn't we create a PlaceTourist instance
    // if we wanted a touristic place? :)
    init(type: PlaceType, name: String, description: String, image_in: UIImage?, www: String?) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.description = description
        self.image = image_in
        self.www = www
    }
}
