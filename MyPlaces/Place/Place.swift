//
//  Place.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

// Place type enumeration with raw value Int
enum PlaceType : Int {
    case generic = 1
    case touristic
    case services
}

// part of Place to serialize as JSON
struct PlaceJSON : Codable { // Encodable, Decodable  {
    var id : String
    var type : Int //PlaceType
    var name : String
    var description : String
    var location : 	CLLocationCoordinate2D!
    var www : String
    var myImage: UIImage?
    
    // default Constructor
    init(id: String, type: PlaceType, name: String, description: String , location: CLLocationCoordinate2D , www: String?, image: UIImage?) {
        self.id = id
        self.type = type.rawValue
        self.name = name
        self.description = description
        self.location = location
        self.www = www ?? ""
        self.myImage = image ?? nil
    }
}

class Place {
    
    // We don't need to specify types when the compiler can infer them from context. That doesn't
    // mean id or name have no type or can have different types at different moments. No way. Both
    // are and will be String.
    var id = ""
    var type = PlaceType.generic
    var name = ""
    var description = ""
    var location: CLLocationCoordinate2D!
    var www: String?
//  Next info not Codable in JSON
    var image: UIImage?
    	
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one has no information about name or description, so it creates an almost empty place.
    init() {
        self.id = UUID().uuidString
        // -90 < latitude < 90 , -180 < longitude < 180  [in degrees]
        self.location = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
    }
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one creates a generic place with basic name and description information.
    init(name: String, description: String, image_in: UIImage?) {
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        // -90 < latitude < 90 , -180 < longitude < 180  [in degrees]
        self.location = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
        self.image = image_in
    }
    
    // We need to learn a bit more about initialization, but meanwhile we create some initializers.
    // This one creates a generic or touristic place (based on parameter) with basic name and
    // description information. But wait a minute... shouldn't we create a PlaceTourist instance
    // if we wanted a touristic place? :)
    init(type: PlaceType, name: String, description: String , image_in: UIImage?, www: String?) {
        self.id = UUID().uuidString
        self.type = type
        self.name = name
        self.description = description
        // -90 < latitude < 90 , -180 < longitude < 180  [in degrees]
        self.location = CLLocationCoordinate2D(latitude: Double.random(in: 1...360) - 90.0, longitude: Double.random(in: 1...360) - 180.0)
        self.image = image_in
        self.www = www
    }
    // Constructor needed to import JSON data
    // These is why id is informed
    init(id: String, type: PlaceType, name: String, description: String , location: CLLocationCoordinate2D , www: String?, image: UIImage?) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.location = location
        self.www = www
        self.image = image
    }
    
}
