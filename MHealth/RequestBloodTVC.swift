//
//  RequestBloodTVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/9/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper
class RequestBloodTVC: UITableViewController,NetworkCaller {

    struct list {
        static var bloodRequestsList:NSMutableArray = NSMutableArray()
    }
    
    let networkManager:Networking = Networking()

    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        SwiftSpinner.hide()
       
        print (resp)
        list.bloodRequestsList.removeAllObjects()
        for item in resp {
            
            let dictItem = item as! NSDictionary
            
            let newBloodRequest:BloodRequests = BloodRequests()
            
            newBloodRequest.loadDictionary(dictItem)
            
            list.bloodRequestsList.addObject(newBloodRequest)
        }
        
        self.tableView.reloadData()
    }
    
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        
    }
    
    func loadData(){
        
        
        let drId:Int = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.doctorID) as! Int
        let url:String = Const.URLs.GetDoctorRequests + "\(drId)"
        
        let params:[String:AnyObject] = [:]
        
        let requestId = 0
        
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            networkManager.AMGetArrayData(url, params: params, reqId: requestId, caller: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.registerNib(UINib(nibName: "BloodRequestCellTableViewCell", bundle: nil), forCellReuseIdentifier: "BloodRequestCellTableViewCell")
        
        
       // self.tabBarController?.tabBar.tintColor = UIColor.redColor()
        
    }

    override func viewDidAppear(animated: Bool) {
        loadData()
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
        return list.bloodRequestsList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell:BloodRequestCellTableViewCell = (tableView.dequeueReusableCellWithIdentifier("BloodRequestCellTableViewCell") as? BloodRequestCellTableViewCell)!
        // Configure the cell...

        let newBloodRequest:BloodRequests = list.bloodRequestsList.objectAtIndex(indexPath.row) as! BloodRequests
        
        
        
        cell.quantityLabel.text = NSLocalizedString("Quantity", comment: "") + "\(newBloodRequest.quantity)"
        
        cell.reasonLabel.text = NSLocalizedString("Reason", comment: "") + "\(newBloodRequest.reason)"
        
        
        //      NSLocalizedString("Pending", comment: "")
        if newBloodRequest.status == 1 {
            cell.statusLabel.text = NSLocalizedString("Available", comment: "")
        }else if newBloodRequest.status == -1 {
            cell.statusLabel.text = NSLocalizedString("Not Available", comment: "")
        }else{
            cell.statusLabel.text = NSLocalizedString("Pending", comment: "")
        }
        
        if newBloodRequest.bloodType == "A+" {
            cell.bloodTypeImage.image = UIImage(named: "a_plus")
        }else if newBloodRequest.bloodType == "A-" {
            cell.bloodTypeImage.image = UIImage(named: "a_minus")
        }else if newBloodRequest.bloodType == "B+" {
            cell.bloodTypeImage.image = UIImage(named: "b_plus")
        }else if newBloodRequest.bloodType == "B-" {
            cell.bloodTypeImage.image = UIImage(named: "b_minus")
        }else if newBloodRequest.bloodType == "AB+" {
            cell.bloodTypeImage.image = UIImage(named: "ab_plus")
        }else if newBloodRequest.bloodType == "AB-" {
            cell.bloodTypeImage.image = UIImage(named: "ab_minus")
        }else if newBloodRequest.bloodType == "O+" {
            cell.bloodTypeImage.image = UIImage(named: "o_plus")
        }else{
            cell.bloodTypeImage.image = UIImage(named: "o_minus")
        }
        
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell:BloodRequestCellTableViewCell = (tableView.dequeueReusableCellWithIdentifier("BloodRequestCellTableViewCell") as? BloodRequestCellTableViewCell)!
        
        
        return cell.frame.size.height
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
