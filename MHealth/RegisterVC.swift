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
    
    @IBOutlet weak var registerButton: UIButton!
    
    let networkManager: Networking = Networking()
    
    @IBAction func registerAction(sender: UIButton) {

        registerButton.enabled = false
        let drEmail = emailTextField.text
        let drPawssword = passwordTextField.text
        let drCivil = civilIDTextField.text
        let name = nameTextField.text
        
        
        
        if !Validator().validateEmail(drEmail!) || drPawssword == "" || drCivil == "" || name == ""{
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Please fill all fields", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            registerButton.enabled = true
            return
        }
        
        if drPawssword!.characters.count < 8 {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("password must be more than 8 characters.", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        let newDr:Doctor = Doctor()
        
        newDr.civilID = drCivil!
        newDr.email = drEmail!
        newDr.password = drPawssword!
        newDr.firstName = name!
        
        let drDictT:NSDictionary = newDr.toDictionary()
        let drDict:NSMutableDictionary = drDictT.mutableCopy() as! NSMutableDictionary
        drDict.removeObjectForKey("drId")
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
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
        }
//        if resp.allKeys.count > 0 {
//            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Can't register right now", comment: ""))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }else{
//            
//            let alertControlle:UIAlertController = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: NSLocalizedString("Regirstration is successful. Thank you", comment: ""), preferredStyle: .Alert)
//            
//            //UIAlertAction(title: "OK", style: .Cancel, handler: nil)
//            let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString( "OK", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
//                self.navigationController?.popViewControllerAnimated(true)
//            })
//            alertControlle.addAction(action)
//            self.presentViewController(alertControlle, animated: true, completion: nil)
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        civilIDTextField.delegate = self
        
        Customization().customizeTextField(nameTextField)
        Customization().customizeTextField(emailTextField)
        Customization().customizeTextField(passwordTextField)
        Customization().customizeTextField(civilIDTextField)
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
