//
//  ViewController.swift
//  MHealth
//
//  Created by Ahmed on 3/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkCaller {

    override func viewDidLoad() {
        super.viewDidLoad()
//        Networking().AMJSONArray(Const.URLs.EditStatus,
//                                 httpMethod: "PUT",
//                                 jsonData: ["donationId":1,"status":"iOS Again !!"],
//                                 reqId: 1, caller: self)
//        
        
    }
    
    func setArrayResponse(resp: NSArray, reqId: Int) {
        print("Get array resp")
        if resp.count == 1{
            if let isError:String = resp.firstObject as? String {
                if isError == "Error" {
                    //SwiftSpinner.hide();
                    let alert:UIAlertController = Alert().getAlert("Error", msg: "Connection Failed.")
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    return
                }
            }
        }
    }

    func setDictResponse(resp: NSDictionary, reqId: Int) {
        print("Get dict resp")
        if resp.valueForKey("Error") != nil {
            //SwiftSpinner.hide();
            let alert:UIAlertController = Alert().getAlert("Error", msg: "Connection Failed.")
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

