//
//  MyPatientTVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/2/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

import SwiftSpinner
import Whisper

import SystemConfiguration
import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class MyPatientTVC: UITableViewController, NetworkCaller, UISearchResultsUpdating  {
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredList:NSMutableArray = NSMutableArray()
    
    
    
    struct list {
        static var myPatientsList:NSMutableArray = NSMutableArray()
    }
    
    let networkManager:Networking = Networking()
    
    
    func loadData(){
        
        
        let drId:Int = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.doctorID) as! Int
        
        let url:String = Const.URLs.MyPatient + "\(drId)"
        
        
        
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
            
            networkManager.AMGetArrayData(url, params: [:], reqId: 1, caller: self)
        }
        
        
    }
    
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        SwiftSpinner.hide()
        // loop on resp .. get each dictionary .. convert to object .. add to list manager
        
        if resp.count == 1{
            if let isError:String = resp.firstObject as? String {
                if isError == "Error" {
                    //SwiftSpinner.hide();
                    let alert:UIAlertController = Alert().getAlert("Error", msg: "Connection Failed.")
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    return
                }
            }
        }
        
        print (resp)
        list.myPatientsList.removeAllObjects()
        for item in resp {
            
            let dictItem = item as! NSDictionary
            
            let myPatients:Patient = Patient()
            
            myPatients.loadDictionary(dictItem)
            
            list.myPatientsList.addObject(myPatients)
        }
        
        self.tableView.reloadData()
    }
    
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        print("resp")
        print(resp)
        SwiftSpinner.hide()
        if reqId == 2 {
            if resp.allKeys.count != 0 {
                //error
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Connection Failed", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if searchController.active && searchController.searchBar.text != "" {
                
                filteredList.removeObject(deletedPatient)
                list.myPatientsList.removeObject(deletedPatient)
                self.tableView.deleteRowsAtIndexPaths([deletedIndexPath], withRowAnimation: .Automatic)
            }else{
                
                list.myPatientsList.removeObject(deletedPatient)
                self.tableView.deleteRowsAtIndexPaths([deletedIndexPath], withRowAnimation: .Automatic)
                
            }
            deletedPatient = Patient()
            deletedIndexPath = NSIndexPath()
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        //        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        //
        //        searchController.searchBar.sizeToFit()
        //
        
        
        tableView.registerNib(UINib(nibName: "MyPatientTVCell", bundle: nil), forCellReuseIdentifier: "MyPatientTVCell")
        
        // self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        
        
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    //
    //    override func viewDidDisappear(animated: Bool) {
    //
    //        [self.searchController setActive:NO animated:NO];
    //    }
    
    
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
        
        if searchController.active && searchController.searchBar.text != "" {
            return filteredList.count
        }
        
        return list.myPatientsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:MyPatientTVCell = (tableView.dequeueReusableCellWithIdentifier("MyPatientTVCell") as? MyPatientTVCell)!
        
        var myPatient:Patient
        
        if searchController.active && searchController.searchBar.text != "" {
            
            myPatient = filteredList.objectAtIndex(indexPath.row) as! Patient
            
        }else{
            
            myPatient = list.myPatientsList.objectAtIndex(indexPath.row) as! Patient
            
        }
        print("***")
        
        print(myPatient.email)
        var gender:String =  myPatient.gender
        if gender.characters.first == "f" || gender.characters.first == "F" {
            gender = "Female"
            
        }else{
            gender = "Male"
        }
        
        // valid img link
        let img = myPatient.valueForKey("imageUrl") as! String
        
        if !img.containsString("http"){
            cell.patientPhoto.image = UIImage(named: "profileImage")
            
        }
        else
        {
            let url:NSURL = NSURL(string: img)!
            cell.patientPhoto.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profileImage"))
        }
        
        
        //
        //        if Validator().verifyUrl(myPatient.imageUrl)
        //        {
        //            let url:NSURL = NSURL(string: myPatient.imageUrl)!
        //            cell.patientPhoto.sd_setImageWithURL(url, placeholderImage: UIImage(named: "profileImage"))
        //        }
        
        let fname:String = myPatient.firstName
        let mname:String = myPatient.middleName
        let lname:String = myPatient.lastName
        
        cell.patientName.text = fname + " " + mname + " " + lname
        
        cell.patientGender.text = gender
        
        cell.patientBDay.text = myPatient.dateOfBirth
        
        cell.patientPhone.text = myPatient.phoneNumber
        
        cell.patientBloodType.text = myPatient.bloodType
        
        cell.myPatientsObject = myPatient
        cell.myPatientsIndex = indexPath.row
        //        cell.parentVC = self
        
        return cell
        
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell:MyPatientTVCell = (tableView.dequeueReusableCellWithIdentifier("MyPatientTVCell") as? MyPatientTVCell)!
        
        
        return cell.frame.size.height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("selected cell at section:\(indexPath.section) and row:\(indexPath.row)")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        
        
        let patientProfile:PatientProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("PatientProfileVC") as! PatientProfileVC
        
        var myPatient:Patient
        if searchController.active && searchController.searchBar.text != "" {
            
            myPatient = filteredList.objectAtIndex(indexPath.row) as! Patient
            
        }else{
            
            myPatient = list.myPatientsList.objectAtIndex(indexPath.row) as! Patient
            
        }
        print(myPatient.firstName)
        
        patientProfile.Name = myPatient.firstName + " " + myPatient.middleName + " " + myPatient.lastName
        
        patientProfile.Asthma = myPatient.asthma
        
        patientProfile.BDay = myPatient.dateOfBirth
        
        patientProfile.Phone = myPatient.phoneNumber
        
        patientProfile.Diabities = myPatient.diabetes
        
        patientProfile.Allergies = myPatient.allergies
        
        patientProfile.BloodType = myPatient.bloodType
        
        patientProfile.patientObject = myPatient
        
        var gender:String =  myPatient.gender
        if gender.characters.first == "f" || gender.characters.first == "F" {
            gender = "Female"
        }else{
            gender = "Male"
        }
        
        patientProfile.Gender = gender
        
        patientProfile.Medications = myPatient.medications
        
        
        patientProfile.Image = myPatient.imageUrl
        
        
        //here data done
        //
        //        let patientReports:ReportsTVC = self.
        //
        let navc:UINavigationController = self.navigationController!
        navc.pushViewController(patientProfile, animated: true)
        
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        
        //filteredList =
        let filterList:AnyObject = list.myPatientsList.filter({ (patientObj) -> Bool in
            
            let patient:Patient = patientObj as! Patient
            
            if (patient.firstName.lowercaseString.containsString(searchText.lowercaseString) || patient.middleName.lowercaseString.containsString(searchText.lowercaseString) || patient.lastName.lowercaseString.containsString(searchText.lowercaseString) )
            {return true}
            return false
            
        })
        
        self.filteredList = filterList.mutableCopy() as! NSMutableArray
        
        tableView.reloadData()
        
    }
    
    var deletedPatient:Patient = Patient()
    var deletedIndexPath:NSIndexPath = NSIndexPath()
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            
            let reach = Reach()
            
            var myPatient:Patient
            
            if self.searchController.active && self.searchController.searchBar.text != "" {
                myPatient = self.filteredList.objectAtIndex(indexPath.row) as! Patient
            }else{
                myPatient = list.myPatientsList.objectAtIndex(indexPath.row) as! Patient
            }
            
            if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
                let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
                Whisper(message, to: self.navigationController!, action: .Show)
                Silent(self.navigationController!, after: 3.0)
            }else{
                
                let url:String = "\(Const.URLs.PatientDrLink)/\(myPatient.linkId)"
                
                SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
                networkManager.AMDeleteData(url, reqId: 2, caller: self)

//                Alamofire.request(.DELETE, url).responseJSON { response in
//                    SwiftSpinner.hide()
//
//                    switch response.result {
//
//                    case .Failure(let error):
//                        print(error)
//                        print("error")
//                        let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Connection Failed", comment: ""))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                        
//                    case .Success:
//                        print("seccuss")
//                        if self.searchController.active && self.searchController.searchBar.text != "" {
//                            
//                            self.filteredList.removeObject(myPatient)
//                            list.myPatientsList.removeObject(myPatient)
//                            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                        }else{
//                            
//                            list.myPatientsList.removeObject(myPatient)
//                            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                            
//                        }
//                        
//                    }
//                }
            }
            
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
