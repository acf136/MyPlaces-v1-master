//
//  PlaceManager.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// Do you see those MARK lines there in the code? They do nothing (of course, they are comments
// after all). But that special syntax let you define some nice sections in the header. Have a look
// at the bar at the top of this code file. You should see something like...
// MyPlaces > MyPlaces > PlaceManager.swift > No Selection
// Click on the last element and you will get a drop down list from which you can navigate to any
// method in current file. Those MARK lines let you specify some sections to group related methods.

class PlaceManager : NSObject {
    
    // MARK: - Singleton
    
    // Nothing fancy here.
    // This is just a different way to create a Singleton. But it's basically the same you just saw
    // in the sample code. Now you know two slightly different ways to do the same.
    // You can learn more about this pattern in Swift in:
    // https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift
    static let shared = PlaceManager()
    private override init() {   }
    
    // Contains max. distance between all points in places in meters
    var maxDistBtPlaces: Double = 0.0 // max. distance between places
    
    // MARK: - Class implementation
    
    // This is how PlaceManager will track all places: using an array. We could have used some other
    // data structure, but arrays are fast and easy to use. Anyway, if at any moment we decide to
    // use some other data structure, we'll only need to change the implementation for the methods
    // below, but all instances in our project calling methods in PlaceManager won't be affected,
    // because using an array or something else is just a private detail.
    private var places = [Place]()
    private var fileJSON = "MyPlaces.JSON"

    // KVO observers
    var myObservers : [MyObserver] = []
    
    //  Set myObservers : [MyObserver]
    func setObservers(place: Place) {
        // observer for myDescription
        myObservers.append(MyObserver(object: place, property: .myDescription ))
        // observer for image
        myObservers.append(MyObserver(object: place, property: .image ))
    }
    
    // Return max. distance between places in meters
    func calcMaxDistBtPlaces() -> Double {
        var maxdist = 0.0
        var pos : Int = 0
        if self.count() > 1 {
            repeat {
                let myFstCoord = self.itemAt(position: pos)?.coordinate
                let mySecCoord = self.itemAt(position: pos+1)?.coordinate
                let distance : CLLocationDistance = ( myFstCoord?.distance(from: mySecCoord!) )!
                if distance > maxdist { maxdist = distance }
                pos += 1
            } while pos < (self.count() - 1)
        }
        
        return maxdist
    }
    // Inserts a new place into list of places managed by PlaceManager.
    func append(_ place: Place) {
        places.append(place)
        self.maxDistBtPlaces = calcMaxDistBtPlaces()
        self.setObservers(place: place)
    }
    // Modify a Place with Id with the given observable properties of a new object Place passed by parameter
    func modify(properties: [PropertyKVO] ,Id: String , placeNew: Place ) {
        let posToModify = self.indexOf(self.itemWithId(Id)!)
        if posToModify < self.count() {
            for item in properties {
                switch item {
                case .id :
                    places[posToModify].id = placeNew.id
                case .type :
                    places[posToModify].type = placeNew.type
                case .locationName :
                    places[posToModify].locationName = placeNew.locationName
                case .myDescription :
                    places[posToModify].myDescription = placeNew.myDescription
                case .coordinate :
                    places[posToModify].coordinate = placeNew.coordinate
                case .www :
                    places[posToModify].www = placeNew.www
                case .title :
                    places[posToModify].title = placeNew.title
                case .discipline :
                    places[posToModify].discipline = placeNew.discipline
                case .image :
                    places[posToModify].image = placeNew.image
                }
            }
            
        }
        else {
            return
        }
    }
    // Returns number of places managed by PlaceManager.
    func count() -> Int {
        return places.count
    }
    
    // Returns place at specified position from those managed by PlaceManager.
    // Please note this method was supposed to return Place (instead of Place?). But then... what
    // happens if someone asks for place at position 10 and there are only 8 places? What should
    // this method return? A new empty place? Some random place? It's probably a better idea if it
    // just returns nil, but for that to happen the method need to return Place?, that is, an
    // Optional(Place).
    func itemAt(position: Int) -> Place? {
        // guard let us specify some condition that needs to be fulfilled.
        guard position < places.count else { return nil }
        
        // If the execution gets to this point, it's 100% sure position is lower than places.count.
        // So at this moment it's safe to access the element using [] syntax.
        return places[position]
    }
    
    // Returns place with specified id from those managed by PlaceManager.
    // Exactly same thing happens here (see comment for itemAt(position:) method). We actually need
    // this method to return Place? if we want to avoid hypothetical problems in the future.
    func itemWithId(_ id: String) -> Place? {
        return places.filter {$0.id == id}.first
    }
    
    // Removes a place from list of places managed by PlaceManager.
    func remove(_ place: Place) {
        // Instead of trying to remove anything, we can just filter all places that are not the one
        // we want to remove and then assign the filtered array to same places variable.
        places = places.filter {$0.id != place.id}
    }
    // Return index on places of Place
    func indexOf(_ Place : Place)  -> Int {
        return places.firstIndex(of: Place) ?? -1
    }
    
    // Insert a place at a given position
    func InsertAt(position: Int, Place: Place) {
        if position < places.count + 1 { places.insert(Place, at: position) }
    }
    
    // Returns a color UIColor for the given place with id calculated in function of the type of place
    func itemTypeColor(_ id: String) -> UIColor {
        let colorComp : Int = places.filter {$0.id == id}[0].type.rawValue % 3
        return ( colorComp == 1 ? UIColor(red:1.0,green:0.0,blue:0.0,alpha:1.0) :
                 (colorComp == 2 ? UIColor(red:0.0,green:1.0,blue:0.0,alpha:1.0) :
                                        UIColor(red:0.0,green:0.0,blue:1.0,alpha:1.0) )
        )
    }
    
    //
    //  JSON Management Methods
    //
    //
    func nameOfFileJSON() -> String { return self.fileJSON }
    // Write File "MyPlaces.JSON" with all the JSON info of places
    func writeFileOfPlaces(file: String) {
        let docsPath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)[0]
        let filePath = docsPath.appendingPathComponent(file)
        if let jsonData =  jsonFrom(places: extractJSONFromPlaces()) {
            do {
                try jsonData.write(to: filePath)
                print("File of MyPlaces SAVED")
            } catch {
                print("File of MyPlaces not saved")
            }
        }
    }
    //
    // Returns an array with all JSON info from places : Excluding that which is not Codable, like an image
    func extractJSONFromPlaces() -> [PlaceJSON] {
        var placesJSON : [PlaceJSON] = []
        for item in places {
            let placeJSON = PlaceJSON(id: item.id, type: PlaceType(rawValue: item.type.rawValue)!, locationName: item.locationName,
                                      myDescription: item.myDescription, coordinate: item.coordinate, www: item.www, image: item.image , title: item.title, discipline: item.discipline)
            placesJSON.append( placeJSON )
        }
        return placesJSON
    }
    // JSON Encoder : Returns in a Data? all the JSON info of places
    func jsonFrom(places: [PlaceJSON]) -> Data? {
        var jsonData: Data? = nil
        let jsonEncoder = JSONEncoder()
        do {
            jsonData = try jsonEncoder.encode(places)
        } catch {
            return nil
        }
        return jsonData
    }
    // JSON Decoder : Returns in a [PlaceJSON] all the JSON info of places retrieved from Data
    func placesFrom(jsonData: Data) -> [PlaceJSON] {
        var placesJSON : [PlaceJSON] = []
        let jsonDecoder = JSONDecoder()
        do {
            placesJSON = try jsonDecoder.decode([PlaceJSON].self, from: jsonData)
        } catch {
            return []
        }
      	  return placesJSON
    }
    
    // Given  an array with all JSON info to add to places, insert it into places
    func insertJSONIntoPlaces(placesJSON: [PlaceJSON]) {
        for item in placesJSON {
            let itemType = PlaceType(rawValue: item.type)!
            let itemLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude )
            places.append( Place(id: item.id, type: itemType , locationName: item.locationName , myDescription: item.myDescription , coordinate: itemLocation , www: item.www, image: item.myImage, title: item.title!, discipline: item.discipline ) )
        }
        for item in places { self.setObservers(place: item) }
        self.maxDistBtPlaces = calcMaxDistBtPlaces()
    }

}
