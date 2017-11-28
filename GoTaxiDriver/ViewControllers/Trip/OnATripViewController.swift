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
    @IBOutlet weak var completeTripBtn: UIButton!
    @IBOutlet weak var collectCashBtn: UIButton!
    var rideId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GO TAXI"
        completeTripBtn.isEnabled = false
        searchBox.layer.borderWidth = 1
        searchBox.layer.borderColor = UIColor().textFieldBorderColor.cgColor
    }

    @IBAction func collectCashBtnAction(_ sender: Any) {
        
    }
    @IBAction func completeTripBtnAction(_ sender: Any) {
        self.completeTrip(rideId: self.rideId)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension OnATripViewController {
    func completeTrip(rideId: Int) {
        self.showActivityIndicator()
        let parameter: [String : Any] = ["RideID": rideId, "Latitude": 3.1, "Longitude": 2.1]
        NetworkManager.startRide(parameter: parameter) { (status, response) in
            self.removeActivityIndicator()
            if response?.statusCode == APIStatusCodes.OperationSuccess {
                self.showAlertWithTitle("", message: "You have completed your ride.", OKButtonTitle: "OK", OKcompletion: nil, cancelButtonTitle: nil, cancelCompletion: nil)
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
extension OnATripViewController:StopTripDelegate {
    func didCollectedMoneyFromRider() {
        collectCashBtn.isEnabled = false
        completeTripBtn.isEnabled = true
        completeTripBtn.backgroundColor = UIColor.red
    }
}


protocol StopTripDelegate {
    func didCollectedMoneyFromRider()
}
