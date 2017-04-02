//
//  Alert.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/6/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Alert: NSObject {

    func getAlert(title:String, msg:String) -> UIAlertController  {
        let alertControlle:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let action:UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Cancel, handler: nil)
        
        alertControlle.addAction(action)
        
        return alertControlle
    }
    
}
