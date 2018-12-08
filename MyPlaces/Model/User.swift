//
//  User.swift
//  MyPlaces
//
//  Created by acf136 on 05/12/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
