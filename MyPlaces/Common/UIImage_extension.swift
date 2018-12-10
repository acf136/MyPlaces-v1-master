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
    func centerHorizontally (height : CGFloat) -> UIImage? {
        var centerY : Int
        var offsetY : Double
        // Get the height o image and crop top and  bottom
        let heightNew = Double(height)
        let widthNew = Double((self.cgImage?.width)!)
        let offsetX = 0.0  ;
        let currentHeight = self.cgImage?.height ?? 0
        let isCurrentMoreThanNew = currentHeight - Int(height)
        if  isCurrentMoreThanNew > 0  {
            centerY = currentHeight / 2 - Int(height) / 2
        } else {
            centerY = Int(height) / 2 - currentHeight / 2
        }
        offsetY = Double(centerY)
        let boundingBox = CGRect(x: offsetX, y: offsetY, width: widthNew, height: heightNew)
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
