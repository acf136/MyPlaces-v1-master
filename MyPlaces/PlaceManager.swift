//
//  PlaceManager.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import UIKit

// Do you see those MARK lines there in the code? They do nothing (of course, they are comments
// after all). But that special syntax let you define some nice sections in the header. Have a look
// at the bar at the top of this code file. You should see something like...
// MyPlaces > MyPlaces > PlaceManager.swift > No Selection
// Click on the last element and you will get a drop down list from which you can navigate to any
// method in current file. Those MARK lines let you specify some sections to group related methods.

class PlaceManager {
    
    // MARK: - Singleton
    
    // Nothing fancy here.
    // This is just a different way to create a Singleton. But it's basically the same you just saw
    // in the sample code. Now you know two slightly different ways to do the same.
    // You can learn more about this pattern in Swift in:
    // https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift
    static let shared = PlaceManager()
    private init() { places = someTestPlaces }
    
    // MARK: - Class implementation
    
    // This is how PlaceManager will track all places: using an array. We could have used some other
    // data structure, but arrays are fast and easy to use. Anyway, if at any moment we decide to
    // use some other data structure, we'll only need to change the implementation for the methods
    // below, but all instances in our project calling methods in PlaceManager won't be affected,
    // because using an array or something else is just a private detail.
    private var places = [Place]()
    
    // Inserts a new place into list of places managed by PlaceManager.
    func append(_ place: Place) {
        places.append(place)
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
    
    // Returns a color UIColor for the given place with id calculated in function of the type of place
    func itemTypeColor(_ id: String) -> UIColor {
        let colorComp : Int = places.filter {$0.id == id}[0].type.rawValue % 3
        return ( colorComp == 1 ? UIColor(red:1.0,green:0.0,blue:0.0,alpha:1.0) :
                 (colorComp == 2 ? UIColor(red:0.0,green:1.0,blue:0.0,alpha:1.0) :
                                        UIColor(red:0.0,green:0.0,blue:1.0,alpha:1.0) )
        )
    }

    // MARK: - Only for demo purposes
    let someTestPlaces = [
        Place(name: "UOC 22@",
              description: "Seu de la Universitat Oberta de Catalunya",
              image_in: UIImage(named: "BavarianChurchSnow1") ),
        Place(name: "Rostisseria Lolita",
              description: "Els millors pollastres de Sant Cugat",
              image_in: UIImage(named: "Beach-Ireland") ),
        Place(name: "CIFO L'Hospitalet",
              description: "Seu del Centre d'Innovació i Formació per a l'Ocupació. El Centre d'Innovació i Formació per a l'Ocupació (CIFO) de l'Hospitalet ofereix formació en les àrees d'Edició i de Disseny gràfic i Multimèdia, a treballadors",
              image_in: UIImage(named: "Forest7")),
        PlaceTourist(name: "CosmoCaixa",
                     description: "Museu de la Ciència de Barcelona",
                     discount_tourist: "50%", image_in: UIImage(named: "sea4") , www: "" ),
        PlaceTourist(name: "Park Güell",
                     description: "Obra d'Antoni Gaudí a Barcelona",
                     discount_tourist: "10%", image_in: UIImage(named: "Tale2"), www: "") ,
    ]
}
