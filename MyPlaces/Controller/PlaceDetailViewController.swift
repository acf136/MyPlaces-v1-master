//
//  PlaceDetailViewController.swift
//  MyPlaces
//
//  Created by acf136 on 24/10/2018.
//  Copyright © 2018 Albert Mata Guerra. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {

    // Data to comunicate with other controllers
    var place : Place!
    var waitingForEditPlace = false
    // Own Outlets initialitzation
    // ...
    // Data for own management
    let manager = PlaceManager.shared
    
    // Outlets
    //
    @IBOutlet weak var idOfPlace: UILabel!
    @IBOutlet weak var typeOfPlace: UILabel!
    @IBOutlet weak var descrOfPlace: UILabel!
    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var locationOfPlace: UILabel!

    // Actions
    //

    // Called from AddPlaceController: must exist, even if empty
    // Is a func shared with others VControllers tha go to AddPlaceController screen
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        print("PlaceDetailViewController: prepareForUnwind")
        //self.view.draw(self.view.bounds)
        reloadDataOfView()
        self.view.setNeedsLayout()
        //self.view.layoutIfNeeded()
    }

    // Overrided members of UIViewController
    //
    
    // Manage/allow unwind from Edit
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        print("PlaceDetailViewController: canPerformUnwindSegueAction")
        if self.waitingForEditPlace {
            self.waitingForEditPlace = false
            return true
        } else {
            return false
        }
    }
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDataOfView()
        
        // Back Button Programmatically
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self,                                                                 action: #selector(PlaceDetailViewController.goBack) )
        
    }

    // Previous to go to other screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlaceSegue" {
            let apvnc = segue.destination as! UINavigationController
            let apvc = apvnc.topViewController as! AddPlaceController
            apvc.pdv = self.view as UIView
            apvc.inputPlace = place
            apvc.previousScreen = self as UIViewController
            apvc.locationNew = CLLocationCoordinate2D(latitude: place.coordinate.latitude,longitude: place.coordinate.longitude)
            waitingForEditPlace = true
        }
    }

    //
    // Public Functions of PlaceDetailViewController
    //
    public func reloadDataOfView() {
        title = place.locationName
        
        idOfPlace.text = place.id
        typeOfPlace.text = "\(place.type)"
        typeOfPlace.textColor = manager.itemTypeColor(place.id) //UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        descrOfPlace.text = place.myDescription
        descrOfPlace.sizeToFit()
        
        imageOfPlace.image = place.image
        locationOfPlace.text = String(format: "Latitude: %3.2f Longitude: %3.2f", arguments: [place.coordinate.latitude, place.coordinate.longitude])
    }
    
    //
    // Private Functions of PlaceDetailViewController
    //
    
    //  go back
    @objc private func goBack() {
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PlacesTableViewControllerSBID") as! PlacesTableViewController
        //        self.present(newViewController, animated: true, completion: nil)
        // go to previous screen
        dismiss(animated: true, completion: nil)
    }

}
