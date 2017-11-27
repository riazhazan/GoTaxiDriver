//
//  HomeViewController.swift
//  GoTaxi
//
//  Created by Riaz on 22/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import GoogleMaps
class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationService.sharedInstance.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
