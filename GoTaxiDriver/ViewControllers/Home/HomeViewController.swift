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
    var lastLocation: CLLocation?
    var marker = GMSMarker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        LocationService.sharedInstance.locationManager?.startUpdatingLocation()
        LocationService.sharedInstance.updateLocationDelegate = self
    }

    @IBAction func menuBtnAction(_ sender: Any) {
        let tripRequestVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripRequestViewController") as! TripRequestViewController
        tripRequestVC.hidesBottomBarWhenPushed = true
        tripRequestVC.currentLocation = self.lastLocation
        self.navigationController?.pushViewController(tripRequestVC, animated: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeViewController {
    func plotCurrentLocationOnMap(location: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15);
        
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker = GMSMarker(position: position)
        marker.title = "Current Location"
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        marker.map = mapView
    }
}

extension HomeViewController:UpdateLocationDelegate {
    func didUpdateLocation(location: CLLocation) {
        self.lastLocation = location
        self.plotCurrentLocationOnMap(location: location)
        self.syncDriverCurrentLocationToServer(location: location)
    }
    
    func syncDriverCurrentLocationToServer(location: CLLocation) {
        let parameter: [String : Any] = ["Number": 1, "Lat": location.coordinate.latitude, "Long": location.coordinate.longitude, "UserType": userEntityCode]
        NetworkManager.syncCurrentLocation(parameter: parameter) { (status, response) in
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                print(response)
            }
        }
    }
    
}
