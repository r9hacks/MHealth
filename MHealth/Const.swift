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
        static let BASE:String = "http://34.196.107.188:8081/MhealthWeb/webresources/"
        static let Doctor:String = BASE + "doctor"
        static let Patient:String = BASE + "patient"
        static let PatientReport:String = BASE + "patientreport"
        static let PatientDrLink:String = BASE + "patientdrlink"
        
        static let login:String = Doctor + "/login/"
        static let getDoctor:String = Doctor + "/getDoctor/"
        static let resetPassword:String = Doctor + "/reset/"
        static let PendingRequest:String = Doctor + "/pendingdoctor/";
        static let MyPatient:String = Doctor + "/accepteddoctor/";

        
        static let getLinkPatient:String = PatientDrLink + "/getLinkedPatient/"
        static let UpdateRequestStatus:String = PatientDrLink + "/setstatus/";

        
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
    
    
    /*
     public static String BASE = "http://34.196.107.188:8081/MhealthWeb/webresources/";
     
     public static String Doctor = BASE + "doctor";
     public static String PatientDrLink = BASE + "patientdrlink";
     
     public static String getDoctor = Doctor + "/getDoctor/";
     
     public static String Patient = BASE + "patient";
     public static String PatientReport = BASE + "patientreport";
     
     public static String resetPassword = Doctor + "/reset/";
     public static String login = Doctor + "/login/";
     
     
     public static String PendingRequest = Doctor + "/pendingdoctor/";
     public static String MyPatient = Doctor + "/accepteddoctor/";
     public static String GetRepliedReport = PatientReport + "/getReports/";
     public static String ReplyReport = PatientReport +"/UpdatePatientReportDRec/";
     public static String GetPatientReport = PatientReport +"/getPatientReport/";
     
     
     public static String PrefDoctorProfile = "doctorProfile";
     public static String PrefReport = "PatientReport";
     
     public static String PrefPatientProfile = "patientProfile";
     public static String PrefLanguage = "APPLanguage";
     
     public static String UpdateRequestStatus = PatientDrLink + "/setstatus/";
     */
    /*
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
     
     
     */
    
}
