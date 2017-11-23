//
//  LandingViewController.swift
//  GoTaxi
//
//  Created by Riaz on 21/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinBtnAction(_ sender: Any) {
        //UserDefaults.standard.set(true, forKey: Constants.isUserLoggedIn)
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        
        self.navigationController?.pushViewController(loginVC, animated: true)
//        let tabController = TabViewController()
//        UIApplication.shared.keyWindow?.rootViewController = tabController
    }
    @IBAction func registerBtnAction(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController")
        
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

