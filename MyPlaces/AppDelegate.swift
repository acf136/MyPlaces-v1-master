//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MyPlaces INITIALIZATION
        let manager = PlaceManager.shared
        // Look at file system for JSON files containing Places
        let docsPath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)[0]
        let filePath = docsPath.appendingPathComponent(manager.nameOfFileJSON())  // This is the name of JSON file where we load/save the places in every session
        
        // If JSON files containing Place's then append to manager
        do {
            let jsonData = try Data(contentsOf: filePath)
            let placesJSON = manager.placesFrom(jsonData: jsonData)
            manager.insertJSONIntoPlaces(placesJSON: placesJSON)
            print("Loaded JSON data of Places")
        } catch {
        // else generate n random places and append to manager
            manager.append( Place(locationName: "UOC 22@", myDescription: "Seu de la Universitat Oberta de Catalunya",  image_in: UIImage(named: "BavarianChurchSnow1")) )
            //manager.append( Place(locationName: "Rostisseria Lolita", myDescription: "Els millors pollastres de Sant Cugat",  image_in: UIImage(named: "Beach-Ireland")) )
            manager.append( Place(locationName: "CIFO L'Hospitalet",
                                  myDescription: "Seu del Centre d'Innovació i Formació per a l'Ocupació. El Centre d'Innovació i Formació per a l'Ocupació (CIFO) de l'Hospitalet ofereix formació en les àrees d'Edició i de Disseny gràfic i Multimèdia, a treballadors",
                                  image_in: UIImage(named: "Forest7")) )
            //manager.append( PlaceTourist(locationName: "CosmoCaixa", myDescription: "Museu de la Ciència de Barcelona", discount_tourist: "50%", image_in: UIImage(named: "sea4") , www: "" )  )
            manager.append( PlaceTourist(locationName: "Park Güell", myDescription: "Obra d'Antoni Gaudí a Barcelona", discount_tourist: "10%", image_in: UIImage(named: "Tale2"), www: "") )
            print("Generated JSON data of Places")
        }
    
        return true
    }

}
