//
//  PatientProfileVC.swift
//  MHealth
//
//  Created by Entisar on 4/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class PatientProfileVC: UIViewController , UITableViewDelegate, UITableViewDataSource, NetworkCaller{
    
    
    @IBOutlet weak var patientReportsList: UITableView!
    var reportsList:[PatientReport] = []

    var patientObject:Patient?
   
    @IBOutlet weak var patientImage: UIImageView!
    var Image:String!
    
    @IBOutlet weak var patientName: UILabel!
    var Name:String?
    
    @IBOutlet weak var patientBDay: UILabel!
    var BDay:String?

    @IBOutlet weak var patientMedications: UILabel!
    var Medications:String?
    
    @IBOutlet weak var patientBloodType: UILabel!
    var BloodType:String?
    
    
    @IBOutlet weak var patientDDiabities: UILabel!
    var Diabities:Bool! = true
    
    @IBOutlet weak var patientAllergies: UILabel!
    var Allergies:String?
    
    @IBOutlet weak var patientAsthma: UILabel!
    var Asthma:Bool! = true
    
    @IBOutlet weak var patientGender: UILabel!
    var Gender:String?
    
    @IBOutlet weak var patientPhone: UILabel!
    var Phone:String?
    
    let networkManager:Networking =  Networking()
    
    
    @IBAction func makeACall(sender: UIButton) {
        
        if let url = NSURL(string: "telprompt://\(self.patientPhone.text!)") {
            //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.patientReportsList.delegate = self
        self.patientReportsList.dataSource = self
   

        self.patientReportsList.registerNib(UINib(nibName: "MyPatientReportTVC", bundle: nil), forCellReuseIdentifier: "MyPatientReportTVC")
        
        patientName.text = Name
        patientBDay.text = BDay
        
        patientMedications.text = Medications
        patientBloodType.text = BloodType
        
        patientAllergies.text = Allergies
        patientGender.text = Gender
        patientPhone.text = Phone
        
        patientAsthma.text = "\(Asthma)"
        
        patientDDiabities.text = "\(Diabities)"
        
        let url:NSURL = NSURL(string: Image)!
        
        patientImage.sd_setImageWithURL(url,placeholderImage: UIImage(named: "profileImage"))

        
        patientImage.layer.borderWidth = 2.0
        
        patientImage.layer.masksToBounds = true
        patientImage.layer.borderColor = Customization().UIColorFromRGB(0x4C9DB9).CGColor
        patientImage.layer.cornerRadius = patientImage.frame.size.height/2
       
    

        // Do any additional setup after loading the view.
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        let values:[String:AnyObject] = ["patientId":(self.patientObject?.patientId)!, "drId":currentDoctor.drId]

        networkManager.AMJSONArray(Const.URLs.GetPatientReport, httpMethod: "POST", jsonData: values, reqId: 1, caller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reportsList.count
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:MyPatientReportTVC = (tableView.dequeueReusableCellWithIdentifier("MyPatientReportTVC") as? MyPatientReportTVC)!

        
        let patientReport:PatientReport = reportsList[indexPath.row]

        cell.comment.text = patientReport.comments
        cell.heartRate.text = patientReport.heartbeatRate
        cell.bloodPressure.text = patientReport.bloodPressure
        cell.fever.text = patientReport.fever
        
        let time = relativeDateStringForDate(createDate(patientReport.timestamp)) as String
        cell.time.text = time
        
        return cell
        
        
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
        //        if components.year > 0 {
        //            return NSString.init(format: "%d years ago", year);
        //        } else if components.month > 0 {
        //            return NSString.init(format: "%d months ago", month);
        //        } else if components.weekOfYear > 0 {
        //            return NSString.init(format: "%d weeks ago", weeks);
        //        } else
        if (components.day > 0) {
            if components.day > 1 {
                
                return NSString.init(format: convertedDate);
            } else {
                return NSLocalizedString("Yesterday", comment: "");
            }
        } else {
            return NSString.init(format: "%d \(NSLocalizedString("hours ago", comment: ""))", hour);
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let cell:MyPatientReportTVC = (tableView.dequeueReusableCellWithIdentifier("MyPatientReportTVC") as? MyPatientReportTVC)!
        
        
        
        return cell.frame.size.height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let nextScreen:ReportDetailsTVC = self.storyboard?.instantiateViewControllerWithIdentifier("ReportDetailsID") as! ReportDetailsTVC
        
        nextScreen.currentIndex = indexPath.row
        
        let newPatientReport:PatientReport = reportsList[indexPath.row]
        
        nextScreen.currentPatientReport = newPatientReport
        nextScreen.parentVC2 = self
        
        self.navigationController?.pushViewController(nextScreen, animated: true)
        
    }

    func setArrayResponse(resp: NSArray, reqId: Int) {
        print("setArrayResponse")
        print(resp)
        reportsList.removeAll()
        for item in resp {
            
            let dictItem = item as! NSDictionary
            
            let newPatiet:PatientReport = PatientReport()
            
            newPatiet.loadDictionary(dictItem)
            
            reportsList.append(newPatiet)
        }
        
        self.patientReportsList.reloadData()
        
    }
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        print("setDictResponse")
        print(resp)
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
