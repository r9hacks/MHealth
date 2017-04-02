//
//  Patient.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/6/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Patient: NSObject, DataHolder{

    var allergies:String = ""
    var asthma:Bool = false
    var bloodType:String = ""
    var civilId:String = ""
    var dateOfBirth:String = ""
    var diabetes:Bool = false
    var emergencyNumber:Int = 0
    var firstName:String = ""
    var gender:String = ""
    var medications:String = ""
    var middleName:String = ""
    var nationality:String = ""
    var patientId:Int = 0
    var phoneNumber:Int = 0
    var status:Bool = false
    var email:String = ""
    var lastName:String = ""

    
    func toDictionary() -> NSDictionary {
        let values:NSMutableDictionary = NSMutableDictionary()
        values.setValue(allergies, forKey: "allergies")
        values.setValue(asthma, forKey: "asthma")
        values.setValue(bloodType, forKey: "bloodType")
        values.setValue(civilId, forKey: "civilId")
        values.setValue(dateOfBirth, forKey: "dateOfBirth")
        values.setValue(diabetes, forKey: "diabetes")
        values.setValue(email, forKey: "email")

        values.setValue(emergencyNumber, forKey: "emergencyNumber")
        values.setValue(firstName, forKey: "firstName")
        values.setValue(gender, forKey: "gender")
        values.setValue(lastName, forKey: "lastName")

        values.setValue(medications, forKey: "medications")
        values.setValue(middleName, forKey: "middleName")
        values.setValue(nationality, forKey: "nationality")
        
        values.setValue(patientId, forKey: "patientId")
        values.setValue(phoneNumber, forKey: "phoneNumber")
        values.setValue(status, forKey: "status")
        return values
    }
    
    func loadDictionary(values: NSDictionary) {
        self.allergies = values.valueForKey("allergies") as! String
        self.asthma = values.valueForKey("asthma") as! Bool
        self.bloodType = values.valueForKey("bloodType") as! String
        
        self.civilId = values.valueForKey("civilId") as! String
        self.dateOfBirth = values.valueForKey("dateOfBirth") as! String
        self.diabetes = values.valueForKey("diabetes") as! Bool
        
        self.email = values.valueForKey("email") as! String
        self.emergencyNumber = values.valueForKey("emergencyNumber") as! Int
        self.firstName = values.valueForKey("firstName") as! String
        
        self.gender = values.valueForKey("gender") as! String
        self.lastName = values.valueForKey("lastName") as! String
        self.medications = values.valueForKey("medications") as! String
        
        self.middleName = values.valueForKey("middleName") as! String
        self.nationality = values.valueForKey("nationality") as! String
        self.patientId = values.valueForKey("patientId") as! Int
        
        self.phoneNumber = values.valueForKey("phoneNumber") as! Int
        self.status = values.valueForKey("status") as! Bool
        
    }
}
/*
 {
 "allergies": "NoAlergies",
 "asthma": false,
 "bloodType": "B+",
 "civilId": "295121600994",
 "dateOfBirth": "1995-12-16T00:00:00Z",
 "diabetes": false,
 "email": "masoumawaheedi@gmail.com",
 "emergencyNumber": 55908111,
 "firstName": "Masouma",
 "gender": "F",
 "lastName": "Waheedi",
 "medications": "Ventolaitor",
 "middleName": "M",
 "nationality": "Kuwaiti",
 "patientId": 1,
 "phoneNumber": 98828280,
 "status": false
 },
 */