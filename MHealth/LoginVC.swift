//
//  LoginVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner

class LoginVC: UIViewController, NetworkCaller, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
  
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
   
    
    
    var loginDic:NSMutableDictionary = NSMutableDictionary()
    let networkManager:Networking = Networking()
    
    
    
    @IBAction func loginAction(sender: UIButton) {
      
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!
        
        let valid:Validator = Validator()
        
        
        if !valid.validateEmail(email) {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Please enter a valid e-mail", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        //  this function will be active after doing the validation in the utils
        //print("valid email or not \(valid.validateEmail(email))")
        
        if password == "" {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Please enter a password ", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        if password.characters.count < 8 {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("password must be more than 8 characters", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        SwiftSpinner.show(NSLocalizedString("Login...", comment: ""))
        let values:[String:AnyObject] = ["username":email, "password":password]
        networkManager.AMJSONDictionary(Const.URLs.login, httpMethod: "POST", jsonData: values, reqId: 1, caller: self)
    }
    

    
    func nextPage () {

   //TabBarController
        let tabBar:UITabBarController =        self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(tabBar, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        Customization().customizeTextField(emailTextField)
        Customization().customizeTextField(passwordTextField)
        
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
    
    
    
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        
    }
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        SwiftSpinner.hide()
       print("Login:")
        print(resp)
        
        if (resp.valueForKey("errorMsgEn") == nil){
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Connection to server Error", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            //alert
        }
        
        let responseMessage:String = resp.valueForKey("errorMsgEn") as! String
        
        if responseMessage != "Done" {
        
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Invalid email or password", comment: ""))
        
            self.presentViewController(alert, animated: true, completion: nil)
        
            return
        }
        
        
        let doctor:Doctor = Doctor()
        
        doctor.loadDictionary(resp.valueForKey("items") as! NSDictionary)
        
        NSUserDefaults.standardUserDefaults().setObject(doctor.toDictionary(), forKey: Const.UserDefaultsKeys.drProfile)
        
        NSUserDefaults.standardUserDefaults().setObject(doctor.drId, forKey: Const.UserDefaultsKeys.doctorID)
        
        
        nextPage()
        print(NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile)
        )
        
        
        
        
    }

        
        
//        let loginResult = resp.valueForKey("result") as! Bool
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

