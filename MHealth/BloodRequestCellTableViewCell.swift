//
//  BloodRequestCellTableViewCell.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/10/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class BloodRequestCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bloodTypeImage: UIImageView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
