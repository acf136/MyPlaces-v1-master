//
//  MyObserver.swift
//  MyPlaces
//
//  Created by acf136 on 03/12/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit

class MyObserver: NSObject {
    @objc var objectToObserve: Place
    var observation: NSKeyValueObservation?
    
    init(object: Place, property: PropertyKVO) {
        objectToObserve = object
        super.init()
        
        //     case id = 1
        switch property {
//        case .id :
//        case .type :
//        case .locationName :
        case .myDescription :
            observation = observe( \.objectToObserve.myDescription,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(value.oldValue!), updated to: \(value.newValue!)")
                }
            }
//        case .coordinate :
//        case .www :
//        case .title :
//        case .discipline :
//        case .image :
        default:
//            print("KVO: No Property for Observer")
            observation = observe( \.objectToObserve , options: [.old, .new] ) { object, value in return }
        }

    }
}
