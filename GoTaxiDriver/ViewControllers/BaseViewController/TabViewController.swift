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
        configureTabBarController()
        //configureTab()
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
    
    func configureTabBarController() {
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let home = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let earnings = storyboard.instantiateViewController(withIdentifier: "EarningsViewController")
        let ratings = storyboard.instantiateViewController(withIdentifier: "RatingsViewController")
        let account = storyboard.instantiateViewController(withIdentifier: "AccountViewController")

        
        let nvHome = UINavigationController(rootViewController: home)
        let nvEarnings = UINavigationController(rootViewController: earnings)
        let nvRatings = UINavigationController(rootViewController: ratings)
        let nvAccount = UINavigationController(rootViewController: account)
        
        // all viewcontroller navigationbar hidden
        nvHome.setNavigationBarHidden(true, animated: false)
        nvEarnings.setNavigationBarHidden(true, animated: false)
        nvRatings.setNavigationBarHidden(true, animated: false)
        nvAccount.setNavigationBarHidden(true, animated: false)
        
        self.viewControllers = [nvHome,nvEarnings,nvRatings,nvAccount]
        
        let tabbar = self.tabBar
        tabbar.barTintColor = UIColor.black
        tabbar.backgroundColor = UIColor.black
        tabbar.tintColor = UIColor().goTaxiBlueColor
        
        //UITabBar.appearance().tintColor = UIColor.white

        let attributes = [NSAttributedStringKey.font:UIFont(name: AppMediumFont, size: AppFontRegularSize)!,NSAttributedStringKey.foregroundColor:UIColor.lightGray]
        let attributes1 = [NSAttributedStringKey.font:UIFont(name: AppMediumFont, size: AppFontRegularSize)!,NSAttributedStringKey.foregroundColor:UIColor().goTaxiBlueColor]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes1, for: .selected)
        
        
        let tabHome = tabbar.items![0]
        tabHome.title = "Home" // tabbar title
        tabHome.image = UIImage(named: "home")//?.withRenderingMode(.alwaysOriginal) // deselect image
        //tabHome.selectedImage = UIImage(named: "icon_home.png")?.withRenderingMode(.alwaysOriginal) // select image
        tabHome.titlePositionAdjustment.vertical = tabHome.titlePositionAdjustment.vertical-2 // title position change
        
        let tabEarning = tabbar.items![1]
        tabEarning.title = "Earnings"
        tabEarning.image = UIImage(named: "earnings")
        tabEarning.titlePositionAdjustment.vertical = tabHome.titlePositionAdjustment.vertical-2
       
        let tabRating = tabbar.items![2]
        tabRating.title = "Ratings"
        tabRating.image = UIImage(named: "ratings")
        tabRating.titlePositionAdjustment.vertical = tabRating.titlePositionAdjustment.vertical-2
        
        let tabAccount = tabbar.items![3]
        tabAccount.title = "Account"
        tabAccount.image = UIImage(named: "account")
        tabAccount.titlePositionAdjustment.vertical = tabAccount.titlePositionAdjustment.vertical-2

    }
    
}
