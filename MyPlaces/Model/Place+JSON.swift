//
//  Place+JSON.swift
//  MyPlaces
//
//  Created by acf136 on 14/11/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import MapKit

// All the stuff of struct PlaceJSON (part of Place) to manage as JSON : Doesn't include UIImageView.image
extension  PlaceJSON  {
    
    enum PlaceKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case locationName = "locationName"
        case myDescription = "myDescription"
        case latitude = "latitude"
        case longitude = "longitude"
        case www = "www"
        case myImageString = "myImage"
        case title = "title"
        case discipline = "discipline"
    }
    // Decoder   JSON ->  PlaceJSON
    init (from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceKeys.self)
        //
        let id = try container.decode(String.self, forKey: .id)
        let tipo = try container.decode(Int.self, forKey: .type)
        let locationName = try container.decode(String.self, forKey: .locationName)
        let myDescription = try container.decode(String.self, forKey: .myDescription)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let locationCoord2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let web = try container.decode(String.self, forKey: .www)
        let myImageString = try container.decode(String.self, forKey: .myImageString)
        let jpegData = Data(base64Encoded: myImageString)
        let myImage = UIImage(data: jpegData!)
        let title = try container.decode(String.self, forKey: .title)
        let discipline = try container.decode(String.self, forKey: .discipline)
        //
        self.init(id: id, type: PlaceType(rawValue: tipo)! , locationName: locationName, myDescription: myDescription, coordinate: locationCoord2D, www: web, image: myImage, title: title, discipline: discipline)
    }
    // Encoder  PlaceJSON  -> JSON
    func encode(to: Encoder) throws {
        var container = to.container(keyedBy: PlaceKeys.self)
        //
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(locationName , forKey: .locationName)
        try container.encode(myDescription, forKey: .myDescription)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(www, forKey: .www)
        if myImage != nil {
            let jpegData = myImage!.jpegData(compressionQuality: 1.0)
            let encodedString = jpegData!.base64EncodedString()
            try container.encode(encodedString, forKey: .myImageString)
        } else {
            let jpegData = UIImage(named: "PutYourImageHere")!.jpegData(compressionQuality: 1.0)
            let encodedString = jpegData!.base64EncodedString()
            try container.encode(encodedString, forKey: .myImageString)
        }
        try container.encode(title, forKey: .title)
        try container.encode(discipline, forKey: .discipline)
        
    }

}
