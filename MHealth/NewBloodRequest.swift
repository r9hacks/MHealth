//
//  NewBloodRequest.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/10/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class NewBloodRequest: UIViewController {
    
    
    @IBOutlet weak var reasonTextView: UITextView!
    
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet var bloodTypeImageButton: [UIButton]!
    
    var selectedBloodtype:Int = 1
    
    
    @IBAction func stepperChange(sender: UIStepper) {
        quantityLabel.text = "\(Int(stepper.value))"
    }
    
    
    
    @IBAction func bloodImageButtonClicked(sender: UIButton) {
        
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
                
                
            }else{
                
                button.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
                button.layer.borderWidth = 1.0
                //The rounded corner part, where you specify your view's corner radius:
                button.layer.cornerRadius = 5;
                button.clipsToBounds = true;
                
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
