//
//  ReportDetailsTVC.swift
//  MHealth
//
//  Created by trn24 on 3/7/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class ReportDetailsTVC: UITableViewController {
    
    var parentVC:ReportsTVC?
    
    var currentIndex = 0

    var currentPatientReport:PatientReport?
    
    var reportTitles:[String] = [NSLocalizedString("Blood pressure ", comment: ""),
                                 NSLocalizedString("Heart rate ", comment: ""),
                                 NSLocalizedString("Sugar level ", comment: ""),
                                 NSLocalizedString("Fever ", comment: ""),
                                 NSLocalizedString("Caughing ", comment: ""),
                                 NSLocalizedString("Dizziness ", comment: ""),
                                 NSLocalizedString("Nauseous ", comment: ""),
                                 NSLocalizedString("Headache ", comment: "")]
    
    
    
    var reportIcons:[String] = ["bloodPressure","cardiogram","diabetes",
                                "fever","cough","dizziness",
                                "nauseous","headache","painn"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIBarButtonItem(image: nil, style: .Plain, target: self, action: #selector(openReplyController))
        button1.title = NSLocalizedString("Reply", comment: "")
        
        self.navigationItem.rightBarButtonItem = button1

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if (self.currentPatientReport?.pain) == true {
            reportTitles.append(NSLocalizedString("Pain location: ", comment: ""))
        }
        
    }

    func openReplyController()  {
        print("open Reply controleer")
        
        let reply:ReplyTVC = self.storyboard?.instantiateViewControllerWithIdentifier("ReplyController") as! ReplyTVC
        reply.parentVC = self
        reply.currentReport = self.currentPatientReport
        reply.reportIndex = self.currentIndex
        self.navigationController?.pushViewController(reply, animated: true)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return reportTitles.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

//    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

//         Configure the cell...

        let cell:UITableViewCell = UITableViewCell()
        let array:NSArray = (currentPatientReport?.toArray())!
        let theSelected:String = array.objectAtIndex(indexPath.section) as! String
        cell.textLabel?.text = theSelected
        cell.imageView?.image = UIImage(named:reportIcons[indexPath.section])
        return cell
    
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return reportTitles[section]
    }

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
    
    func updateReportAtIndex(index:Int, reportID:Int, report:PatientReport){
        self.currentPatientReport = report
        self.tableView.reloadData()
        self.parentVC?.updateReportAtIndex(index, reportID: reportID, report: report)
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
