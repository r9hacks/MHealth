//
//  InvitationAcceptVC.swift
//  MHealth
//
//  Created by Entisar on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper

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
        
        let updatedLinkedPatient:NSMutableDictionary = NSMutableDictionary()
        
        let addingTime:String = (patientLinked!.objectForKey("addingTime") as! String)
        let drId:Int = (patientLinked!.objectForKey("drId") as! Int)
        let patientId:Int = (patientLinked!.objectForKey("patientId") as! Int)
        let linkId:Int = (patientLinked!.objectForKey("linkId") as! Int)
        
        updatedLinkedPatient.setValue(1, forKey: "status")
        updatedLinkedPatient.setValue(addingTime, forKey: "addingTime")
        updatedLinkedPatient.setValue(drId, forKey: "drId")
        updatedLinkedPatient.setValue(patientId, forKey: "patientId")
        updatedLinkedPatient.setValue(linkId, forKey: "linkId")
        
        let url:String = Const.URLs.UpdateRequestStatus + "\(linkId)"
        print(updatedLinkedPatient)
        print(url)
        
        let reach = Reach()
        print ("Connection status!!!!!!!:")
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
            
            
            self.networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: updatedLinkedPatient, reqId: 1, caller: self)
        }
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    
    @IBAction func DeclineButton(sender: AnyObject) {
    
        let updatedLinkedPatient:NSMutableDictionary = NSMutableDictionary()
        
        let addingTime:String = (patientLinked!.objectForKey("addingTime") as! String)
        let drId:Int = (patientLinked!.objectForKey("drId") as! Int)
        let patientId:Int = (patientLinked!.objectForKey("patientId") as! Int)
        let linkId:Int = (patientLinked!.objectForKey("linkId") as! Int)
        
        updatedLinkedPatient.setValue(-1, forKey: "status")
        updatedLinkedPatient.setValue(addingTime, forKey: "addingTime")
        updatedLinkedPatient.setValue(drId, forKey: "drId")
        updatedLinkedPatient.setValue(patientId, forKey: "patientId")
        updatedLinkedPatient.setValue(linkId, forKey: "linkId")
        
        let url:String = Const.URLs.UpdateRequestStatus + "\(linkId)"
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            self.networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: updatedLinkedPatient, reqId: 2, caller: self)
        }
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
        
    }
    
    func setDictResponse(resp:NSDictionary, reqId:Int){
        SwiftSpinner.hide()
        print(resp)
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
        let fname:String = (patientLinked!.objectForKey("firstName") as! String)
        let mname:String = (patientLinked!.objectForKey("middleName") as! String)
        let lname:String = (patientLinked!.objectForKey("lastName") as! String)
        
        
        NameText.text = fname + " " + mname + " " + lname
        phoneText.text = (patientLinked?.valueForKey("phoneNumber") as! String)
        nationalityText.text = (patientLinked?.valueForKey("nationality") as! String)
        birthdayText.text = (patientLinked?.valueForKey("dateOfBirth") as! String)
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
