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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        LocationService.sharedInstance.locationManager.startUpdatingLocation()
    }

    @IBAction func menuBtnAction(_ sender: Any) {
        let tripRequestVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripRequestViewController") as! TripRequestViewController
        tripRequestVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tripRequestVC, animated: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
