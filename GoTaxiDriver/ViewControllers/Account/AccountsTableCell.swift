//
//  AccountsTablecCellTableViewCell.swift
//  GoTaxiDriver
//
//  Created by Riaz on 29/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class AccountsTableCell: UITableViewCell {

    @IBOutlet weak var lblTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class AccountsTableTopCell: UITableViewCell {
    
    @IBOutlet weak var carNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var vehicleImg: UIButton!
    @IBOutlet weak var profileImg: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        vehicleImg.layer.cornerRadius = 37.5
        profileImg.layer.cornerRadius = 37.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
