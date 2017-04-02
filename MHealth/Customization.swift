//
//  Customization.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/8/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Customization: NSObject {
    
    func customizeTextField(textField:UITextField){
        
        let bottomBorder:CALayer = CALayer()
        
        bottomBorder.frame = CGRectMake(0.0, textField.layer.frame.size.height - 1 , textField.layer.frame.size.width, 1.0)
        
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        bottomBorder.opacity = 0.5
        textField.layer.addSublayer(bottomBorder)
        
    }
    
    func addUnderLineToLabel(textLabel:UILabel){
        
        let bottomBorder:CALayer = CALayer()
        
        bottomBorder.frame = CGRectMake(0.0, textLabel.layer.frame.size.height - 1 , textLabel.layer.frame.size.width, 1.0)
        
        bottomBorder.backgroundColor = UIColor.grayColor().CGColor
        bottomBorder.opacity = 0.5
        textLabel.layer.addSublayer(bottomBorder)
    }
    
    //func tabController:UITabBarController
    
}
