//
//  MyPlaceGlobalDeclarations.swift
//  MyPlaces
//
//  Created by acf136 on 30/10/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import Foundation
import MapKit

// extension for UIImage to crop images in PlaceCell from the top-left corner to the size of the cell
// This allows to use any size of images to show as background in the cell, and then shown in the corresponding detail 
extension UIImage {
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
