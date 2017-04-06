//
//  MyPatientTVCell.swift
//  MHealth
//
//  Created by Entisar on 4/3/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class MyPatientTVCell: UITableViewCell {
    
    
    
    @IBOutlet weak var patientPhoto: UIImageView!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientPhone: UILabel!
    
    @IBOutlet weak var patientBDay: UILabel!
    
    @IBOutlet weak var patientGender: UILabel!
    @IBOutlet weak var patientBloodType: UILabel!
    
    
    var myPatientsObject:Patient = Patient()
    
    var myPatientsIndex:Int = 0
    var parentVC:MyPatientTVC?
    
    
    @IBAction func makeACall(sender: UIButton) {
        
        if let url = NSURL(string: "telprompt://\(self.patientPhone.text!)") {
            //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        patientPhoto.layer.borderWidth = 2.0
        patientPhoto.layer.masksToBounds = true
        patientPhoto.layer.borderColor = Customization().UIColorFromRGB(0x4C9DB9).CGColor
        patientPhoto.layer.cornerRadius = patientPhoto.frame.size.height/2
        
        
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
