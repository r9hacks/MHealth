//
//  ReportTableCell.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/9/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class ReportTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var rightSideLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   
}
