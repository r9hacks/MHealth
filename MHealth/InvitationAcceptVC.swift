//
//  InvitationAcceptVC.swift
//  MHealth
//
//  Created by Entisar on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner

class InvitationAcceptVC: UIViewController, NetworkCaller {
    
 
    //let tabArray = tabBarController?.tabBar.items![0].badgeValue
    
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var nationalityText: UITextField!
    
    @IBOutlet weak var acceptOutlet: UIButton!
    
    @IBOutlet weak var declineOutlet: UIButton!
    
    @IBOutlet weak var birthdayText: UITextField!
    
    
    @IBOutlet weak var emailText: UITextField!
    
    var patientLinked:NSDictionary?
    var patientLinkedIndex:Int?
    var parentVC:InvitationsTVC?
    let networkManager:Networking = Networking()

    @IBAction func AcceptButton(sender: AnyObject) {
        
        let updatedLinkedPatient:NSMutableDictionary = (self.patientLinked!).mutableCopy() as! NSMutableDictionary
        
        updatedLinkedPatient.setValue(1, forKey: "status")
        updatedLinkedPatient.removeObjectForKey("name")
        updatedLinkedPatient.removeObjectForKey("phone")
        updatedLinkedPatient.removeObjectForKey("nationality")
        updatedLinkedPatient.removeObjectForKey("email")
        updatedLinkedPatient.removeObjectForKey("bday")
        
        
        let linkID:Int = self.patientLinked?.valueForKey("linkId")! as! Int
        
        let url:String = Const.URLs.PatientDrLink + "/\(linkID)"
        SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
        self.networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: updatedLinkedPatient, reqId: 1, caller: self)
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    
    @IBAction func DeclineButton(sender: AnyObject) {
    
        let updatedLinkedPatient:NSMutableDictionary = (self.patientLinked!).mutableCopy() as! NSMutableDictionary
        
        updatedLinkedPatient.setValue(-1, forKey: "status")
        updatedLinkedPatient.removeObjectForKey("name")
        updatedLinkedPatient.removeObjectForKey("phone")
        updatedLinkedPatient.removeObjectForKey("nationality")
        updatedLinkedPatient.removeObjectForKey("email")
        updatedLinkedPatient.removeObjectForKey("bday")

        let linkID:Int = self.patientLinked?.valueForKey("linkId")! as! Int
        
        let url:String = Const.URLs.PatientDrLink + "/\(linkID)"
        SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
        self.networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: updatedLinkedPatient, reqId: 2, caller: self)
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
        
    }
    
    func setDictResponse(resp:NSDictionary, reqId:Int){
        SwiftSpinner.hide()
        
        if resp.allKeys.count > 0 {
            
            if reqId == 1 {
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't accept patient", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't decline patient", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        }else{
            parentVC?.updatePatientLinkedList()
            let alertControlle:UIAlertController;
            if reqId == 1 {
                 alertControlle = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Patient accept successful", comment: ""), preferredStyle: .Alert)
               
            }else{
                alertControlle = UIAlertController(title:  NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Patient declined successful", comment: ""), preferredStyle: .Alert)
            }
            
            let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                self.navigationController?.popViewControllerAnimated(true)
            })
            alertControlle.addAction(action)
            self.presentViewController(alertControlle, animated: true, completion: nil)
        }
        
    }
    
    func setArrayResponse(resp:NSArray, reqId:Int){
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        NameText.text = (patientLinked?.valueForKey("name") as! String)
        phoneText.text = (patientLinked?.valueForKey("phone") as! String)
        nationalityText.text = (patientLinked?.valueForKey("nationality") as! String)
        birthdayText.text = (patientLinked?.valueForKey("bday") as! String)
        emailText.text = (patientLinked?.valueForKey("email") as! String)
        
        Customization().customizeTextField(NameText)
        Customization().customizeTextField(phoneText)
        Customization().customizeTextField(nationalityText)
        Customization().customizeTextField(birthdayText)
        Customization().customizeTextField(emailText)
        
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
