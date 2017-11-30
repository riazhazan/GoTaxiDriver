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
        self.title = "ACCOUNT"
        accountTableView.tableFooterView = UIView()
        rowTitles = [NSLocalizedString("DRIVER_PROFILE", comment: ""), NSLocalizedString("HELP", comment: ""),
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTableTopCell", for: indexPath) as! AccountsTableTopCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTableCell", for: indexPath) as! AccountsTableCell
            cell.titleLbl.text = rowTitles[indexPath.row]
            cell.subTitleLbl.text = ""
            cell.lblTopConstrain.constant = 4
            if indexPath.row == 0 {
                cell.lblTopConstrain.constant = -10
                cell.subTitleLbl.text = "your riders will see this."
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = NSLocalizedString("SIGNOUT", comment: "")
            return cell
        }
 
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1, 2:
            return 20
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.backgroundColor = UIColor().textFieldBorderColor
        return view
    }
}
