//
//  TripRequestViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 27/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import GoogleMaps

class TripRequestViewController: UIViewController {

    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var minutesLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "GO TAXI"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
