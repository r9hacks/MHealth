//
//  DataHolder.swift
//  MHealth
//
//  Created by Ahmed on 3/4/17.
//  Copyright © 2017 PIFSS. All rights reserved.
//

import Foundation


protocol DataHolder {
    func toDictionary() -> NSDictionary
    func loadDictionary(values:NSDictionary)
    
}