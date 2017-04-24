//
//  Patient.swift
//  MHealth
//
//  Created by Ahmad alkandari on 3/6/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Patient: NSObject, DataHolder{
    
    /*
     "allergies": "NoAlergies", ok
     "asthma": false, ok
     "bloodType": "B+", ok
     "civilId": "295121600994", ok
     "dateOfBirth": "1995-12-16", ok
    in "deleted": 0,
     "diabetes": false, ok
     "email": "masoumawaheedi@gmail.com", ok
     "emergencyNumber": "55908111", ok
     "firstName": "Masouma", ok
     "gender": "F", ok
   in  "imageUrl": "https://instagram.fkwi6-1.fna.fbcdn.net/t51.2885-19/s320x320/13092401_1728684517388720_667162354_a.jpg",
     "lastName": "Waheedi", ok
     "medications": "Ventolaitor", ok
     "middleName": "M", ok
     "nationality": "Kuwaiti",ok
     "password": "m1234",
     "patientId": 1, ok
     "phoneNumber": "98828280", ok
     "status": false ok
     */
    
    var allergies:String = ""
    var asthma:Bool = false
    var bloodType:String = ""
    var civilId:String = ""
    var dateOfBirth:String = ""
    var diabetes:Bool = false
    var emergencyNumber:String = ""
    var firstName:String = ""
    var gender:String = ""
    var medications:String = ""
    var middleName:String = ""
    var nationality:String = ""
    var patientId:Int = 0
    var phoneNumber:String = ""
    var status:Bool = false
    var email:String = ""
    var lastName:String = ""
    var deleted:Int = 0
    var imageUrl:String = ""
    
    var linkId:Int = 0
    
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
        
        // updated
        values.setValue(deleted, forKey: "deleted")
        values.setValue(imageUrl, forKey: "imageUrl")
       
        values.setValue(linkId, forKey: "linkId")
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
        self.emergencyNumber = values.valueForKey("emergencyNumber") as! String

        self.firstName = values.valueForKey("firstName") as! String
        
        self.gender = values.valueForKey("gender") as! String
        self.lastName = values.valueForKey("lastName") as! String
        self.medications = values.valueForKey("medications") as! String
        
        self.middleName = values.valueForKey("middleName") as! String
        self.nationality = values.valueForKey("nationality") as! String
        self.patientId = values.valueForKey("patientId") as! Int
        
        self.phoneNumber = values.valueForKey("phoneNumber") as! String
        self.status = values.valueForKey("status") as! Bool
        
        //updated
        self.deleted = values.valueForKey("deleted") as! Int
        self.imageUrl = values.valueForKey("imageUrl") as! String
        
        if let linkIdTemp:Int =  values.valueForKey("linkId") as? Int{
            self.linkId = linkIdTemp
        }
    }
    
    
    
    
    func toArray()->NSArray{
        
        let valuesArray = NSMutableArray()
        valuesArray.addObject(gender)
        valuesArray.addObject(imageUrl)
        valuesArray.addObject(firstName)
        valuesArray.addObject(middleName)
        valuesArray.addObject(lastName)
        valuesArray.addObject(dateOfBirth)
        valuesArray.addObject(bloodType)
        valuesArray.addObject(phoneNumber)
        return valuesArray
        
    }
    
}

