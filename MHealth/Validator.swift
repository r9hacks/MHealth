//
//  Validator.swift
//  MHealth
//
//  Created by Ahmed on 3/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Validator: NSObject {

    func validateEmail(email:String) -> Bool{
        if email == "" {
            return false
        }
        return true
    }
    
    func validateCivilID(civilId:String) -> Bool{
        if civilId.characters.count != 12 {
            return false
        }
        return true
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    func GetCurrentTimestamp() -> String {
        let todayDate = NSDate()
        let units: NSCalendarUnit = [.Year, .Day, .Month, .Hour, .Minute, .Second]
        let components:NSDateComponents = NSCalendar.currentCalendar().components(units, fromDate: todayDate)
        //let components:NSDateComponents = NSCalendar.currentCalendar().components(units, fromDate: todayDate , toDate: todayDate, options: NSCalendarOptions.MatchFirst )
        let year:String = "\(components.year)"
        var month:String = "\(components.month)"
        if components.month < 10 {
            month = "0\(components.month)"
        }
        
        var day:String = "\(components.day)"
        if components.day < 10 {
            day = "0\(components.day)"
        }
        
        var hour:String = "\(components.hour)"
        if components.hour < 10 {
            hour = "0\(components.hour)"
        }
        
        var minute:String = "\(components.minute)"
        if components.minute < 10 {
            minute = "0\(components.minute)"
        }
        
        var second:String = "\(components.second)"
        if components.second < 10 {
            second = "0\(components.second)"
        }
        let timestamp:String = "\(year)-\(month)-\(day)T\(hour):\(minute):\(second)Z"
        print(timestamp)
        return timestamp
    }
}
