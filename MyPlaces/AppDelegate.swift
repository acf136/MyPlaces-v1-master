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
        
        // We add some test places so the app can show some information when it loads. When we start
        // creating our own real content we will need to remove this part, of course.
//       let manager = PlaceManager.shared
//        for place in manager.places{
//            manager.append(place)
//        }
        
        return true
    }

}
