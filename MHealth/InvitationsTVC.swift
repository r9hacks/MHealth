//
//  InvitationsTVC.swift
//  MHealth
//
//  Created by Entisar on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import SDWebImage
import Whisper

class InvitationsTVC: UITableViewController, NetworkCaller {

    var InvitationReq:NSArray = NSArray()
    var selectedPatientLinked:NSDictionary?
    
    func setDictResponse(resp:NSDictionary, reqId:Int){
        SwiftSpinner.hide()
        print(resp)
        if resp.allKeys.count > 0 {
            
            if reqId == 2 {
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't accept patient", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
            }else {
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't decline patient", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        }else{
            
            let alertControlle:UIAlertController;
            if reqId == 2 {
                alertControlle = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Patient accept successful", comment: ""), preferredStyle: .Alert)
                
            }else {
                alertControlle = UIAlertController(title:  NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Patient declined successful", comment: ""), preferredStyle: .Alert)
            }
            
            let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                self.navigationController?.popViewControllerAnimated(true)
            })
            alertControlle.addAction(action)
            self.presentViewController(alertControlle, animated: true, completion: nil)
            updatePatientLinkedList()

        }
    }
    
    func setArrayResponse(resp:NSArray, reqId:Int){
        SwiftSpinner.hide()
        InvitationReq =  resp
        print(resp)
        tableView.reloadData()
        
        if self.InvitationReq.count == 0 {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Note", comment: ""), msg: NSLocalizedString("You don't have any pending request.", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil

        }else{
            self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = "\(InvitationReq.count)"
        }
    }
    
    //
    var PatientReqProfile:NSMutableArray = NSMutableArray()
    
    let networkManager:Networking = Networking()
    
    // let doctor:Doctor = Doctor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.registerNib(UINib(nibName: "PInvitationTableViewCell", bundle: nil), forCellReuseIdentifier: "PInvitationTableViewCell")
        
       // self.tabBarController?.tabBar.tintColor = UIColor.orangeColor()
        
        
    }
    override func viewDidAppear(animated: Bool) {
          updatePatientLinkedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return InvitationReq.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PInvitationTableViewCell = (tableView.dequeueReusableCellWithIdentifier("PInvitationTableViewCell") as? PInvitationTableViewCell)!
        
        //let cell = UITableViewCell()
        
        let patient:NSDictionary = InvitationReq.objectAtIndex(indexPath.row) as! NSDictionary
        
        
        let fname:String = (patient.objectForKey("firstName") as! String)
        let mname:String = (patient.objectForKey("middleName") as! String)
        let lname:String = (patient.objectForKey("lastName") as! String)
        
        var gender:String = (patient.objectForKey("gender") as! String)
        if gender.characters.first == "f" || gender.characters.first == "F" {
            gender = "Female"
        }else{
            gender = "Male"
        }
        
        
        // to valid img link
        let img = patient.objectForKey("imageUrl") as! String
        
        if Validator().verifyUrl(img)
        {
            let url:NSURL = NSURL(string: img)!
            cell.patientPhoto.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profileImage"))
        }
        

        cell.patientName.text = fname + " " + mname + " " + lname
        cell.patientBDay.text = (patient.objectForKey("dateOfBirth") as! String)
        cell.patientPhone.text = (patient.objectForKey("phoneNumber") as! String)
        cell.patientGender.text = gender
        cell.patientCivilID.text = (patient.objectForKey("civilId") as! String)
        cell.patientBloodType.text = (patient.objectForKey("bloodType") as! String)
        cell.patientNationality.text = (patient.objectForKey("nationality") as! String)
        cell.patientObject = patient
        cell.patientIndex = indexPath.row
        cell.parentVC = self
        cell.selectionStyle = .None
        
        return cell
        
        
        
    }
    
    func acceptPatientButton(index:Int) {
        print("accept")
        let patient:NSDictionary = InvitationReq.objectAtIndex(index) as! NSDictionary
        
        let updatedLinkedPatient:NSMutableDictionary = NSMutableDictionary()
        
        let addingTime:String = (patient.objectForKey("addingTime") as! String)
        let drId:Int = (patient.objectForKey("drId") as! Int)
        let patientId:Int = (patient.objectForKey("patientId") as! Int)
        let linkId:Int = (patient.objectForKey("linkId") as! Int)
        
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
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            self.networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: updatedLinkedPatient, reqId: 2, caller: self)
        }
        
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
        
    }
    
    func declinePatientButton(index:Int) {
        print("declined")
        
        let patient:NSDictionary = InvitationReq.objectAtIndex(index) as! NSDictionary
        
        let updatedLinkedPatient:NSMutableDictionary = NSMutableDictionary()
        
        let addingTime:String = (patient.objectForKey("addingTime") as! String)
        let drId:Int = (patient.objectForKey("drId") as! Int)
        let patientId:Int = (patient.objectForKey("patientId") as! Int)
        let linkId:Int = (patient.objectForKey("linkId") as! Int)
        
        updatedLinkedPatient.setValue(-1, forKey: "status")
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
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            
            self.networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: updatedLinkedPatient, reqId: 3, caller: self)
        }
        self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell:PInvitationTableViewCell = (tableView.dequeueReusableCellWithIdentifier("PInvitationTableViewCell") as? PInvitationTableViewCell)!
        
        return cell.frame.size.height
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    func updatePatientLinkedList() {
        
        let drId:Int = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.doctorID) as! Int
        
        //let status:Int = 0
        //networkManager.AMJSONArray(Const.URLs.getLinkPatient, httpMethod: "POST", jsonData: ["drId":drId, "status":status], reqId: 1, caller: self)
        self.selectedPatientLinked = nil
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            networkManager.AMGetArrayData(Const.URLs.PendingRequest + "\(drId)", params: [:], reqId: 1, caller: self)
            
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
