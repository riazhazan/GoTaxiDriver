//
//  OnATripViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 28/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import GoogleMaps
class OnATripViewController: UIViewController {

    @IBOutlet weak var searchBox: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    var rideId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GO TAXI"
        
        searchBox.layer.borderWidth = 1
        searchBox.layer.borderColor = UIColor().textFieldBorderColor.cgColor
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


