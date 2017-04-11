//
//  ResetVC.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/5/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner
import Whisper
class ResetVC: UIViewController, NetworkCaller , UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendPasswordButton: UIButton!
    
    let networkManager:Networking = Networking()
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        
    }
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        sendPasswordButton.enabled = true
        SwiftSpinner.hide()
        print(resp);
        
        if (resp.valueForKey("errorMsgEn") == nil){
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Connection to server Error", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            //alert
        }
        
        let responseMessage:String = resp.valueForKey("errorMsgEn") as! String
        
        if responseMessage != "Done" {
            
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Invalid email address", comment: ""))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }else{
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Successful", comment: ""), msg: NSLocalizedString("password is sent", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
       
        
    }
    
    
    //
    //    var task:NSURLSessionTask?
    //    func sendPost(url:String) {
    //        let u:NSURL = NSURL(string: url)!
    //        let conf = NSURLSessionConfiguration.defaultSessionConfiguration()
    //        let session:NSURLSession = NSURLSession(configuration: conf)
    //
    //        task = session.dataTaskWithURL(u){
    //            (data,res,error) -> Void in
    //
    //            if let e = error{
    //                print(e)
    //                return
    //            }
    //
    //            if let d = data{
    //                let s:String = NSString(data: d, encoding: NSUTF8StringEncoding) as! String
    //                print(s)
    //            }
    //        }
    //
    //        task!.resume()
    //
    //    }
    //
    @IBAction func sendPasswordAction(sender: UIButton) {
        
        let email:String = self.emailTextField.text!
        if !Validator().validateEmail(email) {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Please enter a valid e-mail", comment: ""))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        sendPasswordButton.enabled = false
        
        //send email to server
        
        print(Const.URLs.resetPassword)
        SwiftSpinner.show(NSLocalizedString("Sending...", comment: ""))
        print("\(Const.URLs.resetPassword + email)");
        
        let reach = Reach()
        
        print ("Connection status!!!!!!!:")
        
        
        if reach.connectionStatus().description == ReachabilityStatus.Offline.description{
            let message = Message(title: "No Internet Connection", textColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor(), images: nil)
            Whisper(message, to: self.navigationController!, action: .Show)
            Silent(self.navigationController!, after: 3.0)
        }else{
            
            
            networkManager.AMGetDictData(Const.URLs.resetPassword + email, params: [:], reqId: 1, caller: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        // Do any additional setup after loading the view.
       Customization().customizeTextField(emailTextField)
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
