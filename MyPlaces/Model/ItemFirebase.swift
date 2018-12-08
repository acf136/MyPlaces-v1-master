//
//  ItemFirebase.swift
//  MyPlaces
//
//  Created by acf136 on 05/12/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import Firebase

struct ItemFirebase {
    
    //let ref: DatabaseReference?
    let key: String
    let name: String
    let placeJSON: String
    let addedByUser: String
    var completed: Bool
    
    init(key: String, name: String, placeJSON: String, addedByUser: String? , completed: Bool) {
//        self.ref = nil
        self.key = key
        self.name = name
        self.placeJSON = placeJSON
        self.addedByUser = addedByUser ?? ""
        self.completed = completed
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let placeJSON = value["placeJSON"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let completed = value["completed"] as? Bool else {
                return nil
        }
        
//        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.placeJSON = placeJSON
        self.addedByUser = addedByUser
        self.completed = completed
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "placeJSON": placeJSON,
            "addedByUser": addedByUser,
            "completed": completed
        ]
    }
}
