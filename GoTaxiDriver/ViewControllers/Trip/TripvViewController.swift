//
//  TripvViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 27/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import GoogleMaps

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
    
    var rideId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.title = "GO TAXI"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureUI() {
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
