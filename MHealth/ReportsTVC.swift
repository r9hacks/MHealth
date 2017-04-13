//
//  ReportsTVC.swift
//  MHealth
//
//  Created by Entisar on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper
class ReportsTVC: UITableViewController,NetworkCaller, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var All:String = "All"
    var rate:String = "All"
    var pressure:String = "All"
    var fever:String = "All"
    
    var filteredList:NSMutableArray = NSMutableArray()
    
    var filterIsChosen = false
    
    var pickerView:UIPickerView = UIPickerView()
    var popoverView:UIView = UIView()
    var customView:CustomPickerView = CustomPickerView()
    
    var allRate = true
    var heartRate = ["All","High", "Low", "Moderate"]
    var bloodPressure = ["All","High", "Low", "Moderate"]
    var feverArray = ["All","Yes", "No"]
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return heartRate.count
        }
        else if component == 1 {
            return bloodPressure.count
        }
        else if component == 2 {
            return feverArray.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if component == 0 {
            
            return heartRate[row]
        }
        else if component == 1 {
            
            return bloodPressure[row]
        }
        else if component == 2 {
            
            return feverArray[row]
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        
        if component == 0 {
            print(heartRate[row])
            
            rate = heartRate[row]
            
        }
        else if component == 1 {
            pressure = bloodPressure[row]
            
        }
        else if component == 2 {
            fever = feverArray[row]
            
        }
        
        filterContentForPicker()
    }
    
    
    @IBOutlet weak var filterBar: UIBarButtonItem!
    
    
    @IBAction func filterBarButtonAction(sender: UIBarButtonItem) {
        
        if popoverView.tag == 0 {
            
            self.tableView.superview?.addSubview(popoverView)
            filterIsChosen = true
            popoverView.tag = 1
        }else{
            
            popoverView.removeFromSuperview()
//            filterIsChosen = false
            popoverView.tag = 0
            
        }
    }

    struct list {
        static var reportList:NSMutableArray = NSMutableArray()
    }
    
    
      //var selectedPatientLinked:NSDictionary?
    
    func loadData(){
        
        let url:String = Const.URLs.getReports
        
        let drId:Int = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.doctorID) as! Int
        
        let params:[String:AnyObject] = ["time": 0 , "drId": drId]
        
        let requestId = 0
        
        let networkManager:Networking = Networking()
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            
            networkManager.AMJSONArray(url, httpMethod: "POST", jsonData: params, reqId: requestId, caller: self )
        }
        
    }
    
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        SwiftSpinner.hide()
        // loop on resp .. get each dictionary .. convert to object .. add to list manager
        
        print (resp)
        list.reportList.removeAllObjects()
        for item in resp {
            
            let dictItem = item as! NSDictionary
            
            let newPatiet:PatientReport = PatientReport()
            
            newPatiet.loadDictionary(dictItem)
            
            list.reportList.addObject(newPatiet)
        }
        
        self.tableView.reloadData()
    }
    
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       // self.tableView.registerClass(ReportTableCell.self, forCellReuseIdentifier: "ReportTableCell")
        
        tableView.registerNib(UINib(nibName: "ReportTableCell", bundle: nil), forCellReuseIdentifier: "ReportTableCell")
        customView = CustomPickerView(frame: self.view.frame)
        customView.parentReportTVC = self
        popoverView = customView.view
        customView.pickerView.delegate = self
        popoverView.tag = 0
        
        //        popoverView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        
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
        if filterIsChosen {
            return filteredList.count
        }
            return list.reportList.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ReportTableCell
        
        //let cell:ReportTableCell = tableView.dequeueReusableCellWithIdentifier("ReportTableCell", forIndexPath: indexPath) as! ReportTableCell
        
        let cell:ReportTableCell = (tableView.dequeueReusableCellWithIdentifier("ReportTableCell") as? ReportTableCell)!
        
        var patientReport:PatientReport
        if filterIsChosen
        {
            patientReport = filteredList.objectAtIndex(indexPath.row) as! PatientReport
            print("Displaying User\(patientReport.name) with Id \(patientReport.reportId)")
        }else{
            patientReport = list.reportList.objectAtIndex(indexPath.row) as! PatientReport
            
        }
        
        // to valid img link
        if Validator().verifyUrl(patientReport.img){
            
            let url:NSURL = NSURL(string: patientReport.img)!
            cell.patientPhoto.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profileImage"))
            
        }
        
        cell.patientName.text = patientReport.name
        cell.patientComment.text = patientReport.comments
        cell.patientFever.text = patientReport.fever
        
        cell.bloodPressure.text = patientReport.bloodPressure
        cell.heartRate.text = patientReport.heartbeatRate
      
        let time = relativeDateStringForDate(createDate(patientReport.timestamp)) as String
        cell.TimeStampReport.text = time

            //relativeDateStringForDate(createDate(patientReport.timestamp) as String
            // cell.rightSideLabel.text = relativeDateStringForDate(createDate(currentPatient.timestamp)) as String
            //
          //  patientReport.timestamp
        
        cell.patientReportObject = patientReport
        cell.patientReportIndex = indexPath.row
//        cell.parentVC = self

        return cell
        
        // Configure the cell...
        
        //return cell
        
        
        //let cell:UITableViewCell = UITableViewCell()
        
//        let currentItem = list.reportList.objectAtIndex(indexPath.row)
//        
//        let currentPatient:PatientReport = currentItem as! PatientReport
//        
//        //cell.textLabel?.text = "\(currentPatient.name)"
//        cell.titleLabel.text = "\(currentPatient.name)"
//        cell.subtitleLabel.text = "\(NSLocalizedString("comment: ", comment: "")) \(currentPatient.comments)"
//        cell.rightSideLabel.text = relativeDateStringForDate(createDate(currentPatient.timestamp)) as String
//        return cell
    }
    
    func createDate(stringDate:String) -> NSDate {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        //dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormater.dateFromString(stringDate) else{
            return NSDate()
        }
        return date
        
    }
    
    func relativeDateStringForDate(date : NSDate) -> NSString {
        
        let todayDate = NSDate()
        let units: NSCalendarUnit = [.Year, .Day, .Month, .Hour, .Minute, .Second]
        let components = NSCalendar.currentCalendar().components(units, fromDate: date , toDate: todayDate, options: NSCalendarOptions.MatchFirst )
        
        //let year =  components.year
        //let month = components.month
        //let day = components.day
        let hour = components.hour
        //let weeks = components.weekOfYear
        // if `date` is before "now" (i.e. in the past) then the components will be positive
        
        let dateFormatter = NSDateFormatter()
        //dateFormatter.calendar   = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        //let dateToDisplay = dateFormatter.calendar.dateFromComponents(components)
        
        
        dateFormatter.dateFormat = "dd/MM/yy"
        let convertedDate = dateFormatter.stringFromDate(date)
        print(convertedDate)
        if components.year > 0 {
            //return NSString.init(format: "%d years ago", year);
            return NSString.init(format: convertedDate);
        } else if components.month > 0 {
            //return NSString.init(format: "%d months ago", month);
            return NSString.init(format: convertedDate);
        } else if components.weekOfYear > 0 {
            //return NSString.init(format: "%d weeks ago", weeks);
            return NSString.init(format: convertedDate);
        } else if (components.day > 0) {
            if components.day > 1 {
                
                return NSString.init(format: convertedDate);
            } else {
                return NSLocalizedString("Yesterday", comment: "");
            }
        } else {
            return NSString.init(format: "%d \(NSLocalizedString("hours ago", comment: ""))", hour);
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("selected cell at section:\(indexPath.section) and row:\(indexPath.row)")
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let nextScreen:ReportDetailsTVC = self.storyboard?.instantiateViewControllerWithIdentifier("ReportDetailsID") as! ReportDetailsTVC
        
        var newPatientReport:PatientReport
            
        if filterIsChosen
        {
            newPatientReport = filteredList.objectAtIndex(indexPath.row) as! PatientReport
        }else{
            
            newPatientReport = list.reportList.objectAtIndex(indexPath.row) as! PatientReport
        }
       
        
        nextScreen.currentIndex = indexPath.row


        nextScreen.currentPatientReport = newPatientReport
        nextScreen.parentVC = self
        
        self.navigationController?.pushViewController(nextScreen, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(NSLocalizedString("Report Numbers:", comment: "")) \(list.reportList.count)"
        
    }
    
//    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "\(NSLocalizedString("Report Number:", comment: "")) \(list.reportList.count)"
//    
//    }
    
    func updateReportAtIndex(index:Int, reportID:Int, report:PatientReport) {
        
        list.reportList.replaceObjectAtIndex(index, withObject: report)
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        let cell:ReportTableCell = (tableView.dequeueReusableCellWithIdentifier("ReportTableCell") as? ReportTableCell)!
        
        
        return cell.frame.size.height
    }
    
    func filterContentForPicker() {
        
        let filterList:AnyObject = list.reportList.filter({ (patientObj) -> Bool in
            
            let patient:PatientReport = patientObj as! PatientReport
            
            if ( rate == "All" && pressure == "All" && fever == "All")
            {
                return true
            }
            else if (rate == "All" && pressure == "All" && fever != "All"){
                if (patient.fever.lowercaseString.containsString(self.fever.lowercaseString) )
                {
                    return true
                }
            }
            
            else if (rate == "All" && pressure != "All" && fever != "All"){
                if ( patient.bloodPressure.lowercaseString.containsString(self.pressure.lowercaseString) && patient.fever.lowercaseString.containsString(self.fever.lowercaseString) )
                {
                    return true
                }
            }
            
            else if (rate == "All" && pressure != "All" && fever == "All"){
                if ( patient.bloodPressure.lowercaseString.containsString(self.pressure.lowercaseString))
                {
                    return true
                }
            }
            
            
            else if (rate != "All" && pressure == "All" && fever == "All"){
                if ( patient.heartbeatRate.lowercaseString.containsString(self.rate.lowercaseString))
                {
                    return true
                }
            }
                
            else if (rate != "All" && pressure != "All" && fever == "All"){
                if ( patient.heartbeatRate.lowercaseString.containsString(self.rate.lowercaseString) && patient.bloodPressure.lowercaseString.containsString(self.pressure.lowercaseString))
                {
                    return true
                }
            }
            
                
            else if (rate != "All" && pressure == "All" && fever != "All"){
                if ( patient.heartbeatRate.lowercaseString.containsString(self.rate.lowercaseString) && patient.fever.lowercaseString.containsString(self.fever.lowercaseString))
                {
                    return true
                }
            }
            
            
            
            
            
            
            //last one
            else if (patient.heartbeatRate.lowercaseString.containsString(self.rate.lowercaseString) && patient.bloodPressure.lowercaseString.containsString(self.pressure.lowercaseString) && patient.fever.lowercaseString.containsString(self.fever.lowercaseString) )
            {
//                print("true ")
//                print(patient.reportId)
                return true
            }
//            else if ( rate == "All" && pressure == "All" && fever == "All")
//            {
//                return true
//            }
//            else if ( rate == "All" && patient.bloodPressure.lowercaseString.containsString(self.pressure.lowercaseString) && fever == "All")
//            
//            {
//                return true
//            }
//            else if ( rate == "All" && patient.bloodPressure.lowercaseString.containsString(self.pressure.lowercaseString) && patient.fever.lowercaseString.containsString(self.fever.lowercaseString))
//                
//            {
//                return true
//            }
//            else if ( rate == "All" && pressure == "All" && patient.fever.lowercaseString.containsString(self.fever.lowercaseString))
//                
//            {
//                return true
//            }
//    

            return false
            
        })

        filteredList = filterList.mutableCopy() as! NSMutableArray
        
        
        tableView.reloadData()
        
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
