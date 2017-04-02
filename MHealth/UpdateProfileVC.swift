//
//  UpdateProfileVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/7/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner

class UpdateProfileVC: UIViewController, NetworkCaller, UITextFieldDelegate,UITextViewDelegate {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var civilTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nationalityTextField: UITextField!
    
    @IBOutlet weak var specialtyTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var bioTextArea: UITextView!

    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    @IBOutlet weak var nameIMG: UIImageView!
    
    @IBOutlet weak var emailIMG: UIImageView!
    
    @IBOutlet weak var passwordIMG: UIImageView!
    
    @IBOutlet weak var CivilIDIMG: UIImageView!
    
    @IBOutlet weak var nationalityIMG: UIImageView!
    
    @IBOutlet weak var specialtyIMG: UIImageView!
    
    @IBOutlet weak var bdayIMG: UIImageView!
    
    @IBOutlet weak var maleIMG: UIImageView!
    
    @IBOutlet weak var femaleIMG: UIImageView!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    var year:Int = 0
    var month:Int = 0
    var day:Int = 0
    var gender:String = ""
    let networkManager:Networking = Networking()
    var updatedDoctor:Doctor?
    
    @IBAction func genderSegmentChanged(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            self.gender = "f"
        }else{
            self.gender = "m"
        }
        
    }
    @IBAction func saveAction(sender: AnyObject) {
        self.saveButton.enabled = false
        
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == ""
        || civilTextField.text == "" || nationalityTextField.text == "" || specialtyTextField.text == "" || locationTextField.text == "" || phoneTextField.text == "" || passwordTextField.text == ""{
            
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("All field must be fill", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.saveButton.enabled = true
            return
        }
        
        if year == 0 || month == 0 || day == 0{
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Please insert birthday", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.saveButton.enabled = true
            return

        }
        
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        if self.passwordTextField.text != currentDoctor.password {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Password is incorrect", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.saveButton.enabled = true
            return
        }
        
        currentDoctor.BDay = day
        currentDoctor.BMonth = month
        currentDoctor.BYear = year
        currentDoctor.civilID = self.civilTextField.text!
        currentDoctor.lastName = self.lastNameTextField.text!
        currentDoctor.nationality = self.nationalityTextField.text!
        currentDoctor.specialty = self.specialtyTextField.text!
        currentDoctor.location = self.locationTextField.text!
        currentDoctor.extraInfo = self.bioTextArea.text
        currentDoctor.gender = gender
        currentDoctor.firstName = self.firstNameTextField.text!
        currentDoctor.phoneNumber = self.phoneTextField.text!
        
        let url:String = Const.URLs.Doctor + "/" + "\(currentDoctor.drId)"
        SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
        networkManager.AMJSONDictionary(url, httpMethod: "PUT", jsonData: currentDoctor.toDictionary(), reqId: 1, caller: self)
        updatedDoctor = currentDoctor;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        bioTextArea.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        bioTextArea.layer.borderWidth = 0.8
        //The rounded corner part, where you specify your view's corner radius:
        bioTextArea.layer.cornerRadius = 5;
        bioTextArea.clipsToBounds = true;
        
        
        let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
        
        let currentDoctor:Doctor = Doctor()
        currentDoctor.loadDictionary(doctor)
        
        firstNameTextField.text = currentDoctor.firstName
        lastNameTextField.text = currentDoctor.lastName
        emailTextField.text = currentDoctor.email
        civilTextField.text = currentDoctor.civilID
        nationalityTextField.text = currentDoctor.nationality
        specialtyTextField.text = currentDoctor.specialty
        locationTextField.text = currentDoctor.location
        bioTextArea.text = currentDoctor.extraInfo
        phoneTextField.text = currentDoctor.phoneNumber
        if currentDoctor.gender.lowercaseString == "f" {
            self.genderSegment.selectedSegmentIndex = 1
            self.gender = "f"
        }else{
            self.genderSegment.selectedSegmentIndex = 0
            self.gender = "m"
        }

        //////
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: NSDate.init())
        components.day = currentDoctor.BDay
        components.month = currentDoctor.BMonth
        components.year = currentDoctor.BYear
        
        let Bdate = calendar.dateFromComponents(components)
        //////
        let datePicker:UIDatePicker = UIDatePicker()
        
        datePicker.setDate(Bdate!, animated: true)
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: #selector(updateTextField), forControlEvents: UIControlEvents.ValueChanged)
        
        self.birthdayTextField.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.Default
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.blackColor()
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(donePressed))
        
        toolBar.setItems([doneButton], animated: true)
        
        self.birthdayTextField.inputAccessoryView = toolBar
        Customization().customizeTextField(birthdayTextField)

        
        updateTextField()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        civilTextField.delegate = self
        passwordTextField.delegate = self
        nationalityTextField.delegate = self
        specialtyTextField.delegate = self
        locationTextField.delegate = self
        bioTextArea.delegate = self
        Customization().customizeTextField(firstNameTextField)
        Customization().customizeTextField(lastNameTextField)
        Customization().customizeTextField(emailTextField)
        Customization().customizeTextField(civilTextField)
        Customization().customizeTextField(passwordTextField)
        Customization().customizeTextField(nationalityTextField)
        Customization().customizeTextField(specialtyTextField)
        Customization().customizeTextField(locationTextField)
        Customization().customizeTextField(phoneTextField)
        
        
    }
    
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    
    //remove keyboard from piker
    func donePressed(sender: UIBarButtonItem) {
        
        self.birthdayTextField.resignFirstResponder()
        
    }
    
    
    //function that update birthday text field and the day month years values
    //when piker value changed
    func updateTextField() {
        let picker:UIDatePicker = self.birthdayTextField.inputView as! UIDatePicker
        
        let dateFormatter = NSDateFormatter()
        //let monthName = dateFormatter.monthSymbols[monthNumber - 1]
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let strDate = dateFormatter.stringFromDate(picker.date)
        
        self.birthdayTextField.text = "\(strDate)"
        
        let date = picker.date
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)

        self.year = year
        self.month = month
        self.day = day
    }

    func setArrayResponse(resp: NSArray, reqId: Int) {
        
    }
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        SwiftSpinner.hide()
        print(resp)
        self.saveButton.enabled = true
        

        if resp.allKeys.count > 0 {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't update profile right now", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Updated", comment: ""), msg: NSLocalizedString("Profile is updated", comment: ""))
            
            
            NSUserDefaults.standardUserDefaults().setObject(updatedDoctor!.toDictionary(), forKey: Const.UserDefaultsKeys.drProfile)
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
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

/*
 //
 //  UpdateProfileVC.swift
 //  MHealth
 //
 //  Created by trn24 on 3/5/17.
 //  Copyright © 2017 PIFSS. All rights reserved.
 //
 
 import UIKit
 
 class UpdateProfileVC: UIViewController {
 
 @IBOutlet weak var firstNameTextField: UITextField!
 
 @IBOutlet weak var lastNameTextField: UITextField!
 
 @IBOutlet weak var emailTextField: UITextField!
 
 @IBOutlet weak var civilTextField: UITextField!
 
 @IBOutlet weak var passwordTextField: UITextField!
 
 @IBOutlet weak var nationalityTextField: UITextField!
 
 @IBOutlet weak var specialtyTextField: UITextField!
 
 @IBOutlet weak var locationTextField: UITextField!
 
 @IBOutlet weak var bioTextArea: UITextField!
 
 @IBOutlet weak var saveButton: UIButton!
 
 @IBAction func saveAction(sender: AnyObject) {
 
 }
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 
 let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
 
 let currentDoctor:Doctor = Doctor()
 currentDoctor.loadDictionary(doctor)
 
 firstNameTextField.text = currentDoctor.firstName
 lastNameTextField.text = currentDoctor.lastName
 emailTextField.text = currentDoctor.email
 civilTextField.text = currentDoctor.civilID
 nationalityTextField.text = currentDoctor.nationality
 specialtyTextField.text = currentDoctor.specialty
 locationTextField.text = currentDoctor.location
 bioTextArea.text = currentDoctor.extraInfo
 
 
 
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
 
 */