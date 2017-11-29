//
//  TripRequestViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 27/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class TripRequestViewController: UIViewController {

    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var minutesLbl: UILabel!
    var currentLocation: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GO TAXI"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        self.drawRouteToRiderLocation(currentLocation: self.currentLocation!, to: riderLocation)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let riderLocation = CLLocation(latitude: 38.911331, longitude: -94.637764)
        
        
        self.drawPath(riderLocation: riderLocation)
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUI()
    }
    
    func configureUI() {
        mapView.clipsToBounds = true
        mapBgView.layer.cornerRadius = mapBgView.layer.frame.width/2
        mapView.layer.cornerRadius = mapView.layer.frame.width / 2
    }
    
    @IBAction func cancelbtnAction(_ sender: Any) {
        self.cancelARide(rideId: 1)
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
        self.acceptRideWithId(rideId: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TripRequestViewController {
    func acceptRideWithId(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "IsApproved": true, "Latitude": 3.1, "Longitude": 2.1]
        NetworkManager.approveARide(parameter: parameter) { (status, response) in
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.removeActivityIndicator()
                let tripVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripvViewController") as! TripvViewController
                self.navigationController?.pushViewController(tripVC, animated: true)
            }
            
        }
    }
    
    func cancelARide(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "IsApproved": false, "Latitude": 3.1, "Longitude": 2.1]
        NetworkManager.approveARide(parameter: parameter) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension TripRequestViewController {
    func drawRouteToRiderLocation(currentLocation: CLLocation, to riderLocation: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15);
        
        let position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Current Location"
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        marker.map = mapView
    }
    
    func drawPath(riderLocation: CLLocation)
    {
        let origin =  String(format:"%f,%f",(currentLocation?.coordinate.latitude)!,(currentLocation?.coordinate.longitude)!)
        let destination = String(format:"%f,%f",(riderLocation.coordinate.latitude),(riderLocation.coordinate.longitude))
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDLlskLqvF8VoYCTs_j5PCMkW5CiPR-hvU"
        
        Alamofire.request(urlString).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            //let json = JSON(data: response.data!)
            let json = response.result.value  as! [String : Any]
            let routes:[[String:Any]] = json["routes"] as! [[String : Any]]
            
            for route in routes
            {
                let routeOverviewPolyline:[String:Any] = route["overview_polyline"] as! [String : Any]
                let points:String = String(describing: routeOverviewPolyline["points"])
                let path = GMSPath.init(fromEncodedPath: points)
                let polyline = GMSPolyline.init(path: path)
                polyline.map = self.mapView
            }
        }
    }
    
}
