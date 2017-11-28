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
    @IBOutlet weak var mainTitleLbl: UILabel!
    
    @IBOutlet weak var riderNotifiedInfoView: UIView!

    @IBOutlet weak var startTripBtn: UIButton!
    @IBOutlet weak var confirmArrivalBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pickupTitleLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
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
        self.startTripBtn.isEnabled = false
        riderNotifiedInfoView.isHidden = true
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
                let tripVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnATripViewController") as! OnATripViewController
                self.navigationController?.pushViewController(tripVC, animated: true)
            }
            
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
