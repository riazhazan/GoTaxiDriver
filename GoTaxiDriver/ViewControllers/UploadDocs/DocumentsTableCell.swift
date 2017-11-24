//
//  DocumentsTableCell.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class DocumentsTableCell: UITableViewCell {

    @IBOutlet weak var statusIconImgView: UIImageView!
    @IBOutlet weak var documentTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DocumentsHeaderCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.text = NSLocalizedString("DOCS_TITLE", comment: "")
        subTitleLbl.text = NSLocalizedString("DOCS_SUBTITLE", comment: "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
