//
//  PInvitationTableViewCell.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/2/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class PInvitationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var patientPhoto: UIImageView!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientCivilID: UILabel!
    @IBOutlet weak var patientBDay: UILabel!
    @IBOutlet weak var patientPhone: UILabel!
    @IBOutlet weak var patientNationality: UILabel!
    @IBOutlet weak var patientBloodType: UILabel!
    @IBOutlet weak var patientGender: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var patientObject:NSDictionary = NSDictionary()
    var patientIndex:Int = 0
    
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
