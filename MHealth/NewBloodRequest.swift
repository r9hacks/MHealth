//
//  NewBloodRequest.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/10/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit
import SwiftSpinner

class NewBloodRequest: UIViewController,NetworkCaller,UITextViewDelegate {
    
    
    @IBOutlet weak var reasonTextView: UITextView!
    
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet var bloodTypeImageButton: [UIButton]!
    
    var selectedBloodtype:Int = 1
    
    
    @IBAction func stepperChange(sender: UIStepper) {
        quantityLabel.text = "\(Int(stepper.value))"
    }
    
    
    
    @IBAction func bloodImageButtonClicked(sender: UIButton) {
        selectedBloodtype = sender.tag
        selectBloodType(sender.tag)
        
    }
    
    
    func selectBloodType(tag:Int){
        for button in bloodTypeImageButton {
            if button.tag == tag {
                
                button.layer.borderColor = UIColor.redColor().colorWithAlphaComponent(1.0).CGColor
                button.layer.borderWidth = 1.0
                //The rounded corner part, where you specify your view's corner radius:
                button.layer.cornerRadius = 5;
                button.clipsToBounds = true;
                button.alpha = 1.0
                
            }else{
                
                button.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
                button.layer.borderWidth = 1.0
                //The rounded corner part, where you specify your view's corner radius:
                button.layer.cornerRadius = 5;
                button.clipsToBounds = true;
                button.alpha = 0.5
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        quantityLabel.text = "\(Int(stepper.value))"
        
        reasonTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        reasonTextView.layer.borderWidth = 0.8
        //The rounded corner part, where you specify your view's corner radius:
        reasonTextView.layer.cornerRadius = 5;
        reasonTextView.clipsToBounds = true;
        
        selectBloodType(1)
        reasonTextView.delegate = self
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sendNewRequest(sender: UIButton) {
        
        
        if reasonTextView.text == "" {
            let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: "Reason cannot be empty")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var bloodType:String
        
        if selectedBloodtype == 1 {
            bloodType = "A+"
        }else if selectedBloodtype == 2 {
            bloodType = "A-"
        }else if selectedBloodtype == 3 {
            bloodType = "B+"
        }else if selectedBloodtype == 4 {
            bloodType = "B-"
        }else if selectedBloodtype == 5 {
            bloodType = "O+"
        }else if selectedBloodtype == 6 {
            bloodType = "O-"
        }else if selectedBloodtype == 7 {
            bloodType = "AB+"
        }else{
            bloodType = "AB-"
        }
        
        let drId:Int = NSUserDefaults.standardUserDefaults().valueForKey(Const.UserDefaultsKeys.doctorID) as! Int
        
        SwiftSpinner.show(NSLocalizedString("Connecting...", comment: ""))
        
        
        let params:NSMutableDictionary = NSMutableDictionary()
        params.setValue(drId, forKey: "drId")
        params.setValue(Int(stepper.value), forKey: "quantity")
        params.setValue(bloodType, forKey: "bloodType")
        params.setValue(reasonTextView.text, forKey: "reason")
        params.setValue(0, forKey: "status")
        
        print(params)
        
        let requestId = 0
        
        networkManager.AMJSONDictionary(Const.URLs.BloodRequests, httpMethod: "POST", jsonData: params, reqId: requestId, caller: self)
        
    }
    
    let networkManager:Networking = Networking()
    
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        

    }
    
    
    func setDictResponse(resp: NSDictionary, reqId: Int) {
        SwiftSpinner.hide()
        print(resp)
        
        if (resp.valueForKey("errorMsgEn") != nil) {
            let result:String = resp.valueForKey("errorMsgEn") as! String
            if result == "Not Created+\nUser already exist" {
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: "Connection error")
                self.presentViewController(alert, animated: true, completion: nil)
            }else if result == "Accepted"{
                let alertControlle:UIAlertController = UIAlertController(title: NSLocalizedString("Confirm", comment: ""), message: "Request sent", preferredStyle: .Alert)
                
                //UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                let action:UIAlertAction =  UIAlertAction(title: NSLocalizedString( "OK", comment: ""), style: .Cancel, handler: { (UIAlertAction) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                alertControlle.addAction(action)
                self.presentViewController(alertControlle, animated: true, completion: nil)
            }else{
                let alert:UIAlertController = Alert().getAlert(NSLocalizedString("Error", comment: ""), msg: "Connection error")
                self.presentViewController(alert, animated: true, completion: nil)
            }
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
