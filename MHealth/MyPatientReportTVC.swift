//
//  MyPatientReportTVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class MyPatientReportTVC: UITableViewCell {

    
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var heartRate: UILabel!
    
    @IBOutlet weak var bloodPressure: UILabel!
    
    @IBOutlet weak var fever: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
