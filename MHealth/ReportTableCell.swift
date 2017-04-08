//
//  ReportTableCell.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/9/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class ReportTableCell: UITableViewCell {

    
    @IBOutlet weak var patientPhoto: UIImageView!
    
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var patientComment: UILabel!
    
    @IBOutlet weak var patientFever: UILabel!
    
    @IBOutlet weak var heartRate: UILabel!
    
    @IBOutlet weak var TimeStampReport: UILabel!
    
   @IBOutlet weak var bloodPressure: UILabel!
    
    
    var patientReportObject:PatientReport = PatientReport()
    var patientReportIndex:Int = 0
    var parentVC:ReportsTVC?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        patientPhoto.layer.borderWidth = 2.0
        patientPhoto.layer.masksToBounds = true
        patientPhoto.layer.borderColor = Customization().UIColorFromRGB(0x4C9DB9).CGColor
        patientPhoto.layer.cornerRadius = patientPhoto.frame.size.height/2
        // Initialization code
    }
    
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   
}
