//
//  AppDelegate.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MyPlaces INITIALIZATION
        let manager = PlaceManager.shared
        // Look at file system for JSON files containing Places
        let docsPath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)[0]
        let filePath = docsPath.appendingPathComponent(manager.nameOfFileJSON())  // This is the name of JSON file where we load/save the places in every session
        
         //If JSON files containing Place's then append to manager
        do {
            let jsonData = try Data(contentsOf: filePath)
            let placesJSON = manager.placesFrom(jsonData: jsonData)
            manager.insertJSONIntoPlaces(placesJSON: placesJSON)
            print("Loaded JSON data of Places")
        } catch {
        // else generate n random places and append to manager
            manager.append( Place(id: "1", type: .generic, locationName: "Plaza Cataluña 1, Barcelona 08002, Spain", myDescription: "The very center of Barcelona, the most global and cosmopolitan town in Europe." , coordinate: CLLocationCoordinate2D(latitude: 41.385910, longitude: 2.169540), www: "", image: UIImage(named:"PlazaCatalunya1"),  title: "Plaça Catalunya", discipline: "") )
            manager.append( Place(id: "2", type: .touristic, locationName: "Park Güell , Barcelona 08024, Spain", myDescription: "You can't forget to visit this emblematic place in Barcelona" , coordinate: CLLocationCoordinate2D(latitude: 41.415830, longitude: 2.148610), www: "", image: UIImage(named:"ParcGüell1"),  title: "Parc Güell", discipline: "") )
            
            print("Generated JSON data of Places")
        }
    
        return true
    }

}
