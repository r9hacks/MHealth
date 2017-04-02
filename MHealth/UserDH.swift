//
//  UserDH.swift
//  MHealth
//
//  Created by Ahmed on 3/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class UserDH: NSObject, DataHolder {
    
    var name:String = ""
    var email:String = ""
    var age:Int = 0
    
    func toDictionary() -> NSDictionary {
        let values:NSMutableDictionary = NSMutableDictionary()
        values.setValue(name, forKey: "name")
        values.setValue(age, forKey: "age")
        values.setValue(email, forKey: "email")
        return values
    }
    
    func loadDictionary(values: NSDictionary) {
        self.name = values.valueForKey("name") as! String
        self.age = values.valueForKey("age") as! Int
        self.email = values.valueForKey("email") as! String
    }
    
    
    
}
