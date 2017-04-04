//
//  PatientPRofileVC.swift
//  MHealth
//
//  Created by Entisar on 4/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class PatientProfileVC: UIViewController {
    
    
    @IBOutlet weak var patientReportsList: UITableView!
    var ReportsList:String?

   
    @IBOutlet weak var patientImage: UIImageView!
    var Image:String!
    
    @IBOutlet weak var patientName: UILabel!
    var Name:String?
    
    @IBOutlet weak var patientBDay: UILabel!
    var BDay:String?

    @IBOutlet weak var patientMedications: UILabel!
    var Medications:String?
    
    @IBOutlet weak var patientBloodType: UILabel!
    var BloodType:String?
    
    
    @IBOutlet weak var patientDDiabities: UILabel!
    var Diabities:Bool! = true
    
    @IBOutlet weak var patientAllergies: UILabel!
    var Allergies:String?
    
    @IBOutlet weak var patientAsthma: UILabel!
    var Asthma:Bool! = true
    
    @IBOutlet weak var patientGender: UILabel!
    var Gender:String?
    
    @IBOutlet weak var patientPhone: UILabel!
    var Phone:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        patientName.text = Name
        patientBDay.text = BDay
        
        patientMedications.text = Medications
        patientBloodType.text = BloodType
        
        patientAllergies.text = Allergies
        patientGender.text = Gender
        patientPhone.text = Phone
        
        patientAsthma.text = "\(Asthma)"
        
        patientDDiabities.text = "\(Diabities)"
        
        let url:NSURL = NSURL(string: Image)!
        
        patientImage.sd_setImageWithURL(url,placeholderImage: UIImage(named: "profileImage"))

        
        patientImage.layer.borderWidth = 2.0
        
        patientImage.layer.masksToBounds = true
        patientImage.layer.borderColor = Customization().UIColorFromRGB(0x4C9DB9).CGColor
        patientImage.layer.cornerRadius = patientImage.frame.size.height/2
       
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
