//
//  CurrentTripsTableCell.swift
//  GoTaxiDriver
//
//  Created by mac on 01/12/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class CurrentTripsTableCell: UITableViewCell {

    @IBOutlet weak var pickIndicatorView: UIView!
    @IBOutlet weak var dropIndicatorView: UIView!
    @IBOutlet weak var dropOffTitleLbl: UILabel!
    @IBOutlet weak var dropOffLocation: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var vehicleTypeLbl: UILabel!
    @IBOutlet weak var pickUpLocationLbl: UILabel!
    @IBOutlet weak var pickupTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        pickIndicatorView.layer.cornerRadius = 7.5
        dropIndicatorView.layer.cornerRadius = 7.5
        dropIndicatorView.layer.borderColor = UIColor.red.cgColor
        dropIndicatorView.layer.borderWidth = 4.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
