//
//  InvitationsTVC.swift
//  MHealth
//
//  Created by Entisar on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner

class InvitationsTVC: UITableViewController, NetworkCaller {

    var InvitationReq:NSArray = NSArray()
    var selectedPatientLinked:NSDictionary?
    
    func setDictResponse(resp:NSDictionary, reqId:Int){
       
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
        
        
        let cell = UITableViewCell()
        
        let patient:NSDictionary = InvitationReq.objectAtIndex(indexPath.row) as! NSDictionary
        
        let fname:String = (patient.objectForKey("firstName") as! String)
        let mname:String = (patient.objectForKey("middleName") as! String)
        let lname:String = (patient.objectForKey("lastName") as! String)
        
        
        cell.textLabel?.text = fname + " " + mname + " " + lname
        
        return cell
        
        
        
    }

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("User clicked at cell - section \(indexPath.section) and row \(indexPath.row)")
        
        
        if selectedPatientLinked != nil {
            return
        }
        
        
        let patient:NSDictionary = InvitationReq.objectAtIndex(indexPath.row) as! NSDictionary
        
//        let pId = patient.valueForKey("patientId")
//        
//        selectedPatientLinked = patient
//        selectedIndex = indexPath.row
//        SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
//        networkManager.AMGetDictData(Const.URLs.Patient+"/\(pId!)", params: [:], reqId: 1, caller: self)
//        
//        print("paint id is \(pId)")
//        
        let nextScreen:InvitationAcceptVC = self.storyboard?.instantiateViewControllerWithIdentifier("InvitationController") as! InvitationAcceptVC
        
        nextScreen.patientLinkedIndex = indexPath.row
        nextScreen.patientLinked = patient
        
        nextScreen.parentVC = self
        // 2. Obtain object of the navigation controller
        let navCon:UINavigationController = self.navigationController!
        
        
        // 3. push next screen into the navigation controller
        navCon.pushViewController(nextScreen, animated: true)
        
        self.selectedPatientLinked = nil
        
        
    }
    
    func updatePatientLinkedList() {
        
        let drId:Int = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.doctorID) as! Int
        
        //let status:Int = 0
        SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
        //networkManager.AMJSONArray(Const.URLs.getLinkPatient, httpMethod: "POST", jsonData: ["drId":drId, "status":status], reqId: 1, caller: self)
        self.selectedPatientLinked = nil
        networkManager.AMGetArrayData(Const.URLs.PendingRequest + "\(drId)", params: [:], reqId: 1, caller: self)
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
