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
        mapView.clipsToBounds = true
        mapBgView.layer.cornerRadius = mapBgView.layer.frame.width/2
        mapView.layer.cornerRadius = mapView.layer.frame.width / 2
    }
    func configureUI() {
        
        
    }
    
    @IBAction func cancelbtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptBtnAction(_ sender: Any) {
        let tripVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripvViewController") as! TripvViewController
        self.navigationController?.pushViewController(tripVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
