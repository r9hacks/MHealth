//
//  RegisterVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper
class RegisterVC: UIViewController, NetworkCaller, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var civilIDTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    let networkManager: Networking = Networking()
    
    @IBAction func registerAction(sender: UIButton) {

        registerButton.enabled = false
        let drEmail = emailTextField.text
        let drPawssword = passwordTextField.text
        let drCivil = civilIDTextField.text
        let name = nameTextField.text
        let drPhone = phoneTextField.text
        
        
        
        if !Validator().validateEmail(drEmail!) || drPawssword == "" || drCivil == "" || name == "" || drPhone == ""{
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Please fill all fields", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            registerButton.enabled = true
            return
        }
        
        if !Validator().validateCivilID(drCivil!){
        
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Civil ID must be 12 digits", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            registerButton.enabled = true
            print ("less than 12")
            return

        }
        
        if drPawssword!.characters.count < 8 {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("password must be more than 8 characters", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            registerButton.enabled = true

            return
        }
        
        
        let newDr:Doctor = Doctor()
        
        newDr.civilID = drCivil!
        newDr.email = drEmail!
        newDr.password = drPawssword!
        newDr.firstName = name!
        newDr.gender = "f"
        newDr.phoneNumber = drPhone!
        
        let drDictT:NSDictionary = newDr.toDictionary()
        let drDict:NSMutableDictionary = drDictT.mutableCopy() as! NSMutableDictionary
        drDict.removeObjectForKey("drId")
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: NSLocalizedString("No Internet Connection", comment: ""), textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))

            
            networkManager.AMJSONDictionary(Const.URLs.Doctor, httpMethod: "POST", jsonData: drDict, reqId: 1, caller: self)
        }

    }
    
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        print(resp)
    }
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        registerButton.enabled = true
        SwiftSpinner.hide()
        print(resp)
        
        if (resp.valueForKey("errorMsgEn") != nil) {
            let errorCode:Int = resp.valueForKey("errorCode") as! Int
            let result:String = resp.valueForKey("errorMsgEn") as! String

            if errorCode == 406 {
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: "Email already used")
                self.presentViewController(alert, animated: true, completion: nil)
            }else if result == "Accepted"{
                
                let alertControlle:UIAlertController = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Regirstration is successful. Thank you", comment: ""), preferredStyle: .Alert)
                
                //UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString( "OK", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alertControlle.addAction(action)
                self.presentViewController(alertControlle, animated: true, completion: nil)
            }else{
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't register right now", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else{
                SwiftSpinner.hide();
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Connection Failed", comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
         
            
            
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        civilIDTextField.delegate = self
        phoneTextField.delegate = self
        
        Customization().customizeTextField(nameTextField)
        Customization().customizeTextField(emailTextField)
        Customization().customizeTextField(passwordTextField)
        Customization().customizeTextField(civilIDTextField)
        Customization().customizeTextField(phoneTextField)
        
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        if textField == phoneTextField {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        if textField == phoneTextField {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardDidHide), name: UIKeyboardDidHideNotification, object: nil)
            self.view!.endEditing(true)
        }
        return true
        
    }
    
    func keyboardDidShow(notification: NSNotification) {
        // Assign new frame to your view
        //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            self.view!.frame = CGRectMake(0, -180, self.view.frame.size.width, self.view.frame.size.height+180)
            
            
            }, completion: { (finished: Bool) -> Void in
                
                
        })
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        
        
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            
            self.view!.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-180)
            
            
            }, completion: { (finished: Bool) -> Void in
                
                
        })
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
}
