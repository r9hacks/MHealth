//
//  Printer.swift
//  MHealth
//
//  Created by Ahmed on 3/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import UIKit

class Printer: NSObject {

    func printNSArray(array:NSArray){
        for item in array {
            print(item)
        }
    }
    
    func printList(array:[AnyObject]){
        for item in array{
            print(item)
        }
    }
    
}
