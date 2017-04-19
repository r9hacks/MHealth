//
//  BloodRequests.swift
//  MHealth
//
//  Created by Ahmad alkandari on 4/10/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class BloodRequests: NSObject {

    var bloodType:String = ""
    var drId:Int = 0
    var quantity:Int = 0
    var reason:String = ""
    var requestsId:Int = 0
    var status:Int = 0
    var timestamp:String = ""

    
    
    
    func toDictionary() -> NSDictionary {
        let values:NSMutableDictionary = NSMutableDictionary()
        values.setValue(bloodType, forKey: "bloodType")
        values.setValue(drId, forKey: "drId")
        values.setValue(quantity, forKey: "quantity")
        values.setValue(reason, forKey: "reason")
        values.setValue(requestsId, forKey: "requestsId")
        values.setValue(status, forKey: "status")
        values.setValue(timestamp, forKey: "timestamp")
        return values
    }
    
    func loadDictionary(values: NSDictionary) {

        
        self.bloodType = values.valueForKey("bloodType") as! String
        self.drId = values.valueForKey("drId") as! Int
        
        
        self.quantity = values.valueForKey("quantity") as! Int
        self.reason = values.valueForKey("reason") as! String

        self.requestsId = values.valueForKey("requestsId") as! Int
        self.status = values.valueForKey("status") as! Int

        if (values.valueForKey("timestamp") != nil) {
            self.timestamp = values.valueForKey("timestamp") as! String
        }
        
    }
    
    
}
