//
//  Networking.swift
//  me@ayossef.net
//
//  Created by Ahmed Yossef on 4/18/16.
//  Copyright © 2016 PIFSS. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

protocol NetworkCaller{
    func setDictResponse(resp:NSDictionary, reqId:Int)
    func setArrayResponse(resp:NSArray, reqId:Int)
}

class Networking: NSObject {
    
    var logging:Bool = false
    
    func AMJSONDictionary(url:String, httpMethod:String, jsonData:NSObject, reqId:Int, caller:NetworkCaller?) -> OutputResult{
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonData, options: [])
        var result:OutputResult = OutputResult(status: true)
        Alamofire.request(request)
            .responseJSON { response in
                if self.logging{
                    let outData = response.data
                    let outString = NSString(data: outData!, encoding: NSUTF8StringEncoding)
                    print(outString)
                }
                switch response.result {
                case .Failure(let error):
                    print(error)
                    result =  OutputResult(status: false)
                    result.items = []
                    if let realCaller = caller{
                        realCaller.setDictResponse(["Error":"Error"], reqId: reqId)
                    }
                case .Success:
                    if let value = response.result.value {
                        if let realCaller = caller{
                            if value.isKindOfClass(NSNull){
                                realCaller.setDictResponse([:], reqId: reqId)
                            }
                            else {
                                if let dicValue = value as? NSDictionary {
                                    realCaller.setDictResponse(dicValue, reqId: reqId)
                                }else if value.isKindOfClass(NSNull){
                                    realCaller.setDictResponse([:], reqId: reqId)
                                }else{
                                    
                                    realCaller.setDictResponse(["Error":"Error"], reqId: reqId)
                                }
                            }
                        }
                    }
                }
        }
        return result
    }
    
    func AMGetDictData(url:String, params:[String:AnyObject], reqId:Int, caller:NetworkCaller?)-> OutputResult{
        
        var result:OutputResult = OutputResult(status: true)
        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            if self.logging{
                let outData = response.data
                let outString = NSString(data: outData!, encoding: NSUTF8StringEncoding)
                print(outString)
            }
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    if let realCaller = caller{
                        if let dicValue = value as? NSDictionary {
                            realCaller.setDictResponse(dicValue, reqId: reqId)
                        }else if value.isKindOfClass(NSNull){
                            realCaller.setDictResponse([:], reqId: reqId)
                        }else{
                            
                            realCaller.setDictResponse(["Error":"Error"], reqId: reqId)
                        }
                    }
                }
                
            case .Failure(let error):
                print(error)
                result =  OutputResult(status: false)
                result.items = []
                if let realCaller = caller{
                    realCaller.setDictResponse(["Error":"Error"], reqId: reqId)
                }
            }
            print("result was \(response.result)")
        }
        return result
    }
    
    func AMJSONArray(url:String, httpMethod:String, jsonData:NSObject, reqId:Int, caller:NetworkCaller?) -> OutputResult{
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonData, options: [])
        var result:OutputResult = OutputResult(status: true)
        Alamofire.request(request)
            .responseJSON { response in
                if self.logging{
                    let outData = response.data
                    let outString = NSString(data: outData!, encoding: NSUTF8StringEncoding)
                    print(outString)
                }
                switch response.result {
                case .Failure(let error):
                    print(error)
                    print(NSString(data: (response.data)!,encoding: NSUTF8StringEncoding))
                    result =  OutputResult(status: false)
                    result.items = []
                    if let realCaller = caller{
                        realCaller.setArrayResponse(["Error"], reqId: reqId)
                    }
                case .Success:
                    print("SUCESS")
                    print(NSString(data: (response.data)!,encoding: NSUTF8StringEncoding))
                    if let value = response.result.value {
                        if let realCaller = caller{
                            if value.isKindOfClass(NSNull){
                                realCaller.setArrayResponse([], reqId: reqId)
                            }
                            else {
                                if let arrayValue = value as? NSArray {
                                    
                                    realCaller.setArrayResponse(arrayValue, reqId: reqId)
                                }else if value.isKindOfClass(NSNull){
                                    realCaller.setArrayResponse([], reqId: reqId)
                                }else{
                                    
                                    realCaller.setArrayResponse(["Error"], reqId: reqId)
                                }
                                
                            }
                        }
                    }
                }
        }
        return result
    }
    
    
    
    func AMPostDictData(url:String, params:[String:AnyObject], reqId:Int, caller:NetworkCaller?)-> OutputResult{
        
        var result:OutputResult = OutputResult(status: true)
        Alamofire.request(.POST, url, parameters: params).validate().responseJSON { response in
            if self.logging{
                let outData = response.data
                let outString = NSString(data: outData!, encoding: NSUTF8StringEncoding)
                print(outString)
            }
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    if let realCaller = caller{
                        if let dicValue = value as? NSDictionary {
                            realCaller.setDictResponse(dicValue, reqId: reqId)
                        }else if value.isKindOfClass(NSNull){
                            realCaller.setDictResponse([:], reqId: reqId)
                        }else{
                            
                            realCaller.setDictResponse(["Error":"Error"], reqId: reqId)
                        }
                    }
                }
            case .Failure(let error):
                print(error)
                result =  OutputResult(status: false)
                result.items = []
                if let realCaller = caller{
                    realCaller.setDictResponse(["Error":"Error"], reqId: reqId)
                }
            }
            print("result was \(response.result)")
        }
        return result
    }
    
    
    func AMGetArrayData(url:String, params:[String:AnyObject], reqId:Int, caller:NetworkCaller?)-> OutputResult{
        
        var result:OutputResult = OutputResult(status: true)
        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            if self.logging{
                let outData = response.data
                let outString = NSString(data: outData!, encoding: NSUTF8StringEncoding)
                print(outString)
            }
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    if let realCaller = caller{
                        if let arrayValue = value as? NSArray {
                            
                            realCaller.setArrayResponse(arrayValue, reqId: reqId)
                        }else if value.isKindOfClass(NSNull){
                            realCaller.setArrayResponse([], reqId: reqId)
                        }else{
                            
                            realCaller.setArrayResponse(["Error"], reqId: reqId)
                        }
                    }
                }
                
            case .Failure(let error):
                print(error)
                result =  OutputResult(status: false)
                result.items = []
                if let realCaller = caller{
                    realCaller.setArrayResponse(["Error"], reqId: reqId)
                }
            }
            print("result was \(response.result)")
        }
        return result
    }
    
    
    
    
    func AMPostArrayData(url:String, params:[String:AnyObject], reqId:Int, caller:NetworkCaller?)-> OutputResult{
        
        var result:OutputResult = OutputResult(status: true)
        Alamofire.request(.POST, url, parameters: params).validate().responseJSON { response in
            if self.logging{
                let outData = response.data
                let outString = NSString(data: outData!, encoding: NSUTF8StringEncoding)
                print(outString)
            }
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    if let realCaller = caller{
                        if let arrayValue = value as? NSArray {
                            
                            realCaller.setArrayResponse(arrayValue, reqId: reqId)
                        }else if value.isKindOfClass(NSNull){
                            realCaller.setArrayResponse([], reqId: reqId)
                        }else{
                            
                            realCaller.setArrayResponse(["Error"], reqId: reqId)
                        }
                    }
                }
            case .Failure(let error):
                print(error)
                result =  OutputResult(status: false)
                result.items = []
                if let realCaller = caller{
                    realCaller.setArrayResponse(["Error"], reqId: reqId)
                }
            }
            print("result was \(response.result)")
        }
        return result
    }
    static func isInternetAvailable() -> Bool
    {
        let myStatus = Reach().connectionStatus()
        if !(myStatus.description == ReachabilityStatus.Offline.description) {
            return true;
        } else {
            return false;
        }
    }
}

