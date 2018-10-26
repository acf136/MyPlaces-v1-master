//
//  PlaceTourist.swift
//  MyPlaces
//
//  Created by Albert Mata Guerra on 28/09/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import UIKit

// PlaceTourist is subclass of Place.
// So, Place is PlaceTourist's superclass.
// Please note Place has no superclass.
class PlaceTourist : Place {
    var discount_tourist = ""
    
    // Please read more about initializers at:
    // https://docs.swift.org/swift-book/LanguageGuide/Initialization.html
    override init() {
        super.init()
        self.type = .touristic
    }
    
    // Please read more about initializers at:
    // https://docs.swift.org/swift-book/LanguageGuide/Initialization.html
    init(name: String, description: String, discount_tourist: String, image_in: UIImage?) {
        super.init(type: .touristic, name: name, description: description, image_in:image_in)
        self.discount_tourist = discount_tourist
    }
    
}
