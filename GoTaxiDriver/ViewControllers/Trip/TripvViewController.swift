//
//  TripvViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 27/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

class TripvViewController: UIViewController {
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var onATripBgView: UIView!
    @IBOutlet weak var tripBgView: UIView!
    @IBOutlet weak var riderNotifiedInfoView: UIView!

    @IBOutlet weak var startTripBtn: UIButton!
    @IBOutlet weak var confirmArrivalBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pickupTitleLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var completeTripBtn: UIButton!
    @IBOutlet weak var collectCashBtn: UIButton!
    var routes:[JSON]?
    var rideId: Int = 0
    var currentLocation: CLLocation?
    var riderLocation:CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.title = "GO TAXI"
        configureNavigationBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.drawRouteToRiderLocation(currentLocation: currentLocation!, to: self.riderLocation!)
        self.drawPath(riderLocation: self.riderLocation!)
    }
    
    func configureUI() {
        self.navigationItem.hidesBackButton = true
        self.configureBottomViewLayout(view: tripBgView)
        self.configureBottomViewLayout(view: onATripBgView)
        self.completeTripBtn.isEnabled = false
        self.startTripBtn.isEnabled = false
        self.onATripBgView.isHidden = true
        riderNotifiedInfoView.isHidden = true
    }
    
    func configureBottomViewLayout(view: UIView) {
        view.layer.cornerRadius = 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor().textFieldBorderColor.cgColor
    }
    
    @IBAction func startTripBtnAction(_ sender: Any) {
        startATrip(rideId: self.rideId)
    }
    @IBAction func confirmArrivalBtnAction(_ sender: Any) {
        confirmReached(rideId: self.rideId)
    }
    @IBAction func navigateBtnAction(_ sender: Any) {
        
    }

    func configureNavigationBarButton() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "currentTrips"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(currentTripBtnAction), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func currentTripBtnAction() {
        let currentTripsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrentTripsViewController") as! CurrentTripsViewController
        self.navigationController?.pushViewController(currentTripsVC, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TripvViewController {
    func startATrip(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "Latitude": 3.1, "Longitude": 2.1]
        NetworkManager.startRide(parameter: parameter) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.tripBgView.isHidden = true
                self.onATripBgView.isHidden = false
                return
            }
            self.showAlertWithTitle("", message: response?.statusMessage ?? "Failed to start a trip. Please try again.", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
        }
    }
    
    func confirmReached(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "Latitude": 3.1, "Longitude": 2.1]
        NetworkManager.confirmReachedRiderLocation(parameter: parameter) { (status, response) in
           self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.riderNotifiedInfoView.isHidden = false
                self.confirmArrivalBtn.isHidden = true
                self.startTripBtn.isEnabled = true
                self.startTripBtn.backgroundColor = UIColor(red: 4/255, green: 152/255, blue: 71/255, alpha: 1)
            }
        }
        
    }
}


extension TripvViewController {
    
    @IBAction func collectCashBtnAction(_ sender: Any) {
        self.stopRideAndCollectMoney(rideId: self.rideId)
    }
    @IBAction func completeTripBtnAction(_ sender: Any) {
        self.completeTrip(rideId: self.rideId)
    }
    
    func completeTrip(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "Latitude": 3.1, "Longitude": 2.1]
        NetworkManager.completeRide(parameter: parameter) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                
                self.showAlertWithTitle("Go Taxi", message: "You have completed your ride.", OKButtonTitle: "OK", OKcompletion: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }, cancelButtonTitle: nil, cancelCompletion: nil)
            }
        }
    }
    
    func stopRideAndCollectMoney(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "DistanceTravelled": 10, "TimeTaken": 20, "TravelledRouteGeoCollection": []]
        NetworkManager.stopTheRide(parameter: parameter) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                let collectMoneyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CollectCashViewController") as! CollectCashViewController
                collectMoneyVC.amount = (response?.amount ?? 0)!
                collectMoneyVC.tripId = self.rideId
                collectMoneyVC.stopTripDelegate = self
                self.navigationController?.pushViewController(collectMoneyVC, animated: true)
            }
        }
        
    }
}

extension TripvViewController {
    func drawRouteToRiderLocation(currentLocation: CLLocation, to riderLocation: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 2);
        
        let position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Current Location"
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        marker.map = mapView
        
        let riderPosition = CLLocationCoordinate2D(latitude: riderLocation.coordinate.latitude, longitude: riderLocation.coordinate.longitude)
        let riderMarker = GMSMarker(position: riderPosition)
        riderMarker.title = "Rider Location"
        riderMarker.map = mapView
    }
    
    func drawPath(riderLocation: CLLocation)
    {
        for route in self.routes ?? []
        {
            let routeOverviewPolyline = route["overview_polyline"].dictionary
            let points = routeOverviewPolyline?["points"]?.stringValue
            let path = GMSPath.init(fromEncodedPath: points!)
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 7
            polyline.strokeColor = UIColor.black
            polyline.map = self.mapView
            
            var bounds = GMSCoordinateBounds()
            for index in UInt(0)...(path?.count())! {
                bounds = bounds.includingCoordinate((path?.coordinate(at: index))!)
            }
            self.mapView.animate(toZoom: 5)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
            let update = GMSCameraUpdate.fit(bounds, withPadding: 20.0)
            self.mapView.moveCamera(update)
        }
    }
}

extension TripvViewController:StopTripDelegate {
    func didCollectedMoneyFromRider() {
        collectCashBtn.isEnabled = false
        collectCashBtn.alpha = 0.5
        completeTripBtn.isEnabled = true
        completeTripBtn.backgroundColor = UIColor.red
    }
}


protocol StopTripDelegate {
    func didCollectedMoneyFromRider()
}
