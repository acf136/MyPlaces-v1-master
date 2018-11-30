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
    var previousScreen : UITableViewController!
    var place : Place!
    // initial status
    var waitingForEditPlace = false
    var dataChangedOnEdit = false
    // Own Outlets initialitzation
    // ...
    // Data for own management
    let manager = PlaceManager.shared
    var displayAdvice = false
    
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
        // if data changed on Edit
        if dataChangedOnEdit {
            reloadDataOfView()
            self.view.setNeedsLayout()
        } else {
            displayAdvice = true
        }
    }

    // Overrided members of UIViewController
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if displayAdvice {
            self.adviceNotEnoughData(message: "Data has not been changed")
        }
    }
    
    // Manage/allow unwind from Edit
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        print("PlaceDetailViewController: canPerformUnwindSegueAction")
        if waitingForEditPlace {
            waitingForEditPlace = false
            return true
        } else {
            return false
        }
    }
    
    // Previous to redraw, reload
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDataOfView()
        // initial status
        waitingForEditPlace = false
        dataChangedOnEdit = false
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
        if segue.identifier == "unwindFromPlaceDetail" {
            if  dataChangedOnEdit { let prevVC = previousScreen as! PlacesTableViewController ; prevVC.dataChangedOnDetail = true }
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
    
    //  alert that nothing has been added/updated
    public func adviceNotEnoughData(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.displayAdvice = false // one time only
    }
    
    //
    // Private Functions of PlaceDetailViewController
    //

}
