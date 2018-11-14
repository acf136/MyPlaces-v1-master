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
        case name = "name"
        case description = "description"
        case latitude = "latitude"
        case longitude = "longitude"
        case www = "site"
        case myImageString = "imageJPGString"
    }
    // Decoder   JSON ->  PlaceJSON
    init (from: Decoder) throws {
        let container = try from.container(keyedBy: PlaceKeys.self)
        //
        let id = try container.decode(String.self, forKey: .id)
        let tipo = try container.decode(Int.self, forKey: .type)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let locationCoord2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let web = try container.decode(String.self, forKey: .www)
        let myImageString = try container.decode(String.self, forKey: .myImageString)
        let jpegData = Data(base64Encoded: myImageString)
        let myImage = UIImage(data: jpegData!)
        //let myImage =  UIImage(named: "Forest7")
        
        self.init(id: id, type: PlaceType(rawValue: tipo)! , name: name, description: description, location: locationCoord2D, www: web, image: myImage)
    }
    // Encoder  PlaceJSON  -> JSON
    func encode(to: Encoder) throws {
        var container = to.container(keyedBy: PlaceKeys.self)
        //
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name , forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(location.latitude, forKey: .latitude)
        try container.encode(location.longitude, forKey: .longitude)
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
        
    }

}
