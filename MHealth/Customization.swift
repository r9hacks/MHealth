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
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
