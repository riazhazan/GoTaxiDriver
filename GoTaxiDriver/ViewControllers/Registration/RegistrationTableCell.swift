//
//  RegistrationTableCell.swift
//  GoTaxi
//
//  Created by Riaz on 22/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class RegistrationTableCell: UITableViewCell {
    @IBOutlet weak var inputTxtField: FloatingLabelTextField!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ActionButtonTableCell: UITableViewCell {
    @IBOutlet weak var actionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
