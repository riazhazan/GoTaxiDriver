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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.title = "GO TAXI"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureUI() {
        riderNotifiedInfoView.isHidden = true
    }
    
    @IBAction func startTripBtnAction(_ sender: Any) {
        let tripVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnATripViewController") as! OnATripViewController
        self.navigationController?.pushViewController(tripVC, animated: true)
    }
    @IBAction func confirmArrivalBtnAction(_ sender: Any) {
        riderNotifiedInfoView.isHidden = false
        confirmArrivalBtn.isHidden = true
        startTripBtn.backgroundColor = UIColor(red: 4/255, green: 152/255, blue: 71/255, alpha: 1)
    }
    @IBAction func navigateBtnAction(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
