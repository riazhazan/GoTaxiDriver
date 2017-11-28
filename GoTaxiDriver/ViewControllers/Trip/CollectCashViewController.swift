//
//  CollectCashViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 28/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class CollectCashViewController: BaseViewController {

    var tripId: Int = 0
    var amount: Int = 0
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var TitleLbl: UILabel!
    var stopTripDelegate: StopTripDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("COLLECT_CASH", comment: "")
        self.TitleLbl.text = NSLocalizedString("AMOUNT_DUE", comment: "")
    }

    @IBAction func doneBtnAction(_ sender: Any) {
        stopTripDelegate?.didCollectedMoneyFromRider()
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
