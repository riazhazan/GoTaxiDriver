//
//  TabViewController.swift
//  GoTaxi
//
//  Created by Riaz on 21/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureTab() {
        
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        homeVC.title = "HOME"
        
        let earningsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EarningsViewController")
        earningsVC.title = "EARNINGS"
        
        let ratingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingsViewController")
        ratingVC.title = "RATINGS"
        
        let accountVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController")
        accountVC.title = "ACCOUNT"
        self.viewControllers = [homeVC, earningsVC, ratingVC, accountVC]
    }
}
