//
//  Const.swift
//  MHealth
//
//  Created by Ahmed on 3/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Const: NSObject {
    
    struct URLs {
        static let BASE:String = "http://34.196.107.188:8080/DMHealthBackEnd/webresources/ws."
        static let Doctor:String = BASE + "doctor"
        static let Patient:String = BASE + "patient"
        static let PatientReport:String = BASE + "patientreport"
        static let resetPassword:String = Doctor + "/reset/"
        static let getDoctor:String = Doctor + "/getDoctor/"
        static let login:String = Doctor + "/login/"
        static let PatientDrLink:String = BASE + "patientdrlink"
        static let getLinkPatient:String = PatientDrLink + "/getLinkedPatient/"
        static let getReports:String = PatientReport + "/getReports/"
        static let updateReportRec:String = PatientReport + "/UpdatePatientReportDRec"

    }
    
    struct Files {
        let CACHE:String = ""
    }
    
    struct UserDefaultsKeys {
        static let langKey = "lang"
        static let doctorID = "doctorID"
        static let drProfile = "drProfile"
        
    }
}
