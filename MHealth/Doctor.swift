//
//  Doctor.swift
//  MHealth
//
//  Created by trn24 on 3/6/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Doctor: NSObject, DataHolder {
    

    var drId:Int = 0
    var firstName:String = ""
    var middleName:String = ""
    var lastName:String = ""
    var email:String = ""
    var civilID:String = ""
    var password:String = ""
    var nationality:String = ""
    var specialty:String = ""
    var location:String = ""
    var extraInfo:String = ""
    var status:Bool = false
    
    
    //after adding
    var BDay:Int = 0
    var BMonth:Int = 0
    var BYear:Int = 0
    var cvUrl:String = ""
    var gender:String = ""
    var imageUrl:String = ""

    var phoneNumber:String = ""
    
    var deleted:Int = 0
    
    func toDictionary() -> NSDictionary {
        let values:NSMutableDictionary = NSMutableDictionary()
        values.setValue(drId, forKey: "drId")
        values.setValue(firstName, forKey: "firstName")
        values.setValue(middleName, forKey: "middleName")
        values.setValue(lastName, forKey: "lastName")
        values.setValue(email, forKey: "email")
        values.setValue(civilID, forKey: "civilId")
        values.setValue(password, forKey: "password")
        values.setValue(nationality, forKey: "nationality")
        values.setValue(specialty, forKey: "specialityId")
        values.setValue(location, forKey: "location")
        values.setValue(extraInfo, forKey: "extraInfo")
        values.setValue(status, forKey: "status")
      
        //after adding
        
        values.setValue(BDay, forKey: "BDay")
        values.setValue(BMonth, forKey: "BMonth")
        values.setValue(BYear, forKey: "BYear")
        values.setValue(cvUrl, forKey: "cvUrl")
        values.setValue(gender, forKey: "gender")
        values.setValue(imageUrl, forKey: "imageUrl")
        
        
        values.setValue(phoneNumber, forKey: "phoneNumber");
        
        values.setValue(deleted, forKey: "deleted");
        
        

        return values
    }
    
    
    func loadDictionary(values: NSDictionary) {
        self.drId = values.valueForKey("drId") as! Int
        self.firstName = values.valueForKey("firstName") as! String
        self.middleName = values.valueForKey("middleName") as! String
        self.email = values.valueForKey("email") as! String
        self.civilID = values.valueForKey("civilId") as! String
        self.password = values.valueForKey("password") as! String
        self.nationality = values.valueForKey("nationality") as! String
        self.specialty = values.valueForKey("specialityId") as! String
        self.location = values.valueForKey("location") as! String
        self.extraInfo = values.valueForKey("extraInfo") as! String
        self.status = values.valueForKey("status") as! Bool
        
        self.lastName = values.valueForKey("lastName") as! String
        //after adding 
        
        self.BDay = values.valueForKey("BDay") as! Int
        self.BMonth = values.valueForKey("BMonth") as! Int
        self.BYear = values.valueForKey("BYear") as! Int
        self.cvUrl = values.valueForKey("cvUrl") as! String
        self.gender = values.valueForKey("gender") as! String
        self.imageUrl = values.valueForKey("imageUrl") as! String
        
        self.phoneNumber = values.valueForKey("phoneNumber") as! String
        
        self.deleted = values.valueForKey("deleted") as! Int
    }
    
}
