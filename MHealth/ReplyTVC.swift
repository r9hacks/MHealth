//
//  ReplyTVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/9/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper
class ReplyTVC: UITableViewController,NetworkCaller, UITextViewDelegate {

    
    @IBOutlet weak var patientCommentBox: UITextView!
    
    @IBOutlet weak var RecommendationBox: UITextView!
    
    @IBOutlet weak var replayOutlet: UIButton!
    
    var currentReport:PatientReport?
    var reportIndex:Int?
    
    var parentVC:ReportDetailsTVC?
    
    
    let networkManager:Networking = Networking()
    
    @IBAction func sendRecButton(sender: UIButton) {
        
        if sender.tag == 1{
            
            self.RecommendationBox.editable = true
            sender.setTitle("Send reply", forState: UIControlState.Normal)
            sender.tag = 0
            
        }else if sender.tag == 0{
            
            self.RecommendationBox.editable = false
            sender.setTitle("Edit reply", forState: UIControlState.Normal)
            sender.tag = 1
            
            if RecommendationBox.text == "" {
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Recommendation Can't be empty", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            //        self.replayOutlet.enabled = false
            let parameter:NSMutableDictionary = NSMutableDictionary()
            parameter.setValue(currentReport?.reportId, forKey: "reportId")
            parameter.setValue(RecommendationBox.text, forKey: "drcomment")
            
            let reach = Reach()
            
            print ("Connection status!!!!!!!:")
            
            
            if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
                let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
                Whisper(message, to: self.navigationController!, action: .Show)
                Silent(self.navigationController!, after: 3.0)
            }else{
                
                SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

                networkManager.AMJSONDictionary(Const.URLs.updateReportRec, httpMethod: "POST", jsonData: parameter, reqId: 1, caller: self)
            }
            
        }
    }
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        
    }
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        SwiftSpinner.hide()
        print(resp)
//        self.replayOutlet.enabled = true
        
        var alert:UIAlertController;
        if resp.valueForKey("status") != nil {
            if (resp.valueForKey("status") as! Bool) == true {
                
                alert = Alert().getAlert(NSLocalizedString("Updated", comment: ""), msg: NSLocalizedString("Reply is sent", comment: ""))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.currentReport?.drcomment = self.RecommendationBox.text
                updateReport()
                return
            }
            
        }
        
        alert = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't send Reply", comment: ""))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateReport() {
        self.parentVC?.updateReportAtIndex(self.reportIndex!, reportID: (self.currentReport?.reportId)!, report: self.currentReport!)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.patientCommentBox.text = self.currentReport?.comments
        self.RecommendationBox.text = self.currentReport?.drcomment
        
        if self.currentReport?.drcomment != "" {
        
            self.RecommendationBox.editable = false
            replayOutlet.setTitle("Edit reply", forState: UIControlState.Normal)
            replayOutlet.tag = 1
        
        }else{
         
            replayOutlet.setTitle("Send reply", forState: UIControlState.Normal)
            replayOutlet.tag = 0
        
        }
        
        RecommendationBox.delegate = self
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
