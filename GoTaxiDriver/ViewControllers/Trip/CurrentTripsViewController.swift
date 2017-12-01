//
//  CurrentTripsViewController.swift
//  GoTaxiDriver
//
//  Created by mac on 01/12/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class CurrentTripsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickIndicatorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CURRENT TRIPS"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CurrentTripsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTripsTableCell", for: indexPath) as! CurrentTripsTableCell
        return cell
        
    }
}
