//
//  AccountViewController.swift
//  GoTaxi
//
//  Created by Riaz on 21/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var accountTableView: UITableView!
    var rowTitles: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        rowTitles = ["", NSLocalizedString("DRIVER_PROFILE", comment: ""), NSLocalizedString("HELP", comment: ""),
        NSLocalizedString("WAYBILL", comment: ""),
        NSLocalizedString("DOCUMENTS", comment: ""),
        NSLocalizedString("SETTINGS", comment: ""), NSLocalizedString("ABOUT", comment: "")]
        accountTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AccountViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTableTopCell", for: indexPath) as! AccountsTableTopCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTableCell", for: indexPath) as! AccountsTableCell
        cell.titleLbl.text = rowTitles[indexPath.row]
        cell.subTitleLbl.text = ""
        if indexPath.row == 1 {
            cell.subTitleLbl.text = "your riders will see this."
        }
        
        return cell
 
    }
}
