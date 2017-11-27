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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GO TAXI"
        searchBox.layer.borderWidth = 1
        searchBox.layer.borderColor = UIColor().textFieldBorderColor.cgColor
    }

    @IBAction func collectCashBtnAction(_ sender: Any) {
        
    }
    @IBAction func completeTripBtnAction(_ sender: Any) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
