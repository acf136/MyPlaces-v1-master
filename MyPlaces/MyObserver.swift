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
    
    init(object: Place, property: PropertyKVO, action: (()->Void)? )  {
        objectToObserve = object
        super.init()
        
        switch property {   //only observable properties can be observed
        case .id:
            observation = observe( \.objectToObserve.id,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(String(describing: value.oldValue!)), updated to: \(String(describing: value.newValue!))")
                    action!()
                }
            }
        case .locationName :
            observation = observe( \.objectToObserve.locationName,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(value.oldValue!), updated to: \(value.newValue!)")
                    action!()
                }
            }
        case .myDescription :
            observation = observe( \.objectToObserve.myDescription,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(value.oldValue!), updated to: \(value.newValue!)")
                    action!()
                }
            }
        case .www :
            observation = observe( \.objectToObserve.www,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(String(describing: value.oldValue!)), updated to: \(String(describing: value.newValue!))")
                    action!()
                }
            }
        case .title :
            observation = observe( \.objectToObserve.title,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(String(describing: value.oldValue!)), updated to: \(String(describing: value.newValue!))")
                    action!()
                }
            }
        case .discipline :
            observation = observe( \.objectToObserve.discipline,
                                   options: [.old, .new]
            ) { object, value in
                if value.oldValue != value.newValue {
                    print("\(property) changed from: \(String(describing: value.oldValue!)), updated to: \(String(describing: value.newValue!))")
                    action!()
                }
            }
        default:
            print("KVO: No Property for Observer")
            observation = observe( \.objectToObserve , options: [.old, .new] ) { object, value in return }
        }

    }
}
