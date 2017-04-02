//
//  ProfileVC.swift
//  MHealth
//
//  Created by trn24 on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var specialtyLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var updateProfileButton: UIButton!

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: Const.UserDefaultsKeys.drProfile)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: Const.UserDefaultsKeys.doctorID)
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func loadImage(u:String) {
        if Validator().verifyUrl(u) == false{
            return
        }
        let url:NSURL = NSURL(string: u)!
        
        let data:NSData = NSData(contentsOfURL: url)!
        
        let doctorPhoto:UIImage? = UIImage(data: data)
        if doctorPhoto != nil {
            self.photo.image = doctorPhoto
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Customization().addUnderLineToLabel(nameLabel)
        Customization().addUnderLineToLabel(specialtyLabel)
        Customization().addUnderLineToLabel(locationLabel)
        Customization().addUnderLineToLabel(emailLabel)
        Customization().addUnderLineToLabel(phoneLabel)
        
        // Do any additional setup after loading the view.
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        nameLabel.text = currentDoctor.firstName + " " + currentDoctor.middleName + " " + currentDoctor.lastName
        specialtyLabel.text = currentDoctor.specialty
        locationLabel.text = currentDoctor.location
        emailLabel.text = currentDoctor.email
        phoneLabel.text = currentDoctor.phoneNumber
        
        //loadImage(currentDoctor.imageUrl)
        //self.performSelectorInBackground(Selector(loadImage(currentDoctor.imageUrl)), withObject: currentDoctor.imageUrl)
        performSelector(#selector(loadImage), withObject: currentDoctor.imageUrl)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        nameLabel.text = currentDoctor.firstName + " " + currentDoctor.middleName + " " + currentDoctor.lastName
        specialtyLabel.text = currentDoctor.specialty
        locationLabel.text = currentDoctor.location
        emailLabel.text = currentDoctor.email
        phoneLabel.text = currentDoctor.phoneNumber

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
