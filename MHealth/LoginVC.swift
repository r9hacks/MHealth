//
//  LoginVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper
import VideoSplashKit

class LoginVC: VideoSplashViewController, NetworkCaller, UITextFieldDelegate {

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
        let values:[String:AnyObject] = ["username":email, "password":password]
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            let message = Message(title: "Connected", textColor: UIColor.whiteColor(), backgroundColor:  Customization().hexStringToUIColor("#37D711"), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
            SwiftSpinner.show(NSLocalizedString("Login...", comment: ""))
            networkManager.AMJSONDictionary(Const.URLs.login, httpMethod: "POST", jsonData: values, reqId: 1, caller: self)
        }
    }
    

    
    func nextPage () {

   //TabBarController
        let tabBar:UITabBarController =        self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.presentViewController(tabBar, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Heart", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = true
        self.startTime = 0.0
        self.duration = 10.0
        self.alpha = 1.0
        self.backgroundColor = UIColor.whiteColor()
        self.contentURL = url
        self.restartForeground = true
        
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
//        // Do any additional setup after loading the view.
//        Customization().customizeTextField(emailTextField)
//        Customization().customizeTextField(passwordTextField)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
//        
//        self.moviePlayer.view.frame = videoFrame
//        self.moviePlayer.showsPlaybackControls = false
//        self.moviePlayer.view.userInteractionEnabled = false
//        self.view.addSubview(moviePlayer.view)
//        self.view.sendSubviewToBack(moviePlayer.view)
//        
        if NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) != nil {
            let doctor:NSDictionary = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.drProfile) as! NSDictionary
            
            let currentDoctor:Doctor = Doctor()
            currentDoctor.loadDictionary(doctor)
            
            let email:String = currentDoctor.email
            let password:String = currentDoctor.password
            
            
            emailTextField.text = email
            passwordTextField.text = password
            
            loginAction(UIButton())
            
        }
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

